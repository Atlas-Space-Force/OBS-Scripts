obs = obslua
math = require("math")

-- =============================================
-- CONSTANTS AND CONFIGURATION
-- =============================================

local INTERVAL_MS = 100
local ASPECT_RATIO = 16 / 9
local REACTION_CROP_RATIO = 3/4 -- Crop the width for reaction sources
local HIGHLIGHT_CROP_RATIO = 3/4 -- Crop the width for highlight sources

-- Supported languages and translations
local LANGUAGES = {
    ["English"] = {
        -- 1. Language selector
        "Language",

        -- Grid Section
        "== Grid Settings ==",           -- 2
        "Enable Grid Layout",             -- 3
        "Grid Scene",                     -- 4
        "General Camera Prefix",          -- 5 (Used for the top-level general prefix)
        "Grid Spacing",                   -- 6
        "Grid Margin",                    -- 7
        "Grid X Offset",                  -- 8
        "Grid Y Offset",                  -- 9
        "Split Screen for 2 Cameras",     -- 10

        -- Reaction Section
        "== Reaction Settings ==",        -- 11
        "Enable Reaction Layout",         -- 12
        "Reaction Scene",                 -- 13
        "Reaction Camera Prefix (Unused)",-- 14
        "Reacted Content Prefix",         -- 15
        "Reaction Spacing",               -- 16
        "Reaction X Offset",              -- 17
        "Reaction Y Offset",              -- 18
        "Distribute cameras between both sides", -- 19

        -- Highlight Section
        "== Highlight Settings ==",       -- 20
        "Enable Highlight Layout",        -- 21
        "Highlight Scene",                -- 22
        "Highlight Camera Prefix (Unused)",-- 23
        "Highlight Main Source Prefix",   -- 24
        "Highlight Spacing",              -- 25
        "Highlight X Offset",             -- 26
        "Highlight Y Offset",             -- 27
        "Distribute cameras between both sides (Highlight)" -- 28
    },
    ["Português"] = {
        -- 1. Seletor de idioma
        "Idioma",

        -- Seção Grid
        "== Configurações de Grade ==",   -- 2
        "Ativar Layout de Grade",         -- 3
        "Cena de Grade",                  -- 4
        "Prefixo de Câmera Geral",        -- 5
        "Espaçamento da Grade",           -- 6
        "Margem da Grade",                -- 7
        "Deslocamento X da Grade",        -- 8
        "Deslocamento Y da Grade",        -- 9
        "Tela Dividida para 2 Câmeras",   -- 10

        -- Seção Reaction
        "== Configurações de Reação ==",  -- 11
        "Ativar Layout de Reação",        -- 12
        "Cena de Reação",                 -- 13
        "Prefixo de Câmera de Reação (Não usado)", -- 14
        "Prefixo do Conteúdo Reagido",    -- 15
        "Espaçamento da Reação",          -- 16
        "Deslocamento X da Reação",       -- 17
        "Deslocamento Y da Reação",       -- 18
        "Distribuir câmeras entre os dois lados", -- 19

        -- Seção Highlight
        "== Configurações de Destaque ==", -- 20
        "Ativar Layout de Destaque",      -- 21
        "Cena de Destaque",               -- 22
        "Prefixo de Câmera de Destaque (Não usado)", -- 23
        "Prefixo da Fonte Principal de Destaque",   -- 24
        "Espaçamento de Destaque",        -- 25
        "Deslocamento X de Destaque",     -- 26
        "Deslocamento Y de Destaque",     -- 27
        "Distribuir câmeras entre os dois lados (Destaque)" -- 28
    },
    ["Español"] = {
        "Idioma", -- 1
        "== Configuraciones de Cuadrícula ==", -- 2
        "Activar Diseño de Cuadrícula",   -- 3
        "Escena de Cuadrícula",           -- 4
        "Prefijo General de Cámara",      -- 5
        "Espaciado de Cuadrícula",        -- 6
        "Margen de Cuadrícula",           -- 7
        "Desplazamiento X de Cuadrícula", -- 8
        "Desplazamiento Y de Cuadrícula", -- 9
        "Pantalla Dividida para 2 Cámaras", -- 10
        "== Configuraciones de Reacción ==", -- 11
        "Activar Diseño de Reacción",     -- 12
        "Escena de Reacción",             -- 13
        "Prefijo de Cámara de Reacción (No usado)", -- 14
        "Prefijo de Contenido Reaccionado", -- 15
        "Espaciado de Reacción",          -- 16
        "Desplazamiento X de Reacción",   -- 17
        "Desplazamiento Y de Reacción",   -- 18
        "Distribuir cámaras entre ambos lados", -- 19
        "== Configuraciones de Destacado ==", -- 20
        "Activar Diseño de Destacado",    -- 21
        "Escena de Destacado",            -- 22
        "Prefijo de Cámara de Destacado (No usado)", -- 23
        "Prefijo de Fuente Principal de Destacado", -- 24
        "Espaciado de Destacado",         -- 25
        "Desplazamiento X de Destacado",  -- 26
        "Desplazamiento Y de Destacado",  -- 27
        "Distribuir cámaras entre ambos lados (Destacado)" -- 28
    },
    ["中文"] = {
        "语言", -- 1
        "== 网格设置 ==",                 -- 2
        "启用网格布局",                   -- 3
        "网格场景",                       -- 4
        "通用摄像头前缀",                 -- 5
        "网格间距",                       -- 6
        "网格边距",                       -- 7
        "网格X轴偏移",                    -- 8
        "网格Y轴偏移",                    -- 9
        "双摄像头分屏",                   -- 10
        "== 反应设置 ==",                 -- 11
        "启用反应布局",                   -- 12
        "反应场景",                       -- 13
        "反应摄像头前缀 (未使用)",        -- 14
        "反应内容前缀",                   -- 15
        "反应间距",                       -- 16
        "反应X轴偏移",                    -- 17
        "反应Y轴偏移",                    -- 18
        "将摄像头分布在两侧",             -- 19
        "== 亮点设置 ==",                 -- 20
        "启用亮点布局",                   -- 21
        "亮点场景",                       -- 22
        "亮点摄像头前缀 (未使用)",        -- 23
        "亮点主源前缀",                   -- 24
        "亮点间距",                       -- 25
        "亮点X轴偏移",                    -- 26
        "亮点Y轴偏移",                    -- 27
        "将摄像头分布在两侧 (亮点)"      -- 28
    },
    ["Русский"] = {
        "Язык", -- 1
        "== Настройки сетки ==",          -- 2
        "Включить макет сетки",           -- 3
        "Сцена сетки",                    -- 4
        "Общий префикс камеры",           -- 5
        "Интервал сетки",                 -- 6
        "Отступ сетки",                   -- 7
        "Смещение X сетки",               -- 8
        "Смещение Y сетки",               -- 9
        "Разделенный экран для 2 камер",  -- 10
        "== Настройки реакции ==",        -- 11
        "Включить макет реакции",         -- 12
        "Сцена реакции",                  -- 13
        "Префикс камеры реакции (Не используется)", -- 14
        "Префикс реагируемого контента",  -- 15
        "Интервал реакции",               -- 16
        "Смещение X реакции",             -- 17
        "Смещение Y реакции",             -- 18
        "Распределить камеры по обеим сторонам", -- 19
        "== Настройки выделения ==",      -- 20
        "Включить макет выделения",       -- 21
        "Сцена выделения",                -- 22
        "Префикс камеры выделения (Не используется)", -- 23
        "Префикс основного источника выделения", -- 24
        "Интервал выделения",             -- 25
        "Смещение X выделения",           -- 26
        "Смещение Y выделения",           -- 27
        "Распределить камеры по обеим сторонам (выделение)" -- 28
    },
    ["日本語"] = {
        "言語", -- 1
        "== グリッド設定 ==",             -- 2
        "グリッドレイアウトを有効にする", -- 3
        "グリッドシーン",                 -- 4
        "一般カメラ接頭辞",               -- 5
        "グリッド間隔",                   -- 6
        "グリッド余白",                   -- 7
        "グリッドX軸オフセット",          -- 8
        "グリッドY軸オフセット",          -- 9
        "2カメラ分割画面",                -- 10
        "== リアクション設定 ==",         -- 11
        "リアクションレイアウトを有効にする", -- 12
        "リアクションシーン",             -- 13
        "リアクションカメラ接頭辞 (未使用)", -- 14
        "リアクション対象コンテンツ接頭辞", -- 15
        "リアクション間隔",               -- 16
        "リアクションX軸オフセット",      -- 17
        "リアクションY軸オフセット",      -- 18
        "カメラを両側に配置",             -- 19
        "== ハイライト設定 ==",           -- 20
        "ハイライトレイアウトを有効にする", -- 21
        "ハイライトシーン",               -- 22
        "ハイライトカメラ接頭辞 (未使用)",-- 23
        "ハイライトメインソース接頭辞",   -- 24
        "ハイライト間隔",                 -- 25
        "ハイライトX軸オフセット",        -- 26
        "ハイライトY軸オフセット",        -- 27
        "カメラを両側に配置 (ハイライト)" -- 28
    },
    ["Deutsch"] = {
        "Sprache", -- 1
        "== Raster-Einstellungen ==",     -- 2
        "Rasterlayout aktivieren",        -- 3
        "Raster-Szene",                   -- 4
        "Allgemeines Kamera-Präfix",      -- 5
        "Raster-Abstand",                 -- 6
        "Raster-Rand",                    -- 7
        "Raster-X-Versatz",               -- 8
        "Raster-Y-Versatz",               -- 9
        "Geteilter Bildschirm für 2 Kameras", -- 10
        "== Reaktions-Einstellungen ==",  -- 11
        "Reaktionslayout aktivieren",     -- 12
        "Reaktions-Szene",                -- 13
        "Reaktionskamera-Präfix (Nicht verwendet)", -- 14
        "Präfix für reagierten Inhalt",   -- 15
        "Reaktions-Abstand",              -- 16
        "Reaktions-X-Versatz",            -- 17
        "Reaktions-Y-Versatz",            -- 18
        "Kameras auf beide Seiten verteilen", -- 19
        "== Hervorhebungs-Einstellungen ==", -- 20
        "Hervorhebungs-Layout aktivieren",-- 21
        "Hervorhebungs-Szene",            -- 22
        "Hervorhebungskamera-Präfix (Nicht verwendet)", -- 23
        "Hervorhebungs-Hauptquellen-Präfix", -- 24
        "Hervorhebungs-Abstand",          -- 25
        "Hervorhebungs-X-Versatz",        -- 26
        "Hervorhebungs-Y-Versatz",        -- 27
        "Kameras auf beide Seiten verteilen (Hervorhebung)" -- 28
    }
}

