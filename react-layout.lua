obs = obslua
math = require("math")

-- Configuração inicial
scene_name = ""   -- Nome da cena onde os browsers estão
spacing = 30        -- Espaçamento entre os browsers (em pixels)

-- Lista de browsers ativos (visíveis)
browser_sources = {}

-- Proporção 16:9
aspect_ratio = 16 / 9

-- Flag para indicar se o script ainda está carregado
script_active = true

function reorganize_browsers()
    if not script_active then return end

    local scene = obs.obs_get_scene_by_name(scene_name)
    if not scene then
        return
    end

    local scene_items = obs.obs_scene_enum_items(scene)
    if not scene_items then
        obs.obs_scene_release(scene)
        return
    end

    local active_browsers = {}
    local inactive_browsers = {}
    local window_capture = nil

    -- Filtra os browsers ativos (visíveis) e inativos, além de procurar a captura de janela
    for _, scene_item in ipairs(scene_items) do
        local source = obs.obs_sceneitem_get_source(scene_item)
        local source_name = obs.obs_source_get_name(source)

        if string.match(source_name, "^CAM_") then
            if obs.obs_sceneitem_visible(scene_item) then
                table.insert(active_browsers, scene_item)
            else
                table.insert(inactive_browsers, scene_item)
            end
        elseif string.match(source_name, "^CAPTURE") then
            if obs.obs_sceneitem_visible(scene_item) then
                window_capture = scene_item
            end
        end
    end

    -- Ordena os browsers ativos em ordem alfabética pelo nome
    table.sort(active_browsers, function(a, b)
        local name_a = obs.obs_source_get_name(obs.obs_sceneitem_get_source(a))
        local name_b = obs.obs_source_get_name(obs.obs_sceneitem_get_source(b))
        return name_a < name_b
    end)

    -- Lógica de reposicionamento
    handle_browsers(active_browsers, inactive_browsers, window_capture)

    obs.sceneitem_list_release(scene_items)
    obs.obs_scene_release(scene)
end

function handle_browsers(active_browsers, inactive_browsers, window_capture)
    local total_browsers = #active_browsers

    local screen_width = 1920
    local screen_height = 1080

    -- Calcular o espaço vertical disponível para as browsers (com margens superior e inferior)
    local vertical_margin = spacing  -- Margem superior e inferior fixadas em 90 pixels
    local available_height = screen_height - (vertical_margin * 2) - (total_browsers - 1) * spacing
    local browser_height = available_height / (total_browsers + 2)
    local browser_width = browser_height * aspect_ratio

    if total_browsers == 0 then
        browser_width = 0
        browser_height = 0
    end

    -- Ajuste para garantir que a largura do browser não exceda 450 pixels
    if browser_width > 450 then
        browser_width = 450
        browser_height = browser_width / aspect_ratio
    end

    -- Calcular o espaço vertical considerando o ajuste de altura dos browsers
    local adjusted_vertical_space = (browser_height + spacing) * total_browsers - spacing
    local top_margin = (screen_height - adjusted_vertical_space) / 2

    -- Posicionar as browsers na coluna da esquerda
    for index, browser in ipairs(active_browsers) do
        local x = spacing
        local y = top_margin + (index - 1) * (browser_height + spacing)

        -- Redimensiona e posiciona o browser
        show_browser(browser, x, y, browser_width / screen_width, browser_height / screen_height)
    end

    -- Posiciona browsers invisíveis fora da tela
    for _, browser in ipairs(inactive_browsers) do
        hide_browser(browser)
    end

    -- Se houver captura de janela, posicionar e redimensionar
    if window_capture then
        local window_width, window_height
        if total_browsers == 0 then
	    window_width = screen_width * (5/6)
            window_height = window_width * (9/16)
        else
            window_width = screen_width - (3 * spacing + browser_width)
            window_height = window_width * (9/16)
        end

        local scale_x = window_width / screen_width
        local scale_y = window_height / screen_height

        -- Posição da janela
        local x_pos, y_pos
        if total_browsers == 0 then
            x_pos = (screen_width - window_width) / 2
            y_pos = (screen_height - window_height) / 2
        else
            x_pos = 2 * spacing + browser_width
            y_pos = (screen_height - window_height) / 2
        end

        -- Configura a posição e escala da captura de janela
        show_browser(window_capture, x_pos, y_pos, scale_x, scale_y)
    end