local LANGUAGE_NAMES = {"English", "Português", "Español", "中文", "Русский", "日本語", "Deutsch"}

-- =============================================
-- STATE MANAGEMENT
-- =============================================

local global_props_ref = nil

local state = {
    -- Language settings
    current_language = "English",
    translations = LANGUAGES["English"],

    source_prefix = "", -- Unified camera prefix

    -- Grid settings
    grid = {
        scene_name = "",
        spacing = 0,
        margin = 0,
        x_offset = 0,
        y_offset = 0,
        split_screen = false,
        enabled = false -- Actual operational state
    },

    -- Reaction settings
    reaction = {
        scene_name = "",
        content_prefix = "", -- Prefix for the main content window
        spacing = 0,
        x_offset = 0,
        y_offset = 0,
        split_cameras = false,
        enabled = false -- Actual operational state
    },

    -- Highlight settings
    highlight = {
        scene_name = "",
        main_source_prefix = "", -- Prefix for the main highlight source
        spacing = 0,
        x_offset = 0,
        y_offset = 0,
        split_cameras = false,
        enabled = false -- Actual operational state
    },

    -- Temporary UI state & last known checkbox states from settings
    ui = {
        temp_general_camera_prefix = "",
        temp_content_prefix = "",
        temp_highlight_main_prefix = "",
        elements = {}, 
        grid_checkbox_latest = false,    -- Stores the boolean value of "grid_enabled" setting
        reaction_checkbox_latest = false, -- Stores the boolean value of "reaction_enabled" setting
        highlight_checkbox_latest = false -- Stores the boolean value of "highlight_enabled" setting
    },

    -- System state
    screen_width = 1920,
    screen_height = 1080,
    script_active = true
}

-- =============================================
-- UTILITY FUNCTIONS
-- =============================================
local function update_screen_dimensions()
    local video_info = obs.obs_video_info()
    if obs.obs_get_video_info(video_info) then
        state.screen_width = video_info.base_width
        state.screen_height = video_info.base_height
    end
end

local function hide_browser(scene_item)
    if not scene_item then return end
    local scale = obs.vec2(); scale.x = 0; scale.y = 0
    obs.obs_sceneitem_set_scale(scene_item, scale)
    local position = obs.vec2(); position.x = -state.screen_width - 100; position.y = -state.screen_height - 100
    obs.obs_sceneitem_set_pos(scene_item, position)
end

local function set_scale(scene_item, x, y)
    if not scene_item then return end
    local scale = obs.vec2(); scale.x = x; scale.y = y
    obs.obs_sceneitem_set_scale(scene_item, scale)
end

local function update_ui_texts(props_obj)
    if not props_obj then return end 
    for i = 1, #state.translations do
        if state.ui.elements[i] then 
            obs.obs_property_set_description(state.ui.elements[i], state.translations[i])
        end
    end
end


-- =============================================
-- LAYOUT OPERATIONAL STATE DETERMINATION
-- =============================================
local function update_actual_layout_operational_states(grid_checkbox_on, reaction_checkbox_on, highlight_checkbox_on)
    -- Grid
    if grid_checkbox_on and state.source_prefix ~= "" then
        state.grid.enabled = true
    else
        state.grid.enabled = false
    end

    -- Reaction
    if reaction_checkbox_on and state.source_prefix ~= "" and state.reaction.content_prefix ~= "" then
        state.reaction.enabled = true
    else
        state.reaction.enabled = false
    end

    -- Highlight
    if highlight_checkbox_on and state.source_prefix ~= "" and state.highlight.main_source_prefix ~= "" then
        state.highlight.enabled = true
    else
        state.highlight.enabled = false
    end
end


-- =============================================
-- LAYOUT FUNCTIONS (process_grid_browsers, process_react_browsers, process_highlight_browsers and helpers)
-- (No changes in this section for the reported UI visibility issue)
-- =============================================
local function process_grid_browsers(target_scene_name_override)
    if not state.script_active or not state.grid.enabled then
        return
    end
    
    local scene_name_to_use = target_scene_name_override or state.grid.scene_name
    if scene_name_to_use == "" then
        return
    end

    local scene = obs.obs_get_scene_by_name(scene_name_to_use)
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

    for _, scene_item in ipairs(scene_items) do
        local source = obs.obs_sceneitem_get_source(scene_item)
        local source_name = obs.obs_source_get_name(source)

        if string.match(source_name, "^" .. state.source_prefix) then
            if obs.obs_sceneitem_visible(scene_item) then
                table.insert(active_browsers, scene_item)
            else
                table.insert(inactive_browsers, scene_item)
            end
        end
    end

    table.sort(active_browsers, function(a, b)
        local name_a = obs.obs_source_get_name(obs.obs_sceneitem_get_source(a))
        local name_b = obs.obs_source_get_name(obs.obs_sceneitem_get_source(b))
        return name_a < name_b
    end)

    if #active_browsers == 0 then
        for _, browser_item in ipairs(inactive_browsers) do
            hide_browser(browser_item)
        end
        obs.sceneitem_list_release(scene_items)
        obs.obs_scene_release(scene)
        return
    end

    if #active_browsers == 2 and state.grid.split_screen then
        for index, browser in ipairs(active_browsers) do
            local source = obs.obs_sceneitem_get_source(browser)
            local width = obs.obs_source_get_width(source)
            local height = obs.obs_source_get_height(source)

            local position = obs.vec2()
            position.x = (index - 1) * (state.screen_width / 2) + state.grid.x_offset
            position.y = state.grid.y_offset
            obs.obs_sceneitem_set_pos(browser, position)

            local crop = obs.obs_sceneitem_crop()
            if width > 0 then
                 crop.left = width / 4
                 crop.right = width / 4
            else
                crop.left = 0
                crop.right = 0
            end
            crop.top = 0
            crop.bottom = 0
            obs.obs_sceneitem_set_crop(browser, crop)
            if width > 0 and height > 0 then
                 local effective_source_width_after_crop = width / 2
                 if effective_source_width_after_crop > 0 then
                    set_scale(browser, (state.screen_width / 2) / effective_source_width_after_crop, state.screen_height / height)
                 else
                    set_scale(browser,0,0)
                 end
            else
                set_scale(browser, 0, 0)
            end
        end
    else
        local cols = math.ceil(math.sqrt(#active_browsers))
        local rows = math.ceil(#active_browsers / cols)
        if cols == 0 then cols = 1 end
        if rows == 0 then rows = 1 end

        local unavailable_space = 2 * state.grid.margin
        local available_width = state.screen_width - unavailable_space
        local available_height = state.screen_height - unavailable_space

        local total_spacing_x = (cols - 1) * state.grid.spacing
        local total_spacing_y = (rows - 1) * state.grid.spacing

        local browser_width = (available_width - total_spacing_x) / cols
        local browser_height = (available_height - total_spacing_y) / rows

        if browser_width <= 0 or browser_height <= 0 then
            for _, browser_item in ipairs(active_browsers) do hide_browser(browser_item) end
            for _, browser_item in ipairs(inactive_browsers) do hide_browser(browser_item) end
            obs.sceneitem_list_release(scene_items)
            obs.obs_scene_release(scene)
            return
        end

        if browser_width / ASPECT_RATIO <= browser_height then
            browser_height = browser_width / ASPECT_RATIO
        else
            browser_width = browser_height * ASPECT_RATIO
        end
         if browser_width <= 0 or browser_height <= 0 then 
            for _, browser_item in ipairs(active_browsers) do hide_browser(browser_item) end
            for _, browser_item in ipairs(inactive_browsers) do hide_browser(browser_item) end
            obs.sceneitem_list_release(scene_items)
            obs.obs_scene_release(scene)
            return
        end

        local total_content_height = rows * browser_height + (rows - 1) * state.grid.spacing
        local vertical_padding = (available_height - total_content_height) / 2

        for row_idx = 0, rows - 1 do
            local row_items_count = math.min(cols, #active_browsers - row_idx * cols)
            local total_row_width = row_items_count * browser_width + (row_items_count - 1) * state.grid.spacing
            local horizontal_padding = (available_width - total_row_width) / 2

            for col_idx = 0, row_items_count - 1 do
                local index = row_idx * cols + col_idx
                if index < #active_browsers then
                    local browser = active_browsers[index + 1]
                    if browser then
                        local source = obs.obs_sceneitem_get_source(browser)
                        local width = obs.obs_source_get_width(source)
                        local height = obs.obs_source_get_height(source)

                        local crop = obs.obs_sceneitem_crop() 
                        obs.obs_sceneitem_set_crop(browser, crop)

                        local position = obs.vec2()
                        position.x = state.grid.margin + horizontal_padding + col_idx * (browser_width + state.grid.spacing) + state.grid.x_offset
                        position.y = state.grid.margin + vertical_padding + row_idx * (browser_height + state.grid.spacing) + state.grid.y_offset

                        obs.obs_sceneitem_set_pos(browser, position)
                        if width > 0 and height > 0 and browser_width > 0 and browser_height > 0 then
                           set_scale(browser, browser_width / width, browser_height / height)
                        else
                           set_scale(browser, 0, 0)
                        end
                    end
                end
            end
        end
    end

    for _, browser in ipairs(inactive_browsers) do
        hide_browser(browser)
    end

    obs.sceneitem_list_release(scene_items)
    obs.obs_scene_release(scene)
end

local function handle_react_browsers_left(active_browsers, inactive_browsers, window_capture)
    local total_browsers = #active_browsers

    local available_height_for_cams = state.screen_height - state.reaction.spacing * (total_browsers + 1)
    local browser_height = 0
    if total_browsers > 0 then browser_height = available_height_for_cams / total_browsers end
    local browser_width = browser_height * ASPECT_RATIO

    if browser_width > state.screen_width / 4 then
        browser_width = state.screen_width / 4
        browser_height = browser_width / ASPECT_RATIO
    end
    if browser_width <= 0 or browser_height <= 0 then browser_width = 0; browser_height = 0; end

    local current_cam_y = ((state.screen_height - (total_browsers * browser_height + (math.max(0, total_browsers - 1)) * state.reaction.spacing)) / 2) + state.reaction.y_offset

    for _, browser in ipairs(active_browsers) do
        local x = state.reaction.spacing + state.reaction.x_offset
        local y = current_cam_y

        local source = obs.obs_sceneitem_get_source(browser)
        local source_width = obs.obs_source_get_width(source)
        local source_height = obs.obs_source_get_height(source)
        local effective_source_width = source_width

        local crop = obs.obs_sceneitem_crop()
        if source_width > 0 then
            crop.left = source_width * (1 - REACTION_CROP_RATIO) / 2
            crop.right = source_width * (1 - REACTION_CROP_RATIO) / 2
        end
        obs.obs_sceneitem_set_crop(browser, crop)

        local position = obs.vec2()
        position.x = x
        position.y = y
        obs.obs_sceneitem_set_pos(browser, position)

        if effective_source_width > 0 and source_height > 0 and browser_width > 0 and browser_height > 0 then
            set_scale(browser, browser_width / effective_source_width, browser_height / source_height)
        else
            set_scale(browser, 0, 0)
        end
        current_cam_y = current_cam_y + browser_height + state.reaction.spacing
    end

    for _, browser in ipairs(inactive_browsers) do hide_browser(browser) end

    if window_capture then
        local cam_total_width_on_side = 0
        if total_browsers > 0 and browser_width > 0 then cam_total_width_on_side = browser_width + state.reaction.spacing end

        local window_x = state.reaction.spacing + (cam_total_width_on_side * REACTION_CROP_RATIO) + state.reaction.x_offset
        local window_available_width = state.screen_width - (window_x - state.reaction.x_offset) - state.reaction.spacing

        if total_browsers == 0 then 
            window_available_width = state.screen_width - 2 * state.reaction.spacing
            window_x = state.reaction.spacing + state.reaction.x_offset
        end
        if window_available_width <=0 then window_available_width = 1 end

        local window_width = window_available_width
        local window_height = window_width / ASPECT_RATIO

        if window_height > state.screen_height - 2 * state.reaction.spacing then
            window_height = state.screen_height - 2 * state.reaction.spacing
            window_width = window_height * ASPECT_RATIO
            window_x = cam_total_width_on_side + state.reaction.spacing + ((window_available_width - window_width) / 2) + state.reaction.x_offset
             if total_browsers == 0 then window_x = (state.screen_width - window_width) / 2 + state.reaction.x_offset end
        end
        if window_width <=0 then window_width = 1 end
        if window_height <=0 then window_height = 1 / ASPECT_RATIO end
        
        local window_y = (state.screen_height - window_height) / 2 + state.reaction.y_offset

        local crop = obs.obs_sceneitem_crop()
        obs.obs_sceneitem_set_crop(window_capture, crop)
        local wc_source = obs.obs_sceneitem_get_source(window_capture)
        local wc_width = obs.obs_source_get_width(wc_source)
        local wc_height = obs.obs_source_get_height(wc_source)

        local position = obs.vec2()
        position.x = window_x
        position.y = window_y
        obs.obs_sceneitem_set_pos(window_capture, position)
        if wc_width > 0 and wc_height > 0 and window_width > 0 and window_height > 0 then
            set_scale(window_capture, window_width / wc_width, window_height / wc_height)
        else
            set_scale(window_capture, 0, 0)
        end
    end
end

local function handle_react_browsers_split(active_browsers, inactive_browsers, window_capture)
    local total_browsers = #active_browsers
    if total_browsers == 0 then
        if window_capture then
            local window_width = state.screen_width - 2 * state.reaction.spacing
            local window_height = window_width / ASPECT_RATIO
            if window_height > state.screen_height - 2 * state.reaction.spacing then
                window_height = state.screen_height - 2 * state.reaction.spacing
                window_width = window_height * ASPECT_RATIO
            end
            if window_width <=0 then window_width = 1 end; if window_height <=0 then window_height = 1/ASPECT_RATIO end

            local x_pos = (state.screen_width - window_width) / 2 + state.reaction.x_offset
            local y_pos = (state.screen_height - window_height) / 2 + state.reaction.y_offset
            local pos = obs.vec2(); pos.x = x_pos; pos.y = y_pos; obs.obs_sceneitem_set_pos(window_capture, pos)
            local crop = obs.obs_sceneitem_crop(); obs.obs_sceneitem_set_crop(window_capture, crop)
            local wc_s = obs.obs_sceneitem_get_source(window_capture); local wc_w = obs.obs_source_get_width(wc_s); local wc_h = obs.obs_source_get_height(wc_s)
            if wc_w > 0 and wc_h > 0 and window_width > 0 and window_height > 0 then set_scale(window_capture, window_width / wc_w, window_height / wc_h) else set_scale(window_capture, 0, 0) end
        end
        for _, browser in ipairs(inactive_browsers) do hide_browser(browser) end
        return
    end

    local cams_left_count = math.ceil(total_browsers / 2)
    local cams_right_count = math.floor(total_browsers / 2)
    local cams_per_column = math.max(cams_left_count, cams_right_count)

    local available_height_for_cams = state.screen_height - state.reaction.spacing * (cams_per_column + 1)
    local browser_height = 0
    if cams_per_column > 0 then browser_height = available_height_for_cams / cams_per_column end
    local browser_width = browser_height * ASPECT_RATIO

    if browser_width > state.screen_width / 4 then
        browser_width = state.screen_width / 4
        browser_height = browser_width / ASPECT_RATIO
    end
    if browser_width <= 0 or browser_height <= 0 then browser_width = 0; browser_height = 0; end
    
    local current_cam_y_left = ((state.screen_height - (cams_left_count * browser_height + (math.max(0, cams_left_count - 1)) * state.reaction.spacing)) / 2) + state.reaction.y_offset
    for i = 1, cams_left_count do
        local browser = active_browsers[i]
        local x = state.reaction.spacing + state.reaction.x_offset
        local y = current_cam_y_left
        local source = obs.obs_sceneitem_get_source(browser); local sw = obs.obs_source_get_width(source); local sh = obs.obs_source_get_height(source)
        local effective_sw = sw
        local crop = obs.obs_sceneitem_crop(); if sw > 0 then crop.left = sw * (1 - REACTION_CROP_RATIO) / 2; crop.right = sw * (1 - REACTION_CROP_RATIO) / 2; end; obs.obs_sceneitem_set_crop(browser, crop)
        local pos = obs.vec2(); pos.x = x; pos.y = y; obs.obs_sceneitem_set_pos(browser, pos)
        if effective_sw > 0 and sh > 0 and browser_width > 0 and browser_height > 0 then set_scale(browser, browser_width / effective_sw, browser_height / sh) else set_scale(browser, 0, 0) end
        current_cam_y_left = current_cam_y_left + browser_height + state.reaction.spacing
    end

    local current_cam_y_right = ((state.screen_height - (cams_right_count * browser_height + (math.max(0, cams_right_count - 1)) * state.reaction.spacing)) / 2) + state.reaction.y_offset
    for i = 1, cams_right_count do
        local browser = active_browsers[cams_left_count + i]
        local x = state.screen_width - (browser_width * REACTION_CROP_RATIO) - state.reaction.spacing + state.reaction.x_offset
        local y = current_cam_y_right
        local source = obs.obs_sceneitem_get_source(browser); local sw = obs.obs_source_get_width(source); local sh = obs.obs_source_get_height(source)
        local effective_sw = sw
        local crop = obs.obs_sceneitem_crop(); if sw > 0 then crop.left = sw * (1 - REACTION_CROP_RATIO) / 2; crop.right = sw * (1 - REACTION_CROP_RATIO) / 2; end; obs.obs_sceneitem_set_crop(browser, crop)
        local pos = obs.vec2(); pos.x = x; pos.y = y; obs.obs_sceneitem_set_pos(browser, pos)
        if effective_sw > 0 and sh > 0 and browser_width > 0 and browser_height > 0 then set_scale(browser, browser_width / effective_sw, browser_height / sh) else set_scale(browser, 0, 0) end
        current_cam_y_right = current_cam_y_right + browser_height + state.reaction.spacing
    end

    for _, browser in ipairs(inactive_browsers) do hide_browser(browser) end

    if window_capture then
        local left_cam_total_width = 0; if cams_left_count > 0 and browser_width > 0 then left_cam_total_width = (browser_width * REACTION_CROP_RATIO) + state.reaction.spacing end
        local right_cam_total_width = 0; if cams_right_count > 0 and browser_width > 0 then right_cam_total_width = (browser_width * REACTION_CROP_RATIO) + state.reaction.spacing end

        local window_x = left_cam_total_width + state.reaction.x_offset + state.reaction.spacing
        local window_available_width = state.screen_width - left_cam_total_width - right_cam_total_width - (state.reaction.spacing * 2)

        if total_browsers == 0 then 
             window_available_width = state.screen_width - 2 * state.reaction.spacing
             window_x = state.reaction.spacing + state.reaction.x_offset
        end
        if window_available_width <=0 then window_available_width = 1 end

        local window_width = window_available_width
        local window_height = window_width / ASPECT_RATIO

        if window_height > state.screen_height - 2 * state.reaction.spacing then
            window_height = state.screen_height - 2 * state.reaction.spacing
            window_width = window_height * ASPECT_RATIO
            window_x = left_cam_total_width + state.reaction.spacing + ((window_available_width - window_width) / 2) + state.reaction.x_offset
            if total_browsers == 0 then window_x = (state.screen_width - window_width) / 2 + state.reaction.x_offset end
        end
        if window_width <=0 then window_width = 1 end; if window_height <=0 then window_height = 1/ASPECT_RATIO end

        local window_y = (state.screen_height - window_height) / 2 + state.reaction.y_offset

        local crop = obs.obs_sceneitem_crop(); obs.obs_sceneitem_set_crop(window_capture, crop)
        local wc_s = obs.obs_sceneitem_get_source(window_capture); local wc_w = obs.obs_source_get_width(wc_s); local wc_h = obs.obs_source_get_height(wc_s)
        local pos = obs.vec2(); pos.x = window_x; pos.y = window_y; obs.obs_sceneitem_set_pos(window_capture, pos)
        if wc_w > 0 and wc_h > 0 and window_width > 0 and window_height > 0 then set_scale(window_capture, window_width / wc_w, window_height / wc_h) else set_scale(window_capture, 0, 0) end
    end
end

local function process_react_browsers()
    if not state.script_active or not state.reaction.enabled then
        return
    end
    if state.reaction.scene_name == "" then
        return
    end

    local scene = obs.obs_get_scene_by_name(state.reaction.scene_name)
    if not scene then return end
    local scene_items = obs.obs_scene_enum_items(scene)
    if not scene_items then obs.obs_scene_release(scene); return end

    local active_reaction_browsers = {}
    local inactive_reaction_browsers = {}
    local window_capture = false

    for _, scene_item in ipairs(scene_items) do
        local source = obs.obs_sceneitem_get_source(scene_item)
        local source_name = obs.obs_source_get_name(source)

        if string.match(source_name, "^" .. state.source_prefix) and not string.match(source_name, "^" .. state.reaction.content_prefix) then
            if obs.obs_sceneitem_visible(scene_item) then
                table.insert(active_reaction_browsers, scene_item)
            else
                table.insert(inactive_reaction_browsers, scene_item)
            end
        elseif state.reaction.content_prefix ~= "" and string.match(source_name, "^" .. state.reaction.content_prefix) then
            if obs.obs_sceneitem_visible(scene_item) then
                window_capture = scene_item
            else
                hide_browser(scene_item) 
            end
        else 
            if string.match(source_name, "^" .. state.source_prefix) then hide_browser(scene_item) end
        end
    end

    table.sort(active_reaction_browsers, function(a, b)
        local name_a = obs.obs_source_get_name(obs.obs_sceneitem_get_source(a))
        local name_b = obs.obs_source_get_name(obs.obs_sceneitem_get_source(b))
        return name_a < name_b
    end)
    
    if not window_capture then
        if state.grid.enabled then
            obs.sceneitem_list_release(scene_items)
            obs.obs_scene_release(scene)
            process_grid_browsers(state.reaction.scene_name) 
            return 
        end
    end

    if #active_reaction_browsers == 0 and not window_capture then
         for _, browser_item in ipairs(inactive_reaction_browsers) do hide_browser(browser_item) end
         obs.sceneitem_list_release(scene_items)
         obs.obs_scene_release(scene)
         return
    end

    if state.reaction.split_cameras then
        handle_react_browsers_split(active_reaction_browsers, inactive_reaction_browsers, window_capture)
    else
        handle_react_browsers_left(active_reaction_browsers, inactive_reaction_browsers, window_capture)
    end

    obs.sceneitem_list_release(scene_items)
    obs.obs_scene_release(scene)
end

local function handle_highlight_browsers_left(active_browsers, inactive_browsers, main_source_item)
    local total_browsers = #active_browsers

    local available_height_for_cams = state.screen_height - state.highlight.spacing * (total_browsers + 1)
    local browser_height = 0
    if total_browsers > 0 then browser_height = available_height_for_cams / total_browsers end
    local browser_width = browser_height * ASPECT_RATIO

    if browser_width > state.screen_width / 4 then
        browser_width = state.screen_width / 4
        browser_height = browser_width / ASPECT_RATIO
    end
    if browser_width <= 0 or browser_height <= 0 then browser_width = 0; browser_height = 0; end

    local current_cam_y = ((state.screen_height - (total_browsers * browser_height + (math.max(0, total_browsers - 1)) * state.highlight.spacing)) / 2) + state.highlight.y_offset

    for _, browser in ipairs(active_browsers) do
        local x = state.highlight.spacing + state.highlight.x_offset
        local y = current_cam_y

        local source = obs.obs_sceneitem_get_source(browser)
        local source_width = obs.obs_source_get_width(source)
        local source_height = obs.obs_source_get_height(source)
        local effective_source_width = source_width 

        local crop = obs.obs_sceneitem_crop()
        if source_width > 0 then
            crop.left = source_width * (1 - HIGHLIGHT_CROP_RATIO) / 2
            crop.right = source_width * (1 - HIGHLIGHT_CROP_RATIO) / 2
        end
        obs.obs_sceneitem_set_crop(browser, crop)

        local position = obs.vec2(); position.x = x; position.y = y
        obs.obs_sceneitem_set_pos(browser, position)

        if effective_source_width > 0 and source_height > 0 and browser_width > 0 and browser_height > 0 then
            set_scale(browser, browser_width / effective_source_width, browser_height / source_height)
        else
            set_scale(browser, 0, 0)
        end
        current_cam_y = current_cam_y + browser_height + state.highlight.spacing
    end

    for _, browser in ipairs(inactive_browsers) do hide_browser(browser) end

    if main_source_item then
        local cam_total_width_on_side = 0 
        if total_browsers > 0 and browser_width > 0 then
             cam_total_width_on_side = browser_width + state.highlight.spacing 
        end

        local main_x = state.highlight.spacing + (cam_total_width_on_side * HIGHLIGHT_CROP_RATIO) + state.highlight.x_offset 
        local main_available_width = state.screen_width - (main_x - state.highlight.x_offset) - state.highlight.spacing 

        if total_browsers == 0 then 
            main_available_width = state.screen_width - 2 * state.highlight.spacing
            main_x = state.highlight.spacing + state.highlight.x_offset
        end
        if main_available_width <=0 then main_available_width = 1 end

        local main_width = main_available_width
        local main_height = main_width / ASPECT_RATIO

        if main_height > state.screen_height - 2 * state.highlight.spacing then
            main_height = state.screen_height - 2 * state.highlight.spacing
            main_width = main_height * ASPECT_RATIO
            main_x = cam_total_width_on_side + state.highlight.spacing + state.highlight.x_offset 
            if total_browsers == 0 then main_x = (state.screen_width - main_width) / 2 + state.highlight.x_offset end 
        end
        if main_width <=0 then main_width = 1 end; if main_height <=0 then main_height = 1/ASPECT_RATIO end

        local main_y = (state.screen_height - main_height) / 2 + state.highlight.y_offset

        local crop = obs.obs_sceneitem_crop(); obs.obs_sceneitem_set_crop(main_source_item, crop)
        local ms_s = obs.obs_sceneitem_get_source(main_source_item); local ms_w = obs.obs_source_get_width(ms_s); local ms_h = obs.obs_source_get_height(ms_s)
        local pos = obs.vec2(); pos.x = main_x; pos.y = main_y; obs.obs_sceneitem_set_pos(main_source_item, pos)
        if ms_w > 0 and ms_h > 0 and main_width > 0 and main_height > 0 then set_scale(main_source_item, main_width / ms_w, main_height / ms_h) else set_scale(main_source_item, 0, 0) end
    end
end

local function handle_highlight_browsers_split(active_browsers, inactive_browsers, main_source_item)
    local total_browsers = #active_browsers
    if total_browsers == 0 then
        if main_source_item then
            local window_width = state.screen_width - 2 * state.highlight.spacing
            local window_height = window_width / ASPECT_RATIO
            if window_height > state.screen_height - 2 * state.highlight.spacing then
                window_height = state.screen_height - 2 * state.highlight.spacing
                window_width = window_height * ASPECT_RATIO
            end
            if window_width <=0 then window_width = 1 end; if window_height <=0 then window_height = 1/ASPECT_RATIO end

            local x_pos = (state.screen_width - window_width) / 2 + state.highlight.x_offset
            local y_pos = (state.screen_height - window_height) / 2 + state.highlight.y_offset
            local p = obs.vec2(); p.x=x_pos; p.y=y_pos; obs.obs_sceneitem_set_pos(main_source_item, p)
            local cr = obs.obs_sceneitem_crop(); obs.obs_sceneitem_set_crop(main_source_item, cr)
            local ms_s = obs.obs_sceneitem_get_source(main_source_item); local ms_w = obs.obs_source_get_width(ms_s); local ms_h = obs.obs_source_get_height(ms_s)
            if ms_w > 0 and ms_h > 0 and window_width > 0 and window_height > 0 then set_scale(main_source_item, window_width/ms_w, window_height/ms_h) else set_scale(main_source_item,0,0) end
        end
        for _,b in ipairs(inactive_browsers) do hide_browser(b) end
        return
    end

    local cams_left_count = math.ceil(total_browsers / 2)
    local cams_right_count = math.floor(total_browsers / 2)
    local cams_per_column = math.max(cams_left_count, cams_right_count)

    local available_height_for_cams = state.screen_height - state.highlight.spacing * (cams_per_column + 1)
    local browser_height = 0
    if cams_per_column > 0 then browser_height = available_height_for_cams / cams_per_column end
    local browser_width = browser_height * ASPECT_RATIO

    if browser_width > state.screen_width / 4 then browser_width = state.screen_width / 4; browser_height = browser_width / ASPECT_RATIO; end
    if browser_width <= 0 or browser_height <= 0 then browser_width = 0; browser_height = 0; end

    local current_cam_y_left = ((state.screen_height - (cams_left_count*browser_height + (math.max(0,cams_left_count-1))*state.highlight.spacing))/2) + state.highlight.y_offset
    for i=1, cams_left_count do
        local browser = active_browsers[i]
        local x = state.highlight.spacing + state.highlight.x_offset
        local y = current_cam_y_left
        local s = obs.obs_sceneitem_get_source(browser); local sw=obs.obs_source_get_width(s); local sh=obs.obs_source_get_height(s)
        local effective_sw = sw
        local cr = obs.obs_sceneitem_crop(); if sw>0 then cr.left=sw*(1-HIGHLIGHT_CROP_RATIO)/2; cr.right=sw*(1-HIGHLIGHT_CROP_RATIO)/2; end; obs.obs_sceneitem_set_crop(browser,cr)
        local p=obs.vec2();p.x=x;p.y=y; obs.obs_sceneitem_set_pos(browser,p)
        if effective_sw >0 and sh>0 and browser_width>0 and browser_height>0 then set_scale(browser, browser_width/effective_sw, browser_height/sh) else set_scale(browser,0,0) end
        current_cam_y_left = current_cam_y_left + browser_height + state.highlight.spacing
    end

    local current_cam_y_right = ((state.screen_height - (cams_right_count*browser_height + (math.max(0,cams_right_count-1))*state.highlight.spacing))/2) + state.highlight.y_offset
    for i=1, cams_right_count do
        local browser = active_browsers[cams_left_count+i]
        local x = state.screen_width - (browser_width * HIGHLIGHT_CROP_RATIO) - state.highlight.spacing + state.highlight.x_offset
        local y = current_cam_y_right
        local s = obs.obs_sceneitem_get_source(browser); local sw=obs.obs_source_get_width(s); local sh=obs.obs_source_get_height(s)
        local effective_sw = sw
        local cr = obs.obs_sceneitem_crop(); if sw>0 then cr.left=sw*(1-HIGHLIGHT_CROP_RATIO)/2; cr.right=sw*(1-HIGHLIGHT_CROP_RATIO)/2; end; obs.obs_sceneitem_set_crop(browser,cr)
        local p=obs.vec2();p.x=x;p.y=y; obs.obs_sceneitem_set_pos(browser,p)
        if effective_sw>0 and sh>0 and browser_width>0 and browser_height>0 then set_scale(browser, browser_width/effective_sw, browser_height/sh) else set_scale(browser,0,0) end
        current_cam_y_right = current_cam_y_right + browser_height + state.highlight.spacing
    end

    for _,b in ipairs(inactive_browsers) do hide_browser(b) end

    if main_source_item then
        local left_cam_total_width = 0; if cams_left_count>0 and browser_width>0 then left_cam_total_width = (browser_width * HIGHLIGHT_CROP_RATIO) + state.highlight.spacing end
        local right_cam_total_width = 0; if cams_right_count>0 and browser_width>0 then right_cam_total_width = (browser_width * HIGHLIGHT_CROP_RATIO) + state.highlight.spacing end

        local window_x = left_cam_total_width + state.highlight.x_offset + state.highlight.spacing
        local window_available_width = state.screen_width - left_cam_total_width - right_cam_total_width - (state.highlight.spacing * 2)

        if total_browsers == 0 then 
             window_available_width = state.screen_width - 2 * state.highlight.spacing
             window_x = state.highlight.spacing + state.highlight.x_offset
        end
        if window_available_width <=0 then window_available_width = 1 end

        local window_width = window_available_width
        local window_height = window_width / ASPECT_RATIO
        if window_height > state.screen_height - 2*state.highlight.spacing then
            window_height = state.screen_height - 2*state.highlight.spacing; window_width = window_height*ASPECT_RATIO
            window_x = left_cam_total_width + state.highlight.spacing + ((window_available_width - window_width)/2) + state.highlight.x_offset
            if total_browsers == 0 then window_x = (state.screen_width - window_width)/2 + state.highlight.x_offset end
        end
        if window_width <=0 then window_width = 1 end; if window_height <=0 then window_height = 1/ASPECT_RATIO end
        local window_y = (state.screen_height - window_height)/2 + state.highlight.y_offset
        local cr = obs.obs_sceneitem_crop(); obs.obs_sceneitem_set_crop(main_source_item, cr)
        local ms_s = obs.obs_sceneitem_get_source(main_source_item); local ms_w = obs.obs_source_get_width(ms_s); local ms_h = obs.obs_source_get_height(ms_s)
        local p=obs.vec2();p.x=window_x;p.y=window_y; obs.obs_sceneitem_set_pos(main_source_item,p)
        if ms_w>0 and ms_h>0 and window_width>0 and window_height>0 then set_scale(main_source_item,window_width/ms_w, window_height/ms_h) else set_scale(main_source_item,0,0) end
    end
end

local function process_highlight_browsers()
    if not state.script_active or not state.highlight.enabled then
        return
    end
    if state.highlight.scene_name == "" then
        return
    end

    local scene = obs.obs_get_scene_by_name(state.highlight.scene_name)
    if not scene then return end
    local scene_items = obs.obs_scene_enum_items(scene)
    if not scene_items then obs.obs_scene_release(scene); return end

    local active_highlight_browsers = {}
    local inactive_highlight_browsers = {}
    local main_source_item = false

    for _, scene_item in ipairs(scene_items) do
        local source = obs.obs_sceneitem_get_source(scene_item)
        local source_name = obs.obs_source_get_name(source)

        if string.match(source_name, "^" .. state.source_prefix) and not string.match(source_name, "^" .. state.highlight.main_source_prefix) then
            if obs.obs_sceneitem_visible(scene_item) then
                table.insert(active_highlight_browsers, scene_item)
            else
                table.insert(inactive_highlight_browsers, scene_item)
            end
        elseif state.highlight.main_source_prefix ~= "" and string.match(source_name, "^" .. state.highlight.main_source_prefix) then
            if obs.obs_sceneitem_visible(scene_item) then
                main_source_item = scene_item
            else
                hide_browser(scene_item)
            end
        else
             if string.match(source_name, "^" .. state.source_prefix) then hide_browser(scene_item) end
        end
    end

    table.sort(active_highlight_browsers, function(a, b)
        local name_a = obs.obs_source_get_name(obs.obs_sceneitem_get_source(a))
        local name_b = obs.obs_source_get_name(obs.obs_sceneitem_get_source(b))
        return name_a < name_b
    end)

    if not main_source_item then
        if state.grid.enabled then
            obs.sceneitem_list_release(scene_items)
            obs.obs_scene_release(scene)
            process_grid_browsers(state.highlight.scene_name) 
            return 
        end
    end

    if #active_highlight_browsers == 0 and not main_source_item then
        for _, browser_item in ipairs(inactive_highlight_browsers) do hide_browser(browser_item) end
        obs.sceneitem_list_release(scene_items)
        obs.obs_scene_release(scene)
        return
    end
    
    if state.highlight.split_cameras then
        handle_highlight_browsers_split(active_highlight_browsers, inactive_highlight_browsers, main_source_item)
    else
        handle_highlight_browsers_left(active_highlight_browsers, inactive_highlight_browsers, main_source_item)
    end

    obs.sceneitem_list_release(scene_items)
    obs.obs_scene_release(scene)
end

-- =============================================
-- UI CALLBACK FUNCTIONS AND VISIBILITY HELPER
-- =============================================

local function update_specific_layout_ui_visibility(props_obj, layout_name_str, is_visible)
    if not props_obj then return end

    local elements_to_toggle = {}
    if layout_name_str == "grid" then
        elements_to_toggle = {
            "grid_scene", "grid_spacing", "grid_margin", 
            "grid_x_offset", "grid_y_offset", "grid_split_screen"
        }
    elseif layout_name_str == "reaction" then
        elements_to_toggle = {
            "react_scene", "reaction_content_prefix", "save_reaction_prefix",
            "react_spacing", "react_x_offset", "react_y_offset", "camera_split"
        }
    elseif layout_name_str == "highlight" then
        elements_to_toggle = {
            "highlight_scene", "highlight_main_source_prefix", "save_highlight_prefix",
            "highlight_spacing", "highlight_x_offset", "highlight_y_offset", "highlight_camera_split"
        }
    end

    for _, key in ipairs(elements_to_toggle) do
        local prop_to_toggle = obs.obs_properties_get(props_obj, key)
        if prop_to_toggle then
            obs.obs_property_set_visible(prop_to_toggle, is_visible)
        end
    end
end


local function on_language_changed(props, prop, settings)
    state.current_language = obs.obs_data_get_string(settings, "language_name")
    state.translations = LANGUAGES[state.current_language] or LANGUAGES["English"]
    update_ui_texts(props) 
    return true
end

local function on_grid_enabled_changed(props, property, settings)
    local grid_checkbox_is_on = obs.obs_data_get_bool(settings, "grid_enabled")
    state.ui.grid_checkbox_latest = grid_checkbox_is_on 

    update_actual_layout_operational_states(grid_checkbox_is_on, state.ui.reaction_checkbox_latest, state.ui.highlight_checkbox_latest)
    update_specific_layout_ui_visibility(props, "grid", grid_checkbox_is_on)

    refresh_all()
    return true
end

local function on_reaction_enabled_changed(props, property, settings)
    local reaction_checkbox_is_on = obs.obs_data_get_bool(settings, "reaction_enabled")
    state.ui.reaction_checkbox_latest = reaction_checkbox_is_on 

    update_actual_layout_operational_states(state.ui.grid_checkbox_latest, reaction_checkbox_is_on, state.ui.highlight_checkbox_latest)
    update_specific_layout_ui_visibility(props, "reaction", reaction_checkbox_is_on)
    
    refresh_all()
    return true
end

local function on_highlight_enabled_changed(props, property, settings)
    local highlight_checkbox_is_on = obs.obs_data_get_bool(settings, "highlight_enabled")
    state.ui.highlight_checkbox_latest = highlight_checkbox_is_on 

    update_actual_layout_operational_states(state.ui.grid_checkbox_latest, state.ui.reaction_checkbox_latest, highlight_checkbox_is_on)
    update_specific_layout_ui_visibility(props, "highlight", highlight_checkbox_is_on)
    
    refresh_all()
    return true
end

local function on_grid_scene_changed(props, prop, settings)
    state.grid.scene_name = obs.obs_data_get_string(settings, "grid_scene")
    refresh_all()
end

local function on_react_scene_changed(props, prop, settings)
    state.reaction.scene_name = obs.obs_data_get_string(settings, "react_scene")
    refresh_all()
end

local function on_highlight_scene_changed(props, prop, settings)
    state.highlight.scene_name = obs.obs_data_get_string(settings, "highlight_scene")
    refresh_all()
end

local function on_general_camera_prefix_changed(props, property, settings)
    state.ui.temp_general_camera_prefix = obs.obs_data_get_string(settings, "general_camera_prefix")
end

local function on_content_prefix_changed(props, property, settings)
    state.ui.temp_content_prefix = obs.obs_data_get_string(settings, "reaction_content_prefix")
end

local function on_highlight_main_prefix_changed(props, property, settings)
    state.ui.temp_highlight_main_prefix = obs.obs_data_get_string(settings, "highlight_main_source_prefix")
end

local function on_save_general_camera_prefix_clicked(props, prop)
    state.source_prefix = state.ui.temp_general_camera_prefix:gsub("%s+", "")
    update_actual_layout_operational_states(state.ui.grid_checkbox_latest, state.ui.reaction_checkbox_latest, state.ui.highlight_checkbox_latest)
    refresh_all()
end

local function on_save_reaction_prefix_clicked(props, prop)
    state.reaction.content_prefix = state.ui.temp_content_prefix:gsub("%s+", "")
    update_actual_layout_operational_states(state.ui.grid_checkbox_latest, state.ui.reaction_checkbox_latest, state.ui.highlight_checkbox_latest)
    refresh_all()
end

local function on_save_highlight_prefix_clicked(props, prop)
    state.highlight.main_source_prefix = state.ui.temp_highlight_main_prefix:gsub("%s+", "")
    update_actual_layout_operational_states(state.ui.grid_checkbox_latest, state.ui.reaction_checkbox_latest, state.ui.highlight_checkbox_latest)
    refresh_all()
end

local function on_grid_spacing_changed(props, prop, settings)
    state.grid.spacing = obs.obs_data_get_int(settings, "grid_spacing")
    refresh_all()
end

local function on_grid_margin_changed(props, prop, settings)
    state.grid.margin = obs.obs_data_get_int(settings, "grid_margin")
    refresh_all()
end

local function on_grid_x_offset_changed(props, prop, settings)
    state.grid.x_offset = obs.obs_data_get_int(settings, "grid_x_offset")
    refresh_all()
end

local function on_grid_y_offset_changed(props, prop, settings)
    state.grid.y_offset = obs.obs_data_get_int(settings, "grid_y_offset")
    refresh_all()
end

local function on_grid_split_screen_changed(props, property, settings)
    state.grid.split_screen = obs.obs_data_get_bool(settings, "grid_split_screen")
    refresh_all()
end

local function on_react_spacing_changed(props, prop, settings)
    state.reaction.spacing = obs.obs_data_get_int(settings, "react_spacing")
    refresh_all()
end

local function on_react_x_offset_changed(props, prop, settings)
    state.reaction.x_offset = obs.obs_data_get_int(settings, "react_x_offset")
    refresh_all()
end

local function on_react_y_offset_changed(props, prop, settings)
    state.reaction.y_offset = obs.obs_data_get_int(settings, "react_y_offset")
    refresh_all()
end

local function on_camera_split_changed(props, property, settings)
    state.reaction.split_cameras = obs.obs_data_get_bool(settings, "camera_split")
    refresh_all()
end

local function on_highlight_spacing_changed(props, prop, settings)
    state.highlight.spacing = obs.obs_data_get_int(settings, "highlight_spacing")
    refresh_all()
end

local function on_highlight_x_offset_changed(props, prop, settings)
    state.highlight.x_offset = obs.obs_data_get_int(settings, "highlight_x_offset")
    refresh_all()
end

local function on_highlight_y_offset_changed(props, prop, settings)
    state.highlight.y_offset = obs.obs_data_get_int(settings, "highlight_y_offset")
    refresh_all()
end

local function on_highlight_camera_split_changed(props, property, settings)
    state.highlight.split_cameras = obs.obs_data_get_bool(settings, "highlight_camera_split")
    refresh_all()
end

-- =============================================
-- MAIN REFRESH FUNCTION
-- =============================================
function refresh_all() 
    if not state.script_active then return end
    process_grid_browsers() 
    process_react_browsers() 
    process_highlight_browsers() 
end

-- =============================================
-- OBS SCRIPT INTEGRATION
-- =============================================
function script_properties()
    local props = obs.obs_properties_create()
    global_props_ref = props 
    state.ui.elements = {} -- Limpa referências antigas

    local scenes = obs.obs_frontend_get_scenes()

    if scenes then
        -- Language
        state.ui.elements[1] = obs.obs_properties_add_list(props, "language_name", state.translations[1] or "Language", obs.OBS_COMBO_TYPE_LIST, obs.OBS_COMBO_FORMAT_STRING)
        for _, lang in ipairs(LANGUAGE_NAMES) do
            obs.obs_property_list_add_string(state.ui.elements[1], lang, lang)
        end
        obs.obs_property_set_modified_callback(state.ui.elements[1], on_language_changed)

        -- General Camera Prefix
        state.ui.elements[5] = obs.obs_properties_add_text(props, "general_camera_prefix", state.translations[5] or "General Camera Prefix", obs.OBS_TEXT_DEFAULT)
        obs.obs_property_set_modified_callback(state.ui.elements[5], on_general_camera_prefix_changed)
        obs.obs_properties_add_button(props, "save_general_camera_prefix", "✔ Save General Prefix", on_save_general_camera_prefix_clicked)

        -- Grid Layout Section
        state.ui.elements[2] = obs.obs_properties_add_text(props, "grid_settings_label", state.translations[2] or "== Grid Settings ==", obs.OBS_TEXT_INFO)
        state.ui.elements[3] = obs.obs_properties_add_bool(props, "grid_enabled", state.translations[3] or "Enable Grid Layout")
        obs.obs_property_set_modified_callback(state.ui.elements[3], on_grid_enabled_changed)
        
        state.ui.elements[4] = obs.obs_properties_add_list(props, "grid_scene", state.translations[4] or "Grid Scene", obs.OBS_COMBO_TYPE_EDITABLE, obs.OBS_COMBO_FORMAT_STRING)
        for _, scene in ipairs(scenes) do obs.obs_property_list_add_string(state.ui.elements[4], obs.obs_source_get_name(scene), obs.obs_source_get_name(scene)) end
        obs.obs_property_set_modified_callback(state.ui.elements[4], on_grid_scene_changed)
        
        state.ui.elements[6] = obs.obs_properties_add_int_slider(props, "grid_spacing", state.translations[6] or "Grid Spacing", 0, 100, 1)
        obs.obs_property_set_modified_callback(state.ui.elements[6], on_grid_spacing_changed)
        state.ui.elements[7] = obs.obs_properties_add_int_slider(props, "grid_margin", state.translations[7] or "Grid Margin", 0, math.floor(state.screen_height / 2), 1)
        obs.obs_property_set_modified_callback(state.ui.elements[7], on_grid_margin_changed)
        state.ui.elements[8] = obs.obs_properties_add_int_slider(props, "grid_x_offset", state.translations[8] or "Grid X Offset", -state.screen_width, state.screen_width, 1)
        obs.obs_property_set_modified_callback(state.ui.elements[8], on_grid_x_offset_changed)
        state.ui.elements[9] = obs.obs_properties_add_int_slider(props, "grid_y_offset", state.translations[9] or "Grid Y Offset", -state.screen_height, state.screen_height, 1)
        obs.obs_property_set_modified_callback(state.ui.elements[9], on_grid_y_offset_changed)
        state.ui.elements[10] = obs.obs_properties_add_bool(props, "grid_split_screen", state.translations[10] or "Split Screen for 2 Cameras")
        obs.obs_property_set_modified_callback(state.ui.elements[10], on_grid_split_screen_changed)
        update_specific_layout_ui_visibility(props, "grid", state.ui.grid_checkbox_latest)

        -- Reaction Layout Section
        state.ui.elements[11] = obs.obs_properties_add_text(props, "react_settings_label", state.translations[11] or "== Reaction Settings ==", obs.OBS_TEXT_INFO)
        state.ui.elements[12] = obs.obs_properties_add_bool(props, "reaction_enabled", state.translations[12] or "Enable Reaction Layout")
        obs.obs_property_set_modified_callback(state.ui.elements[12], on_reaction_enabled_changed)

        state.ui.elements[13] = obs.obs_properties_add_list(props, "react_scene", state.translations[13] or "Reaction Scene", obs.OBS_COMBO_TYPE_EDITABLE, obs.OBS_COMBO_FORMAT_STRING)
        for _, scene in ipairs(scenes) do obs.obs_property_list_add_string(state.ui.elements[13], obs.obs_source_get_name(scene), obs.obs_source_get_name(scene)) end
        obs.obs_property_set_modified_callback(state.ui.elements[13], on_react_scene_changed)
        
        state.ui.elements[15] = obs.obs_properties_add_text(props, "reaction_content_prefix", state.translations[15] or "Reacted Content Prefix", obs.OBS_TEXT_DEFAULT)
        obs.obs_property_set_modified_callback(state.ui.elements[15], on_content_prefix_changed)
        obs.obs_properties_add_button(props, "save_reaction_prefix", "✔ Save Window Prefix", on_save_reaction_prefix_clicked)
        
        state.ui.elements[16] = obs.obs_properties_add_int_slider(props, "react_spacing", state.translations[16] or "Reaction Spacing", 0, 100, 1)
        obs.obs_property_set_modified_callback(state.ui.elements[16], on_react_spacing_changed)
        state.ui.elements[17] = obs.obs_properties_add_int_slider(props, "react_x_offset", state.translations[17] or "Reaction X Offset", -state.screen_width, state.screen_width, 1)
        obs.obs_property_set_modified_callback(state.ui.elements[17], on_react_x_offset_changed)
        state.ui.elements[18] = obs.obs_properties_add_int_slider(props, "react_y_offset", state.translations[18] or "Reaction Y Offset", -state.screen_height, state.screen_height, 1)
        obs.obs_property_set_modified_callback(state.ui.elements[18], on_react_y_offset_changed)
        state.ui.elements[19] = obs.obs_properties_add_bool(props, "camera_split", state.translations[19] or "Distribute cameras between both sides")
        obs.obs_property_set_modified_callback(state.ui.elements[19], on_camera_split_changed)
        update_specific_layout_ui_visibility(props, "reaction", state.ui.reaction_checkbox_latest)

        -- Highlight Layout Section
        state.ui.elements[20] = obs.obs_properties_add_text(props, "highlight_settings_label", state.translations[20] or "== Highlight Settings ==", obs.OBS_TEXT_INFO)
        state.ui.elements[21] = obs.obs_properties_add_bool(props, "highlight_enabled", state.translations[21] or "Enable Highlight Layout")
        obs.obs_property_set_modified_callback(state.ui.elements[21], on_highlight_enabled_changed)

        state.ui.elements[22] = obs.obs_properties_add_list(props, "highlight_scene", state.translations[22] or "Highlight Scene", obs.OBS_COMBO_TYPE_EDITABLE, obs.OBS_COMBO_FORMAT_STRING)
        for _, scene in ipairs(scenes) do obs.obs_property_list_add_string(state.ui.elements[22], obs.obs_source_get_name(scene), obs.obs_source_get_name(scene)) end
        obs.obs_property_set_modified_callback(state.ui.elements[22], on_highlight_scene_changed)

        state.ui.elements[24] = obs.obs_properties_add_text(props, "highlight_main_source_prefix", state.translations[24] or "Highlight Main Source Prefix", obs.OBS_TEXT_DEFAULT)
        obs.obs_property_set_modified_callback(state.ui.elements[24], on_highlight_main_prefix_changed)
        obs.obs_properties_add_button(props, "save_highlight_prefix", "✔ Save Main Source Prefix", on_save_highlight_prefix_clicked)
        
        state.ui.elements[25] = obs.obs_properties_add_int_slider(props, "highlight_spacing", state.translations[25] or "Highlight Spacing", 0, 100, 1)
        obs.obs_property_set_modified_callback(state.ui.elements[25], on_highlight_spacing_changed)
        state.ui.elements[26] = obs.obs_properties_add_int_slider(props, "highlight_x_offset", state.translations[26] or "Highlight X Offset", -state.screen_width, state.screen_width, 1)
        obs.obs_property_set_modified_callback(state.ui.elements[26], on_highlight_x_offset_changed)
        state.ui.elements[27] = obs.obs_properties_add_int_slider(props, "highlight_y_offset", state.translations[27] or "Highlight Y Offset", -state.screen_height, state.screen_height, 1)
        obs.obs_property_set_modified_callback(state.ui.elements[27], on_highlight_y_offset_changed)
        state.ui.elements[28] = obs.obs_properties_add_bool(props, "highlight_camera_split", state.translations[28] or "Distribute cameras between both sides (Highlight)")
        obs.obs_property_set_modified_callback(state.ui.elements[28], on_highlight_camera_split_changed)
        update_specific_layout_ui_visibility(props, "highlight", state.ui.highlight_checkbox_latest)

        obs.source_list_release(scenes)
    end
    return props
end

function script_load(settings)
    update_screen_dimensions()

    state.current_language = obs.obs_data_get_string(settings, "language_name") or "English"
    state.translations = LANGUAGES[state.current_language] or LANGUAGES["English"]

    state.source_prefix = obs.obs_data_get_string(settings, "general_camera_prefix") or
                          obs.obs_data_get_string(settings, "grid_prefix") or 
                          obs.obs_data_get_string(settings, "react_prefix") or 
                          obs.obs_data_get_string(settings, "highlight_camera_prefix") or "" 
    state.reaction.content_prefix = obs.obs_data_get_string(settings, "reaction_content_prefix") or ""
    state.highlight.main_source_prefix = obs.obs_data_get_string(settings, "highlight_main_source_prefix") or ""

    state.ui.grid_checkbox_latest = obs.obs_data_get_bool(settings, "grid_enabled")
    state.ui.reaction_checkbox_latest = obs.obs_data_get_bool(settings, "reaction_enabled")
    state.ui.highlight_checkbox_latest = obs.obs_data_get_bool(settings, "highlight_enabled")

    update_actual_layout_operational_states(state.ui.grid_checkbox_latest, state.ui.reaction_checkbox_latest, state.ui.highlight_checkbox_latest)

    state.grid.scene_name = obs.obs_data_get_string(settings, "grid_scene") or ""
    state.grid.spacing = obs.obs_data_get_int(settings, "grid_spacing") 
    state.grid.margin = obs.obs_data_get_int(settings, "grid_margin")
    state.grid.x_offset = obs.obs_data_get_int(settings, "grid_x_offset")
    state.grid.y_offset = obs.obs_data_get_int(settings, "grid_y_offset")
    state.grid.split_screen = obs.obs_data_get_bool(settings, "grid_split_screen")

    state.reaction.scene_name = obs.obs_data_get_string(settings, "react_scene") or ""
    state.reaction.spacing = obs.obs_data_get_int(settings, "react_spacing")
    state.reaction.x_offset = obs.obs_data_get_int(settings, "react_x_offset")
    state.reaction.y_offset = obs.obs_data_get_int(settings, "react_y_offset")
    state.reaction.split_cameras = obs.obs_data_get_bool(settings, "camera_split")

    state.highlight.scene_name = obs.obs_data_get_string(settings, "highlight_scene") or ""
    state.highlight.spacing = obs.obs_data_get_int(settings, "highlight_spacing")
    state.highlight.x_offset = obs.obs_data_get_int(settings, "highlight_x_offset")
    state.highlight.y_offset = obs.obs_data_get_int(settings, "highlight_y_offset")
    state.highlight.split_cameras = obs.obs_data_get_bool(settings, "highlight_camera_split")

    state.ui.temp_general_camera_prefix = state.source_prefix
    state.ui.temp_content_prefix = state.reaction.content_prefix
    state.ui.temp_highlight_main_prefix = state.highlight.main_source_prefix
    
    obs.timer_add(refresh_all, INTERVAL_MS)
end

function script_unload()
    state.script_active = false
    obs.timer_remove(refresh_all)
    global_props_ref = nil 
end

function script_save(settings)
    obs.obs_data_set_string(settings, "language_name", state.current_language)
    obs.obs_data_set_string(settings, "general_camera_prefix", state.source_prefix)

    obs.obs_data_set_bool(settings, "grid_enabled", state.ui.grid_checkbox_latest)
    obs.obs_data_set_bool(settings, "reaction_enabled", state.ui.reaction_checkbox_latest)
    obs.obs_data_set_bool(settings, "highlight_enabled", state.ui.highlight_checkbox_latest)

    obs.obs_data_set_string(settings, "grid_scene", state.grid.scene_name)
    obs.obs_data_set_int(settings, "grid_spacing", state.grid.spacing)
    obs.obs_data_set_int(settings, "grid_margin", state.grid.margin)
    obs.obs_data_set_int(settings, "grid_x_offset", state.grid.x_offset)
    obs.obs_data_set_int(settings, "grid_y_offset", state.grid.y_offset)
    obs.obs_data_set_bool(settings, "grid_split_screen", state.grid.split_screen)

    obs.obs_data_set_string(settings, "react_scene", state.reaction.scene_name)
    obs.obs_data_set_string(settings, "reaction_content_prefix", state.reaction.content_prefix)
    obs.obs_data_set_int(settings, "react_spacing", state.reaction.spacing)
    obs.obs_data_set_int(settings, "react_x_offset", state.reaction.x_offset)
    obs.obs_data_set_int(settings, "react_y_offset", state.reaction.y_offset)
    obs.obs_data_set_bool(settings, "camera_split", state.reaction.split_cameras)

    obs.obs_data_set_string(settings, "highlight_scene", state.highlight.scene_name)
    obs.obs_data_set_string(settings, "highlight_main_source_prefix", state.highlight.main_source_prefix)
    obs.obs_data_set_int(settings, "highlight_spacing", state.highlight.spacing)
    obs.obs_data_set_int(settings, "highlight_x_offset", state.highlight.x_offset)
    obs.obs_data_set_int(settings, "highlight_y_offset", state.highlight.y_offset)
    obs.obs_data_set_bool(settings, "highlight_camera_split", state.highlight.split_cameras)

    obs.obs_data_erase(settings, "grid_prefix")
    obs.obs_data_erase(settings, "react_prefix")
    obs.obs_data_erase(settings, "highlight_camera_prefix")
end

function script_description()
    return [[Advanced Scene Manager with Grid, Reaction, and Highlight Layouts.
    Layouts active if checkbox is ON AND required prefixes are set.
    Prefixes only saved on 'Save' button click.
    If a layout is disabled, its sources will not be hidden by this script.
    Reaction and Highlight layouts will fallback to Grid layout if their specific camera sources are not found AND Grid layout is enabled.]]
end

function script_defaults(settings)
    obs.obs_data_set_default_bool(settings, "grid_enabled", false)
    obs.obs_data_set_default_bool(settings, "reaction_enabled", false)
    obs.obs_data_set_default_bool(settings, "highlight_enabled", false)

    obs.obs_data_set_default_string(settings, "language_name", "English")
    obs.obs_data_set_default_string(settings, "general_camera_prefix", "")
    
    obs.obs_data_set_default_string(settings, "grid_scene", "")
    obs.obs_data_set_default_int(settings, "grid_spacing", 20)
    obs.obs_data_set_default_int(settings, "grid_margin", 0)
    obs.obs_data_set_default_int(settings, "grid_x_offset", 0)
    obs.obs_data_set_default_int(settings, "grid_y_offset", 0)
    obs.obs_data_set_default_bool(settings, "grid_split_screen", false)

    obs.obs_data_set_default_string(settings, "react_scene", "")
    obs.obs_data_set_default_string(settings, "reaction_content_prefix", "")
    obs.obs_data_set_default_int(settings, "react_spacing", 30)
    obs.obs_data_set_default_int(settings, "react_x_offset", 0)
    obs.obs_data_set_default_int(settings, "react_y_offset", 0)
    obs.obs_data_set_default_bool(settings, "camera_split", false)

    obs.obs_data_set_default_string(settings, "highlight_scene", "")
    obs.obs_data_set_default_string(settings, "highlight_main_source_prefix", "")
    obs.obs_data_set_default_int(settings, "highlight_spacing", 30)
    obs.obs_data_set_default_int(settings, "highlight_x_offset", 0)
    obs.obs_data_set_default_int(settings, "highlight_y_offset", 0)
    obs.obs_data_set_default_bool(settings, "highlight_camera_split", false)
end


function script_update(settings)
    state.current_language = obs.obs_data_get_string(settings, "language_name") or state.current_language
    state.translations = LANGUAGES[state.current_language] or LANGUAGES["English"]

    -- Atualiza os valores temporários da UI com o que está atualmente nos campos de texto dos settings
    state.ui.temp_general_camera_prefix = obs.obs_data_get_string(settings, "general_camera_prefix")
    state.ui.temp_content_prefix = obs.obs_data_get_string(settings, "reaction_content_prefix")
    state.ui.temp_highlight_main_prefix = obs.obs_data_get_string(settings, "highlight_main_source_prefix")

    -- Carrega outras configurações
    state.grid.scene_name = obs.obs_data_get_string(settings, "grid_scene") or state.grid.scene_name
    state.grid.spacing = obs.obs_data_get_int(settings, "grid_spacing")
    state.grid.margin = obs.obs_data_get_int(settings, "grid_margin")
    state.grid.x_offset = obs.obs_data_get_int(settings, "grid_x_offset")
    state.grid.y_offset = obs.obs_data_get_int(settings, "grid_y_offset")
    state.grid.split_screen = obs.obs_data_get_bool(settings, "grid_split_screen")

    state.reaction.scene_name = obs.obs_data_get_string(settings, "react_scene") or state.reaction.scene_name
    state.reaction.spacing = obs.obs_data_get_int(settings, "react_spacing")
    state.reaction.x_offset = obs.obs_data_get_int(settings, "react_x_offset")
    state.reaction.y_offset = obs.obs_data_get_int(settings, "react_y_offset")
    state.reaction.split_cameras = obs.obs_data_get_bool(settings, "camera_split")

    state.highlight.scene_name = obs.obs_data_get_string(settings, "highlight_scene") or state.highlight.scene_name
    state.highlight.spacing = obs.obs_data_get_int(settings, "highlight_spacing")
    state.highlight.x_offset = obs.obs_data_get_int(settings, "highlight_x_offset")
    state.highlight.y_offset = obs.obs_data_get_int(settings, "highlight_y_offset")
    state.highlight.split_cameras = obs.obs_data_get_bool(settings, "highlight_camera_split")

    local grid_enabled_from_settings = obs.obs_data_get_bool(settings, "grid_enabled")
    local reaction_enabled_from_settings = obs.obs_data_get_bool(settings, "reaction_enabled")
    local highlight_enabled_from_settings = obs.obs_data_get_bool(settings, "highlight_enabled")

    state.ui.grid_checkbox_latest = grid_enabled_from_settings
    state.ui.reaction_checkbox_latest = reaction_enabled_from_settings
    state.ui.highlight_checkbox_latest = highlight_enabled_from_settings
    
    update_actual_layout_operational_states(grid_enabled_from_settings, reaction_enabled_from_settings, highlight_enabled_from_settings)
    
    if global_props_ref then
        update_specific_layout_ui_visibility(global_props_ref, "grid", grid_enabled_from_settings)
        update_specific_layout_ui_visibility(global_props_ref, "reaction", reaction_enabled_from_settings)
        update_specific_layout_ui_visibility(global_props_ref, "highlight", highlight_enabled_from_settings)
        update_ui_texts(global_props_ref)
    end

    refresh_all()
end