end

function show_browser(scene_item, x, y, width, height)
    if not scene_item then return end

    -- Desfaz crop da fonte caso tenha acabado de sair de um cenário com 2 fontes visíveis
    local crop = obs.obs_sceneitem_crop()
    crop.left = 0
    crop.right = 0
    crop.top = 0
    crop.bottom = 0
    obs.obs_sceneitem_set_crop(scene_item, crop)

    -- Configura a posição
    local position = obs.vec2()
    position.x = x
    position.y = y
    obs.obs_sceneitem_set_pos(scene_item, position)

    -- Configura a escala de acordo com a largura e altura relativas à resolução da fonte
    local scale = obs.vec2()
    scale.x = width
    scale.y = height
    obs.obs_sceneitem_set_scale(scene_item, scale)
end

function hide_browser(scene_item)
    if not scene_item then return end

    -- Define o tamanho como 0
    local scale = obs.vec2()
    scale.x = 0
    scale.y = 0
    obs.obs_sceneitem_set_scale(scene_item, scale)

    -- Move o browser para fora da tela
    local position = obs.vec2()
    position.x = -1  -- Coordenada fora da tela
    position.y = -1
    obs.obs_sceneitem_set_pos(scene_item, position)
end

function refresh_browsers()
    if not script_active then return end

    local scene = obs.obs_get_scene_by_name(scene_name)
    if not scene then
        return
    end

    local scene_items = obs.obs_scene_enum_items(scene)
    if not scene_items then
        obs.obs_scene_release(scene)
        return
    end

    local found_browsers = {}

    for _, scene_item in ipairs(scene_items) do
        local source = obs.obs_sceneitem_get_source(scene_item)
        local source_name = obs.obs_source_get_name(source)

        if string.match(source_name, "^CAM_") then
            if obs.obs_sceneitem_visible(scene_item) then
                found_browsers[source_name] = true
                browser_sources[source_name] = true
            else
                browser_sources[source_name] = nil
            end
        end
    end

    for source_name in pairs(browser_sources) do
        if not found_browsers[source_name] then
            browser_sources[source_name] = nil
        end
    end

    obs.sceneitem_list_release(scene_items)
    obs.obs_scene_release(scene)

    reorganize_browsers()
end

-- Função para salvar de forma persistente os valores da cena selecionada e do espaçamento
function script_save(settings)
    obs.obs_data_set_string(settings, "scene", scene_name)
    obs.obs_data_set_int(settings, "spacing", spacing)
end

-- Inicializa o script
function script_load(settings)
    scene_name = obs.obs_data_get_string(settings, "scene")
    spacing = obs.obs_data_get_int(settings, "spacing")
    script_active = true
    obs.timer_add(refresh_browsers, 50)
end

-- Finaliza o script
function script_unload()
    script_active = false
    obs.timer_remove(refresh_browsers)
end

function on_spacing_changed(props, prop, settings)
    spacing = obs.obs_data_get_int(settings, "spacing")
    reorganize_browsers()
end

function on_scene_changed(props, prop, settings)
    scene_name = obs.obs_data_get_string(settings, "scene")
    refresh_browsers()
end

-- Função para adicionar as propriedades do script no menu de configurações
function script_properties()
    local props = obs.obs_properties_create()

    -- Adiciona a propriedade para definir o espaçamento com callback
    local spacing_prop = obs.obs_properties_add_int(props, "spacing", "Espaçamento entre browsers", 0, 60, 1)
    obs.obs_property_set_modified_callback(spacing_prop, on_spacing_changed)

    -- Adiciona a propriedade para selecionar a cena com callback
    local scenes = obs.obs_frontend_get_scenes()
    local scene_list = obs.obs_properties_add_list(props, "scene", "Cena", obs.OBS_COMBO_TYPE_EDITABLE, obs.OBS_COMBO_FORMAT_STRING)

    for _, scene in ipairs(scenes) do
        local scene_name = obs.obs_source_get_name(scene)
        obs.obs_property_list_add_string(scene_list, scene_name, scene_name)
    end

    obs.obs_property_set_modified_callback(scene_list, on_scene_changed)
    obs.source_list_release(scenes)

    return props
end
