obs = obslua
math = require("math")

-- =============================================
-- CONSTANTS AND CONFIGURATION
-- =============================================

local INTERVAL_MS = 200
local ASPECT_RATIO = 3 / 4
local REACTION_CROP_RATIO = 1 -- Crop the width for reaction sources

-- Supported languages and translations
local LANGUAGES = {
    ["English"] = {
        -- 1. Language selector
        "Language",
        
        -- Grid Section
        "== Grid Settings ==",           -- 2
        "Enable Grid Layout",             -- 3
        "Grid Scene",                     -- 4
        "Grid Prefix",                    -- 5
        "Grid Spacing",                   -- 6
        "Grid Margin",                    -- 7
        "Grid X Offset",                  -- 8
        "Grid Y Offset",                  -- 9
        "Split Screen for 2 Cameras",     -- 10
        
        -- Reaction Section
        "== Reaction Settings ==",        -- 11
        "Enable Reaction Layout",         -- 12
        "Reaction Scene",                 -- 13
        "Reaction Prefix",                -- 14
        "Reaction Window Prefix",         -- 15
        "Reaction Spacing",               -- 16
        "Reaction X Offset",              -- 17
        "Reaction Y Offset",              -- 18
        "Distribute cameras between both sides", -- 19
        
        -- Tracking Section
        "== Source Tracking ==",          -- 20
        "Enable Source Tracking",         -- 21
        "Monitored Scene",                -- 22
        "Target Scenes",                  -- 23
        "Source Prefix"                   -- 24
    },
    ["Português"] = {
        -- 1. Seletor de idioma
        "Idioma",
        
        -- Seção Grid
        "== Configurações de Grade ==",   -- 2
        "Ativar Layout de Grade",         -- 3
        "Cena da Grade",                  -- 4
        "Prefixo da Grade",               -- 5
        "Espaçamento da Grade",           -- 6
        "Margem da Grade",                -- 7
        "Deslocamento X da Grade",        -- 8
        "Deslocamento Y da Grade",        -- 9
        "Tela Dividida para 2 Câmeras",   -- 10
        
        -- Seção Reaction
        "== Configurações de Reação ==",  -- 11
        "Ativar Layout de Reação",        -- 12
        "Cena da Reação",                 -- 13
        "Prefixo de Reação",              -- 14
        "Prefixo da Janela de Reação",    -- 15
        "Espaçamento da Reação",          -- 16
        "Deslocamento X da Reação",       -- 17
        "Deslocamento Y da Reação",       -- 18
        "Distribuir câmeras entre os dois lados", -- 19
        
        -- Seção Tracking
        "== Rastreamento de Fontes ==",   -- 20
        "Ativar Rastreamento",            -- 21
        "Cena Monitorada",                -- 22
        "Cenas Destino",                  -- 23
        "Prefixo das Fontes"              -- 24
    },
    ["Español"] = {
        -- 1. Selector de idioma
        "Idioma",
        
        -- Sección Grid
        "== Configuraciones de Cuadrícula ==", -- 2
        "Activar Diseño de Cuadrícula",   -- 3
        "Escena de Cuadrícula",           -- 4
        "Prefijo de Cuadrícula",          -- 5
        "Espaciado de Cuadrícula",        -- 6
        "Margen de Cuadrícula",           -- 7
        "Desplazamiento X de Cuadrícula", -- 8
        "Desplazamiento Y de Cuadrícula", -- 9
        "Pantalla Dividida para 2 Cámaras", -- 10
        
        -- Sección Reaction
        "== Configuraciones de Reacción ==", -- 11
        "Activar Diseño de Reacción",     -- 12
        "Escena de Reacción",             -- 13
        "Prefijo de Reacción",            -- 14
        "Prefijo de Ventana de Reacción", -- 15
        "Espaciado de Reacción",          -- 16
        "Desplazamiento X de Reacción",   -- 17
        "Desplazamiento Y de Reacción",   -- 18
        "Distribuir cámaras entre ambos lados", -- 19
        
        -- Sección Tracking
        "== Seguimiento de Fuentes ==",   -- 20
        "Activar Seguimiento",            -- 21
        "Escena Monitoreada",             -- 22
        "Escenas Destino",                -- 23
        "Prefijo de Fuentes"              -- 24
    },
    ["中文"] = {
        -- 1. 语言选择
        "语言",
        
        -- 网格部分
        "== 网格设置 ==",                 -- 2
        "启用网格布局",                   -- 3
        "网格场景",                       -- 4
        "网格前缀",                       -- 5
        "网格间距",                       -- 6
        "网格边距",                       -- 7
        "网格X轴偏移",                    -- 8
        "网格Y轴偏移",                    -- 9
        "双摄像头分屏",                   -- 10
        
        -- 反应部分
        "== 反应设置 ==",                 -- 11
        "启用反应布局",                   -- 12
        "反应场景",                       -- 13
        "反应前缀",                       -- 14
        "反应窗口前缀",                   -- 15
        "反应间距",                       -- 16
        "反应X轴偏移",                    -- 17
        "反应Y轴偏移",                    -- 18
        "将摄像头分布在两侧",             -- 19
        
        -- 跟踪部分
        "== 源跟踪 ==",                   -- 20
        "启用源跟踪",                     -- 21
        "监视场景",                       -- 22
        "目标场景",                       -- 23
        "源前缀"                          -- 24
    },
    ["Русский"] = {
        -- 1. Выбор языка
        "Язык",
        
        -- Сетка
        "== Настройки сетки ==",          -- 2
        "Включить сетку",                 -- 3
        "Сцена с сеткой",                 -- 4
        "Префикс сетки",                  -- 5
        "Расстояние сетки",               -- 6
        "Отступ сетки",                   -- 7
        "Смещение X сетки",               -- 8
        "Смещение Y сетки",               -- 9
        "Разделенный экран для 2 камер",  -- 10
        
        -- Реакция
        "== Настройки реакции ==",        -- 11
        "Включить реакционный макет",     -- 12
        "Сцена реакции",                  -- 13
        "Префикс реакции",               -- 14
        "Префикс окна реакции",           -- 15
        "Расстояние реакции",             -- 16
        "Смещение X реакции",             -- 17
        "Смещение Y реакции",             -- 18
        "Распределить камеры между обеими сторонами", -- 19
        
        -- Трекинг
        "== Отслеживание источников ==",  -- 20
        "Включить отслеживание",          -- 21
        "Мониторируемая сцена",           -- 22
        "Целевые сцены",                  -- 23
        "Префикс источника"               -- 24
    },
    ["日本語"] = {
        -- 1. 言語選択
        "言語",
        
        -- グリッドセクション
        "== グリッド設定 ==",             -- 2
        "グリッドレイアウトを有効にする", -- 3
        "グリッドシーン",                 -- 4
        "グリッド接頭辞",                 -- 5
        "グリッド間隔",                   -- 6
        "グリッド余白",                   -- 7
        "グリッドX軸オフセット",          -- 8
        "グリッドY軸オフセット",          -- 9
        "2カメラ分割画面",                -- 10
        
        -- リアクションセクション
        "== リアクション設定 ==",         -- 11
        "リアクションレイアウトを有効にする", -- 12
        "リアクションシーン",             -- 13
        "リアクション接頭辞",             -- 14
        "リアクションウィンドウ接頭辞",   -- 15
        "リアクション間隔",               -- 16
        "リアクションX軸オフセット",      -- 17
        "リアクションY軸オフセット",      -- 18
        "両側にカメラを配置",             -- 19
        
        -- トラッキングセクション
        "== ソース追跡 ==",               -- 20
        "ソース追跡を有効にする",         -- 21
        "監視シーン",                     -- 22
        "ターゲットシーン",               -- 23
        "ソース接頭辞"                    -- 24
    },
    ["Deutsch"] = {
        -- 1. Sprachauswahl
        "Sprache",
        
        -- Grid Abschnitt
        "== Raster-Einstellungen ==",     -- 2
        "Rasterlayout aktivieren",        -- 3
        "Raster-Szene",                   -- 4
        "Raster-Präfix",                  -- 5
        "Raster-Abstand",                 -- 6
        "Raster-Rand",                    -- 7
        "Raster-X-Versatz",               -- 8
        "Raster-Y-Versatz",               -- 9
        "Geteilter Bildschirm für 2 Kameras", -- 10
        
        -- Reaction Abschnitt
        "== Reaktions-Einstellungen ==",  -- 11
        "Reaktionslayout aktivieren",     -- 12
        "Reaktions-Szene",                -- 13
        "Reaktions-Präfix",               -- 14
        "Reaktionsfenster-Präfix",        -- 15
        "Reaktions-Abstand",              -- 16
        "Reaktions-X-Versatz",            -- 17
        "Reaktions-Y-Versatz",            -- 18
        "Kameras auf beide Seiten verteilen", -- 19
        
        -- Tracking Abschnitt
        "== Quellenverfolgung ==",        -- 20
        "Quellenverfolgung aktivieren",   -- 21
        "Überwachte Szene",               -- 22
        "Zielszenen",                     -- 23
        "Quellenpräfix"                   -- 24
    }
}

local LANGUAGE_NAMES = {"English", "Português", "Español", "中文", "Русский", "日本語", "Deutsch"}

-- =============================================
-- STATE MANAGEMENT
-- =============================================

local state = {
    -- Language settings
    current_language = "English",
    translations = LANGUAGES["English"],
    
    -- Grid settings
    grid = {
        scene_name = "",
        source_prefix = "",
        spacing = 20,
        margin = 0,
        x_offset = 0,
        y_offset = 0,
        split_screen = false,
        enabled = false
    },
    
    -- Reaction settings
    reaction = {
        scene_name = "",
        source_prefix = "",
        window_prefix = "",
        spacing = 30,
        x_offset = 0,
        y_offset = 0,
        split_cameras = false,
        enabled = false
    },
    
    -- Source tracking settings
    tracking = {
        enabled = false,
        monitored_scene = "",
        source_prefix = "VDO.Ninja_",
        target_scenes = {},
        source_map = {},
        timer_interval = 1
    },
    
    -- Temporary UI state
    ui = {
        temp_grid_prefix = "",
        temp_react_prefix = "",
        temp_window_prefix = "",
        temp_tracking_prefix = "",
        elements = {}  -- Will store references to UI elements
    },
    
    -- System state
    screen_width = 1920,
    screen_height = 1080,
    script_active = true
}

-- =============================================
-- UTILITY FUNCTIONS
-- =============================================

--- Updates screen dimensions from OBS video info
local function update_screen_dimensions()
    local video_info = obs.obs_video_info()
    if obs.obs_get_video_info(video_info) then
        state.screen_width = video_info.base_width
        state.screen_height = video_info.base_height
    end
end

--- Hides a browser source by scaling it to 0 and moving off-screen
--- @param scene_item any The scene item to hide
local function hide_browser(scene_item)
    if not scene_item then return end

    local scale = obs.vec2()
    scale.x = 0
    scale.y = 0
    obs.obs_sceneitem_set_scale(scene_item, scale)

    local position = obs.vec2()
    position.x = -1
    position.y = -1
    obs.obs_sceneitem_set_pos(scene_item, position)
end

--- Sets the scale of a scene item
--- @param scene_item any The scene item to modify
--- @param x number X scale factor
--- @param y number Y scale factor
local function set_scale(scene_item, x, y)
    if not scene_item then return end
    
    local scale = obs.vec2()
    scale.x = x
    scale.y = y
    obs.obs_sceneitem_set_scale(scene_item, scale)
end

--- Updates all UI element texts based on current language
local function update_ui_texts(props)
    for i = 1, #state.translations do
        if state.ui.elements[i] then
            obs.obs_property_set_description(state.ui.elements[i], state.translations[i])
        end
    end
end

-- =============================================
-- SOURCE TRACKING FUNCTIONS (CORRECTED)
-- =============================================

--- Checks if a scene is in the target scenes list
--- @param scene_name string The scene name to check
--- @return boolean True if the scene is a target
local function is_target_scene(scene_name)
    for _, target in ipairs(state.tracking.target_scenes) do
        if target == scene_name then
            return true
        end
    end
    return false
end

--- Removes a source from all target scenes
--- @param source_name string The name of the source to remove
local function remove_source_from_target_scenes(source_name)
    local all_scenes = obs.obs_frontend_get_scenes()
    
    if all_scenes then
        for _, scene_item in ipairs(all_scenes) do
            local scene_name = obs.obs_source_get_name(scene_item)
            
            if is_target_scene(scene_name) then
                local scene_ptr = obs.obs_scene_from_source(scene_item)
                local scene_source = obs.obs_scene_find_source(scene_ptr, source_name)
                if scene_source then
                    obs.obs_sceneitem_remove(scene_source)
                    obs.script_log(obs.LOG_INFO, "Removed reference from "..scene_name..": "..source_name)
                end
            end
        end
        obs.source_list_release(all_scenes)
    end
end

--- Completely removes a source from all tracking
--- @param source_name string The name of the source to remove
local function completely_remove_source(source_name)
    -- 1. Remove from target scenes
    remove_source_from_target_scenes(source_name)
    
    -- 2. Remove from internal tracking
    state.tracking.source_map[source_name] = nil
    
    obs.script_log(obs.LOG_INFO, "Completely removed tracking for: "..source_name)
end

--- Adds a source to all target scenes
--- @param source any The source to add
local function add_source_to_target_scenes(source)
    local source_name = obs.obs_source_get_name(source)
    local all_scenes = obs.obs_frontend_get_scenes()
    
    if all_scenes then
        for _, scene_item in ipairs(all_scenes) do
            local scene_name = obs.obs_source_get_name(scene_item)
            
            -- Check if scene is a target and not the monitored scene
            if is_target_scene(scene_name) and scene_name ~= state.tracking.monitored_scene then
                local scene_ptr = obs.obs_scene_from_source(scene_item)
                local existing_source = obs.obs_scene_find_source(scene_ptr, source_name)
                if not existing_source then
                    -- Add source as reference
                    local new_source = obs.obs_source_get_ref(source)
                    obs.obs_scene_add(scene_ptr, new_source)
                    obs.obs_source_release(new_source)
                    obs.script_log(obs.LOG_INFO, "Added reference to "..scene_name..": "..source_name)
                end
            end
        end
        obs.source_list_release(all_scenes)
    end
end

--- Processes the monitored scene for source tracking
local function process_tracking()
    if not state.tracking.enabled or state.tracking.monitored_scene == "" then return end
    
    local monitored_scene_source = obs.obs_get_scene_by_name(state.tracking.monitored_scene)
    if not monitored_scene_source then return end
    
    local current_sources = {}
    local scene_items = obs.obs_scene_enum_items(monitored_scene_source)
    
    if scene_items then
        -- First check for removed sources
        for source_name, _ in pairs(state.tracking.source_map) do
            local found = false
            for _, scene_item in ipairs(scene_items) do
                local source = obs.obs_sceneitem_get_source(scene_item)
                if obs.obs_source_get_name(source) == source_name then
                    found = true
                    break
                end
            end
            if not found then
                completely_remove_source(source_name)
            end
        end
        
        -- Then process current sources
        for _, scene_item in ipairs(scene_items) do
            local source = obs.obs_sceneitem_get_source(scene_item)
            local source_name = obs.obs_source_get_name(source)
            table.insert(current_sources, source)
            
            if string.find(source_name, "^"..state.tracking.source_prefix) then
                if not state.tracking.source_map[source_name] then
                    state.tracking.source_map[source_name] = true
                    add_source_to_target_scenes(source)
                end
            end
        end
        
        obs.sceneitem_list_release(scene_items)
    end
    obs.obs_scene_release(monitored_scene_source)
end

-- =============================================
-- GRID LAYOUT FUNCTIONS
-- =============================================

--- Processes all visible grid browsers and positions them according to settings
local function process_grid_browsers()
    if not state.script_active or not state.grid.enabled then return end

    local scene = obs.obs_get_scene_by_name(state.grid.scene_name)
    if not scene then
        obs.obs_scene_release(scene)
        return
    end

    local scene_items = obs.obs_scene_enum_items(scene)
    if not scene_items then
        obs.obs_scene_release(scene)
        return
    end

    local active_browsers = {}
    local inactive_browsers = {}

    -- Categorize browsers as active/inactive based on visibility and prefix
    for _, scene_item in ipairs(scene_items) do
        local source = obs.obs_sceneitem_get_source(scene_item)
        local source_name = obs.obs_source_get_name(source)

        if string.match(source_name, "^" .. state.grid.source_prefix) then
            if obs.obs_sceneitem_visible(scene_item) then
                table.insert(active_browsers, scene_item)
            else
                table.insert(inactive_browsers, scene_item)
            end
        end
    end

    -- Sort browsers alphabetically by source name
    table.sort(active_browsers, function(a, b)
        local name_a = obs.obs_source_get_name(obs.obs_sceneitem_get_source(a))
        local name_b = obs.obs_source_get_name(obs.obs_sceneitem_get_source(b))
        return name_a < name_b
    end)

    -- Handle positioning based on number of browsers
    if #active_browsers == 2 and state.grid.split_screen then
        -- Special split-screen mode for exactly 2 cameras
        for index, browser in ipairs(active_browsers) do
            local source = obs.obs_sceneitem_get_source(browser)
            local width = obs.obs_source_get_width(source)
            local height = obs.obs_source_get_height(source)

            -- Position each browser on half of the screen
            local position = obs.vec2()
            position.x = (index - 1) * (state.screen_width / 2) + state.grid.x_offset
            position.y = state.grid.y_offset
            obs.obs_sceneitem_set_pos(browser, position)

            -- Apply crop to focus on center of each source
            local crop = obs.obs_sceneitem_crop()
            crop.left = width / 4
            crop.right = width / 4
            crop.top = 0
            crop.bottom = 0
            obs.obs_sceneitem_set_crop(browser, crop)

            -- Scale to fill half the screen
            set_scale(browser, state.screen_width / width, state.screen_height / height)
        end
    else
        -- Standard grid layout
        local cols = math.ceil(math.sqrt(#active_browsers))
        local rows = math.ceil(#active_browsers / cols)

        -- Calculate available space after accounting for margins
        local unavailable_space = 2 * state.grid.margin
        local available_width = state.screen_width - unavailable_space
        local available_height = state.screen_height - unavailable_space

        -- Calculate browser dimensions maintaining aspect ratio
        local total_spacing_x = (cols - 1) * state.grid.spacing
        local total_spacing_y = (rows - 1) * state.grid.spacing

        local browser_width = (available_width - total_spacing_x) / cols
        local browser_height = (available_height - total_spacing_y) / rows

        if browser_width / ASPECT_RATIO <= browser_height then
            browser_height = browser_width / ASPECT_RATIO
        else
            browser_width = browser_height * ASPECT_RATIO
        end

        -- Center the grid vertically
        local total_content_height = rows * browser_height + (rows - 1) * state.grid.spacing
        local vertical_padding = (available_height - total_content_height) / 2

        -- Position each browser in the grid
        for row = 0, rows - 1 do
            local row_items = math.min(cols, #active_browsers - row * cols)
            local total_row_width = row_items * browser_width + (row_items - 1) * state.grid.spacing
            local horizontal_padding = (available_width - total_row_width) / 2

            for col = 0, row_items - 1 do
                local index = row * cols + col
                if index < #active_browsers then
                    local browser = active_browsers[index + 1]
                    if browser then
                        local source = obs.obs_sceneitem_get_source(browser)
                        local width = obs.obs_source_get_width(source)
                        local height = obs.obs_source_get_height(source)

                        -- Calculate position with offsets
                        local x = state.grid.margin + horizontal_padding + 
                                 col * (browser_width + state.grid.spacing) + state.grid.x_offset
                        local y = state.grid.margin + vertical_padding + 
                                 row * (browser_height + state.grid.spacing) + state.grid.y_offset

                        -- Remove any existing crop
                        local crop = obs.obs_sceneitem_crop()
                        obs.obs_sceneitem_set_crop(browser, crop)

                        -- Set position and scale
                        local position = obs.vec2()
                        position.x = x
                        position.y = y
                        obs.obs_sceneitem_set_pos(browser, position)
                        set_scale(browser, browser_width / width, browser_height / height)
                    end
                end
            end
        end
    end

    -- Hide inactive browsers
    for _, browser in ipairs(inactive_browsers) do
        hide_browser(browser)
    end

    -- Clean up
    obs.sceneitem_list_release(scene_items)
    obs.obs_scene_release(scene)
end

-- =============================================
-- REACTION LAYOUT FUNCTIONS
-- =============================================

--- Handles reaction layout with cameras on left side only
local function handle_react_browsers_left(active_browsers, inactive_browsers, window_capture)
    local total_browsers = #active_browsers

    -- Calculate browser dimensions maintaining aspect ratio
    local available_height = state.screen_height - state.reaction.spacing * (total_browsers + 1)
    local browser_height = total_browsers > 0 and (available_height / total_browsers) or 0
    local browser_width = browser_height * ASPECT_RATIO

    -- Constrain maximum width
    if browser_width > state.screen_width / 4 then
        browser_width = state.screen_width / 4
        browser_height = browser_width / ASPECT_RATIO
    end

    -- Center vertically
    local adjusted_vertical_space = (browser_height + state.reaction.spacing) * total_browsers - state.reaction.spacing
    local top_margin = (state.screen_height - adjusted_vertical_space) / 2

    -- Position each browser on the left side
    for index, browser in ipairs(active_browsers) do
        local x = state.reaction.spacing + state.reaction.x_offset
        local y = top_margin + (index - 1) * (browser_height + state.reaction.spacing) + state.reaction.y_offset

        -- Apply crop to show only right 3/4 of the source
        local crop = obs.obs_sceneitem_crop()
        crop.left = state.screen_width * (1 - REACTION_CROP_RATIO) / 2
        crop.right = state.screen_width * (1 - REACTION_CROP_RATIO) / 2
        obs.obs_sceneitem_set_crop(browser, crop)

        -- Set position and scale
        local position = obs.vec2()
        position.x = x
        position.y = y
        obs.obs_sceneitem_set_pos(browser, position)
        set_scale(browser, browser_width / state.screen_width, browser_height / state.screen_height)
    end

    -- Hide inactive browsers
    for _, browser in ipairs(inactive_browsers) do
        hide_browser(browser)
    end

    -- Position window capture if present
    if window_capture then
        local browser_crop = browser_width * REACTION_CROP_RATIO
        local window_width, window_height
        
        if total_browsers == 0 then
            window_width = state.screen_width
            window_height = window_width * (9/16)
        else
            window_width = state.screen_width - (3 * state.reaction.spacing + browser_crop)
            window_height = window_width * (9/16)
        end

        local scale_x = window_width / state.screen_width
        local scale_y = window_height / state.screen_height

        -- Calculate window position
        local x_pos, y_pos
        if total_browsers == 0 then
            x_pos = (state.screen_width - window_width) / 2 + state.reaction.x_offset
            y_pos = (state.screen_height - window_height) / 2 + state.reaction.y_offset
        else
            x_pos = browser_crop + state.reaction.x_offset + (2 * state.reaction.spacing)
            y_pos = (state.screen_height - window_height) / 2 + state.reaction.y_offset
        end

        -- Position and scale window capture
        local position = obs.vec2()
        position.x = x_pos
        position.y = y_pos
        obs.obs_sceneitem_set_pos(window_capture, position)
        set_scale(window_capture, scale_x, scale_y)
    end
end

--- Handles reaction layout with cameras split between both sides
local function handle_react_browsers_split(active_browsers, inactive_browsers, window_capture)
    local total_browsers = #active_browsers
    if total_browsers == 0 then
        if window_capture then
            local window_width = state.screen_width
            local window_height = window_width * (9/16)
            local scale_x = window_width / state.screen_width
            local scale_y = window_height / state.screen_height
            local x_pos = (state.screen_width - window_width) / 2 + state.reaction.x_offset
            local y_pos = (state.screen_height - window_height) / 2 + state.reaction.y_offset
            
            local position = obs.vec2()
            position.x = x_pos
            position.y = y_pos
            obs.obs_sceneitem_set_pos(window_capture, position)
            set_scale(window_capture, scale_x, scale_y)
        end
        return
    end

    -- Calculate browser dimensions maintaining aspect ratio
    local available_height = state.screen_height - state.reaction.spacing * (math.ceil(total_browsers/2) + 1)
    local browser_height = available_height / math.ceil(total_browsers/2)
    local browser_width = browser_height * ASPECT_RATIO

    -- Constrain maximum width
    if browser_width > state.screen_width / 4 then
        browser_width = state.screen_width / 4
        browser_height = browser_width / ASPECT_RATIO
    end

    -- Calculate how many cameras on each side
    local left_count = math.ceil(total_browsers / 2)
    local right_count = math.floor(total_browsers / 2)
    local columns = 0

    if left_count > 0 then columns = columns + 1 end
    if right_count > 0 then columns = columns + 1 end

    -- Calculate vertical space for left side
    local adjusted_vertical_space_left = (browser_height + state.reaction.spacing) * left_count - state.reaction.spacing
    local top_margin_left = (state.screen_height - adjusted_vertical_space_left) / 2

    -- Position browsers on left side
    local width_scale = browser_width / state.screen_width
    local height_scale = browser_height / state.screen_height
    for i = 1, left_count do
        local browser = active_browsers[i]
        if browser then
            local x = state.reaction.spacing + state.reaction.x_offset
            local y = top_margin_left + (i - 1) * (browser_height + state.reaction.spacing) + state.reaction.y_offset

            -- Apply crop
            local crop = obs.obs_sceneitem_crop()
            crop.left = state.screen_width * (1 - REACTION_CROP_RATIO) / 2
            crop.right = state.screen_width * (1 - REACTION_CROP_RATIO) / 2
            obs.obs_sceneitem_set_crop(browser, crop)

            -- Set position and scale
            local position = obs.vec2()
            position.x = x
            position.y = y
            obs.obs_sceneitem_set_pos(browser, position)
            set_scale(browser, width_scale, height_scale)
        end
    end

    -- Calculate vertical space for right side
    local adjusted_vertical_space_right = (browser_height + state.reaction.spacing) * right_count - state.reaction.spacing
    local top_margin_right = (state.screen_height - adjusted_vertical_space_right) / 2
    local browser_crop = browser_width * REACTION_CROP_RATIO

    -- Position browsers on right side
    for i = 1, right_count do
        local browser = active_browsers[left_count + i]
        if browser then
            local x = state.screen_width - browser_crop - state.reaction.spacing + state.reaction.x_offset
            local y = top_margin_right + (i - 1) * (browser_height + state.reaction.spacing) + state.reaction.y_offset

            -- Apply crop
            local crop = obs.obs_sceneitem_crop()
            crop.left = state.screen_width * (1 - REACTION_CROP_RATIO) / 2
            crop.right = state.screen_width * (1 - REACTION_CROP_RATIO) / 2
            obs.obs_sceneitem_set_crop(browser, crop)

            -- Set position and scale
            local position = obs.vec2()
            position.x = x
            position.y = y
            obs.obs_sceneitem_set_pos(browser, position)
            set_scale(browser, width_scale, height_scale)
        end
    end

    -- Hide inactive browsers
    for _, browser in ipairs(inactive_browsers) do
        hide_browser(browser)
    end

    -- Position window capture in center if present
    if window_capture then
        local window_width = state.screen_width
        local x_pos = 0
        
        if columns == 1 then
            window_width = state.screen_width - columns * (browser_crop + 3 * state.reaction.spacing)
            x_pos = (state.screen_width - window_width) / columns + state.reaction.x_offset - state.reaction.spacing
        elseif columns == 2 then
            window_width = state.screen_width - columns * (browser_crop + 2 * state.reaction.spacing)
            x_pos = (state.screen_width - window_width) / columns + state.reaction.x_offset
        end
        
        local window_height = window_width * (9/16)
        local scale_x = window_width / state.screen_width
        local scale_y = window_height / state.screen_height
        local y_pos = (state.screen_height - window_height) / 2 + state.reaction.y_offset
        
        local position = obs.vec2()
        position.x = x_pos
        position.y = y_pos
        obs.obs_sceneitem_set_pos(window_capture, position)
        set_scale(window_capture, scale_x, scale_y)
    end
end

--- Processes all visible reaction browsers and positions them according to settings
local function process_react_browsers()
    if not state.script_active or not state.reaction.enabled then return end

    local scene = obs.obs_get_scene_by_name(state.reaction.scene_name)
    if not scene then return end

    local scene_items = obs.obs_scene_enum_items(scene)
    if not scene_items then
        obs.obs_scene_release(scene)
        return
    end

    local active_browsers = {}
    local inactive_browsers = {}
    local window_capture = nil

    -- Categorize items based on prefixes and visibility
    for _, scene_item in ipairs(scene_items) do
        local source = obs.obs_sceneitem_get_source(scene_item)
        local source_name = obs.obs_source_get_name(source)

        if string.match(source_name, "^" .. state.reaction.source_prefix) then
            if obs.obs_sceneitem_visible(scene_item) then
                table.insert(active_browsers, scene_item)
            else
                table.insert(inactive_browsers, scene_item)
            end
        elseif state.reaction.window_prefix ~= "" and 
               string.match(source_name, "^" .. state.reaction.window_prefix) then
            if obs.obs_sceneitem_visible(scene_item) then
                window_capture = scene_item
            end
        end
    end

    -- Sort browsers alphabetically
    table.sort(active_browsers, function(a, b)
        local name_a = obs.obs_source_get_name(obs.obs_sceneitem_get_source(a))
        local name_b = obs.obs_source_get_name(obs.obs_sceneitem_get_source(b))
        return name_a < name_b
    end)

    -- Handle layout based on split setting
    if state.reaction.split_cameras then
        handle_react_browsers_split(active_browsers, inactive_browsers, window_capture)
    else
        handle_react_browsers_left(active_browsers, inactive_browsers, window_capture)
    end

    -- Clean up
    obs.sceneitem_list_release(scene_items)
    obs.obs_scene_release(scene)
end

-- =============================================
-- UI CALLBACK FUNCTIONS
-- =============================================

--- Callback when language is changed
local function on_language_changed(props, prop, settings)
    state.current_language = obs.obs_data_get_string(settings, "language_name")
    state.translations = LANGUAGES[state.current_language] or LANGUAGES["English"]
    update_ui_texts(props)
    return true
end

--- Callback when grid layout is toggled
local function on_grid_enabled_changed(props, property, settings)
    state.grid.enabled = obs.obs_data_get_bool(settings, "grid_enabled")
    
    -- Update visibility of grid settings
    obs.obs_property_set_visible(obs.obs_properties_get(props, "grid_scene"), state.grid.enabled)
    obs.obs_property_set_visible(obs.obs_properties_get(props, "grid_prefix"), state.grid.enabled)
    obs.obs_property_set_visible(obs.obs_properties_get(props, "save_grid_prefix"), state.grid.enabled)
    obs.obs_property_set_visible(obs.obs_properties_get(props, "grid_spacing"), state.grid.enabled)
    obs.obs_property_set_visible(obs.obs_properties_get(props, "grid_margin"), state.grid.enabled)
    obs.obs_property_set_visible(obs.obs_properties_get(props, "grid_x_offset"), state.grid.enabled)
    obs.obs_property_set_visible(obs.obs_properties_get(props, "grid_y_offset"), state.grid.enabled)
    obs.obs_property_set_visible(obs.obs_properties_get(props, "grid_split_screen"), state.grid.enabled)
    
    return true
end

--- Callback when reaction layout is toggled
local function on_reaction_enabled_changed(props, property, settings)
    state.reaction.enabled = obs.obs_data_get_bool(settings, "reaction_enabled")
    
    -- Update visibility of reaction settings
    obs.obs_property_set_visible(obs.obs_properties_get(props, "react_scene"), state.reaction.enabled)
    obs.obs_property_set_visible(obs.obs_properties_get(props, "react_prefix"), state.reaction.enabled)
    obs.obs_property_set_visible(obs.obs_properties_get(props, "reaction_prefix"), state.reaction.enabled)
    obs.obs_property_set_visible(obs.obs_properties_get(props, "save_reaction_prefix"), state.reaction.enabled)
    obs.obs_property_set_visible(obs.obs_properties_get(props, "react_spacing"), state.reaction.enabled)
    obs.obs_property_set_visible(obs.obs_properties_get(props, "react_x_offset"), state.reaction.enabled)
    obs.obs_property_set_visible(obs.obs_properties_get(props, "react_y_offset"), state.reaction.enabled)
    obs.obs_property_set_visible(obs.obs_properties_get(props, "camera_split"), state.reaction.enabled)
    
    return true
end

--- Callback when tracking is toggled
local function on_tracking_enabled_changed(props, property, settings)
    state.tracking.enabled = obs.obs_data_get_bool(settings, "tracking_enabled")
    
    -- Update visibility of tracking settings
    obs.obs_property_set_visible(obs.obs_properties_get(props, "monitored_scene"), state.tracking.enabled)
    obs.obs_property_set_visible(obs.obs_properties_get(props, "target_scenes_group"), state.tracking.enabled)
    obs.obs_property_set_visible(obs.obs_properties_get(props, "tracking_prefix"), state.tracking.enabled)
    obs.obs_property_set_visible(obs.obs_properties_get(props, "save_tracking"), state.tracking.enabled)
    
    if state.tracking.enabled then
        process_tracking()
    end
    
    return true
end

--- Callback when grid scene is changed
local function on_grid_scene_changed(props, prop, settings)
    state.grid.scene_name = obs.obs_data_get_string(settings, "grid_scene")
    process_grid_browsers()
end

--- Callback when reaction scene is changed
local function on_react_scene_changed(props, prop, settings)
    state.reaction.scene_name = obs.obs_data_get_string(settings, "react_scene")
    process_react_browsers()
end

--- Callback when grid prefix is changed in UI
local function on_grid_prefix_changed(props, property, settings)
    state.ui.temp_grid_prefix = obs.obs_data_get_string(settings, "grid_prefix")
end

--- Callback when reaction prefix is changed in UI
local function on_react_prefix_changed(props, property, settings)
    state.ui.temp_react_prefix = obs.obs_data_get_string(settings, "react_prefix")
end

--- Callback when window prefix is changed in UI
local function on_window_prefix_changed(props, property, settings)
    state.ui.temp_window_prefix = obs.obs_data_get_string(settings, "reaction_prefix")
end

--- Callback when save grid prefix button is clicked
local function on_save_grid_prefix_clicked(props, prop)
    state.grid.source_prefix = state.ui.temp_grid_prefix:gsub("%s+", "")

    -- Refresh layout
    if state.grid.source_prefix ~= "" then process_grid_browsers() end
end

--- Callback when save reaction prefix button is clicked
local function on_save_reaction_prefix_clicked(props, prop)
    state.reaction.source_prefix = state.ui.temp_react_prefix:gsub("%s+", "")
    state.reaction.window_prefix = state.ui.temp_window_prefix:gsub("%s+", "")

    -- Refresh layout
    if state.reaction.source_prefix ~= "" and state.reaction.window_prefix ~= "" then process_react_browsers() end
end

--- Callback when grid spacing is changed
local function on_grid_spacing_changed(props, prop, settings)
    state.grid.spacing = obs.obs_data_get_int(settings, "grid_spacing")
    process_grid_browsers()
end

--- Callback when grid margin is changed
local function on_grid_margin_changed(props, prop, settings)
    state.grid.margin = obs.obs_data_get_int(settings, "grid_margin")
    process_grid_browsers()
end

--- Callback when grid X offset is changed
local function on_grid_x_offset_changed(props, prop, settings)
    state.grid.x_offset = obs.obs_data_get_int(settings, "grid_x_offset")
    process_grid_browsers()
end

--- Callback when grid Y offset is changed
local function on_grid_y_offset_changed(props, prop, settings)
    state.grid.y_offset = obs.obs_data_get_int(settings, "grid_y_offset")
    process_grid_browsers()
end

--- Callback when grid split screen is toggled
local function on_grid_split_screen_changed(props, property, settings)
    state.grid.split_screen = obs.obs_data_get_bool(settings, "grid_split_screen")
    process_grid_browsers()
end

--- Callback when reaction spacing is changed
local function on_react_spacing_changed(props, prop, settings)
    state.reaction.spacing = obs.obs_data_get_int(settings, "react_spacing")
    process_react_browsers()
end

--- Callback when reaction X offset is changed
local function on_react_x_offset_changed(props, prop, settings)
    state.reaction.x_offset = obs.obs_data_get_int(settings, "react_x_offset")
    process_react_browsers()
end

--- Callback when reaction Y offset is changed
local function on_react_y_offset_changed(props, prop, settings)
    state.reaction.y_offset = obs.obs_data_get_int(settings, "react_y_offset")
    process_react_browsers()
end

--- Callback when camera split is toggled
local function on_camera_split_changed(props, property, settings)
    state.reaction.split_cameras = obs.obs_data_get_bool(settings, "camera_split")
    process_react_browsers()
end

--- Callback when tracking prefix is changed
local function on_tracking_prefix_changed(props, property, settings)
    state.ui.temp_tracking_prefix = obs.obs_data_get_string(settings, "tracking_prefix")
end

--- Callback when monitored scene is changed
local function on_monitored_scene_changed(props, prop, settings)
    state.tracking.monitored_scene = obs.obs_data_get_string(settings, "monitored_scene")
    process_tracking()
end

--- Callback when target scenes are changed
local function on_target_scenes_changed(props, prop, settings)
    -- Clear current target scenes
    state.tracking.target_scenes = {}
    
    -- Get all scene names
    local all_scenes = obs.obs_frontend_get_scenes()
    if all_scenes then
        for _, scene_item in ipairs(all_scenes) do
            local scene_name = obs.obs_source_get_name(scene_item)
            local is_selected = obs.obs_data_get_bool(settings, "target_scene_"..scene_name)
            if is_selected then
                table.insert(state.tracking.target_scenes, scene_name)
            end
        end
        obs.source_list_release(all_scenes)
    end
end

--- Callback when save tracking settings is clicked
local function on_save_tracking_clicked(props, prop)
    state.tracking.source_prefix = state.ui.temp_tracking_prefix:gsub("%s+", "")
    if state.tracking.source_prefix ~= "" then process_tracking() end
end

-- =============================================
-- MAIN REFRESH FUNCTION
-- =============================================

--- Main refresh function called by timer
local function refresh_all()
    if (state.grid.enabled and state.grid.source_prefix ~= "") then process_grid_browsers() end
    if (state.reaction.enabled and state.reaction.source_prefix ~= "" and state.reaction.window_prefix ~= "") then process_react_browsers() end
    if (state.tracking.enabled and state.tracking.source_prefix ~= "") then process_tracking() end
end

-- =============================================
-- OBS SCRIPT INTEGRATION
-- =============================================

--- Creates the properties UI for the script
function script_properties()
    local props = obs.obs_properties_create()
    local scenes = obs.obs_frontend_get_scenes()
    
    if scenes then
        -- 1. Language selector
        state.ui.elements[1] = obs.obs_properties_add_list(props, "language_name", 
            state.translations[1], obs.OBS_COMBO_TYPE_LIST, obs.OBS_COMBO_FORMAT_STRING)
        for _, lang in ipairs(LANGUAGE_NAMES) do
            obs.obs_property_list_add_string(state.ui.elements[1], lang, lang)
        end
        obs.obs_property_set_modified_callback(state.ui.elements[1], on_language_changed)

        -- === Grid Section ===
        -- 2. Grid Settings header
        state.ui.elements[2] = obs.obs_properties_add_text(props, "grid_settings_label", 
            state.translations[2], obs.OBS_TEXT_INFO)
        
        -- 3. Grid enable toggle
        state.ui.elements[3] = obs.obs_properties_add_bool(props, "grid_enabled", state.translations[3])
        obs.obs_property_set_modified_callback(state.ui.elements[3], on_grid_enabled_changed)

        -- 4. Grid scene selection
        state.ui.elements[4] = obs.obs_properties_add_list(props, "grid_scene", 
            state.translations[4], obs.OBS_COMBO_TYPE_EDITABLE, obs.OBS_COMBO_FORMAT_STRING)
        for _, scene in ipairs(scenes) do
            local scene_name = obs.obs_source_get_name(scene)
            obs.obs_property_list_add_string(state.ui.elements[4], scene_name, scene_name)
        end
        obs.obs_property_set_modified_callback(state.ui.elements[4], on_grid_scene_changed)

        -- 5. Grid prefix
        state.ui.elements[5] = obs.obs_properties_add_text(props, "grid_prefix", 
            state.translations[5], obs.OBS_TEXT_DEFAULT)
        obs.obs_property_set_modified_callback(state.ui.elements[5], on_grid_prefix_changed)

        -- Save grid prefix button (no translation needed)
        obs.obs_properties_add_button(props, "save_grid_prefix", "✔", on_save_grid_prefix_clicked)

        -- 6. Grid spacing
        state.ui.elements[6] = obs.obs_properties_add_int_slider(props, "grid_spacing", 
            state.translations[6], 0, 100, 1)
        obs.obs_property_set_modified_callback(state.ui.elements[6], on_grid_spacing_changed)
        
        -- 7. Grid margin
        state.ui.elements[7] = obs.obs_properties_add_int_slider(props, "grid_margin", 
            state.translations[7], 0, state.screen_height / 2, 1)
        obs.obs_property_set_modified_callback(state.ui.elements[7], on_grid_margin_changed)
        
        -- 8. Grid X offset
        state.ui.elements[8] = obs.obs_properties_add_int_slider(props, "grid_x_offset", 
            state.translations[8], -state.screen_width, state.screen_width, 1)
        obs.obs_property_set_modified_callback(state.ui.elements[8], on_grid_x_offset_changed)
        
        -- 9. Grid Y offset
        state.ui.elements[9] = obs.obs_properties_add_int_slider(props, "grid_y_offset", 
            state.translations[9], -state.screen_height, state.screen_height, 1)
        obs.obs_property_set_modified_callback(state.ui.elements[9], on_grid_y_offset_changed)
        
        -- 10. Grid split screen
        state.ui.elements[10] = obs.obs_properties_add_bool(props, "grid_split_screen", 
            state.translations[10])
        obs.obs_property_set_modified_callback(state.ui.elements[10], on_grid_split_screen_changed)

        -- === Reaction Section ===
        -- 11. Reaction Settings header
        state.ui.elements[11] = obs.obs_properties_add_text(props, "react_settings_label", 
            state.translations[11], obs.OBS_TEXT_INFO)
        
        -- 12. Reaction enable toggle
        state.ui.elements[12] = obs.obs_properties_add_bool(props, "reaction_enabled", state.translations[12])
        obs.obs_property_set_modified_callback(state.ui.elements[12], on_reaction_enabled_changed)
        
        -- 13. Reaction scene selection
        state.ui.elements[13] = obs.obs_properties_add_list(props, "react_scene", 
            state.translations[13], obs.OBS_COMBO_TYPE_EDITABLE, obs.OBS_COMBO_FORMAT_STRING)
        for _, scene in ipairs(scenes) do
            local scene_name = obs.obs_source_get_name(scene)
            obs.obs_property_list_add_string(state.ui.elements[13], scene_name, scene_name)
        end
        obs.obs_property_set_modified_callback(state.ui.elements[13], on_react_scene_changed)
        
        -- 14. Reaction prefix
        state.ui.elements[14] = obs.obs_properties_add_text(props, "react_prefix", 
            state.translations[14], obs.OBS_TEXT_DEFAULT)
        obs.obs_property_set_modified_callback(state.ui.elements[14], on_react_prefix_changed)

        -- 15. Window prefix
        state.ui.elements[15] = obs.obs_properties_add_text(props, "reaction_prefix", 
            state.translations[15], obs.OBS_TEXT_DEFAULT)
        obs.obs_property_set_modified_callback(state.ui.elements[15], on_window_prefix_changed)

        -- Save reaction prefix button (no translation needed)
        obs.obs_properties_add_button(props, "save_reaction_prefix", "✔", on_save_reaction_prefix_clicked)
        
        -- 16. Reaction spacing
        state.ui.elements[16] = obs.obs_properties_add_int_slider(props, "react_spacing", 
            state.translations[16], 0, 100, 1)
        obs.obs_property_set_modified_callback(state.ui.elements[16], on_react_spacing_changed)
        
        -- 17. Reaction X offset
        state.ui.elements[17] = obs.obs_properties_add_int_slider(props, "react_x_offset", 
            state.translations[17], -state.screen_width, state.screen_width, 1)
        obs.obs_property_set_modified_callback(state.ui.elements[17], on_react_x_offset_changed)
        
        -- 18. Reaction Y offset
        state.ui.elements[18] = obs.obs_properties_add_int_slider(props, "react_y_offset", 
            state.translations[18], -state.screen_height, state.screen_height, 1)
        obs.obs_property_set_modified_callback(state.ui.elements[18], on_react_y_offset_changed)
        
        -- 19. Camera split
        state.ui.elements[19] = obs.obs_properties_add_bool(props, "camera_split", 
            state.translations[19])
        obs.obs_property_set_modified_callback(state.ui.elements[19], on_camera_split_changed)
        
        -- === Tracking Section ===
        -- 20. Tracking Settings header
        state.ui.elements[20] = obs.obs_properties_add_text(props, "tracking_settings_label", 
            state.translations[20], obs.OBS_TEXT_INFO)
        
        -- 21. Tracking enable toggle
        state.ui.elements[21] = obs.obs_properties_add_bool(props, "tracking_enabled", 
            state.translations[21])
        obs.obs_property_set_modified_callback(state.ui.elements[21], on_tracking_enabled_changed)
        
        -- 22. Monitored scene
        state.ui.elements[22] = obs.obs_properties_add_list(props, "monitored_scene", 
            state.translations[22], obs.OBS_COMBO_TYPE_EDITABLE, obs.OBS_COMBO_FORMAT_STRING)
        for _, scene in ipairs(scenes) do
            local scene_name = obs.obs_source_get_name(scene)
            obs.obs_property_list_add_string(state.ui.elements[22], scene_name, scene_name)
        end
        obs.obs_property_set_modified_callback(state.ui.elements[22], on_monitored_scene_changed)
        
        -- 23. Target scenes group
        local target_scenes_group = obs.obs_properties_create()
        state.ui.elements[23] = obs.obs_properties_add_group(props, "target_scenes_group", 
            state.translations[23], obs.OBS_GROUP_NORMAL, target_scenes_group)

        for _, scene in ipairs(scenes) do
            local scene_name = obs.obs_source_get_name(scene)
            local prop = obs.obs_properties_add_bool(target_scenes_group, "target_scene_"..scene_name, scene_name)
            obs.obs_property_set_modified_callback(prop, on_target_scenes_changed)
        end

        -- 24. Tracking prefix
        state.ui.elements[24] = obs.obs_properties_add_text(props, "tracking_prefix", 
            state.translations[24], obs.OBS_TEXT_DEFAULT)
        obs.obs_property_set_modified_callback(state.ui.elements[24], on_tracking_prefix_changed)
        
        -- Save tracking button (no translation needed)
        obs.obs_properties_add_button(props, "save_tracking", "✔", on_save_tracking_clicked)
        
        obs.source_list_release(scenes)
    end
    
    -- Create a temporary data object with the current settings
    local settings_data = obs.obs_data_create()
    obs.obs_data_set_bool(settings_data, "grid_enabled", state.grid.enabled)
    obs.obs_data_set_bool(settings_data, "reaction_enabled", state.reaction.enabled)
    obs.obs_data_set_bool(settings_data, "tracking_enabled", state.tracking.enabled)
    
    -- Force update visibility
    on_grid_enabled_changed(props, nil, settings_data)
    on_reaction_enabled_changed(props, nil, settings_data)
    on_tracking_enabled_changed(props, nil, settings_data)
    
    obs.obs_data_release(settings_data)
    
    return props
end

--- Called when the script is loaded
function script_load(settings)
    -- Initialize screen dimensions
    update_screen_dimensions()
    
    -- Load settings
    state.current_language = obs.obs_data_get_string(settings, "language_name") or "English"
    state.translations = LANGUAGES[state.current_language] or LANGUAGES["English"]
    
    -- Grid settings
    state.grid.scene_name = obs.obs_data_get_string(settings, "grid_scene") or ""
    state.grid.source_prefix = obs.obs_data_get_string(settings, "grid_prefix") or ""
    state.grid.enabled = obs.obs_data_get_bool(settings, "grid_enabled") or (state.grid.source_prefix ~= "" or state.grid.scene_name ~= "")
    state.grid.spacing = obs.obs_data_get_int(settings, "grid_spacing") or 20
    state.grid.margin = obs.obs_data_get_int(settings, "grid_margin") or 0
    state.grid.x_offset = obs.obs_data_get_int(settings, "grid_x_offset") or 0
    state.grid.y_offset = obs.obs_data_get_int(settings, "grid_y_offset") or 0
    state.grid.split_screen = obs.obs_data_get_bool(settings, "grid_split_screen") or false
    
    -- Reaction settings
    state.reaction.scene_name = obs.obs_data_get_string(settings, "react_scene") or ""
    state.reaction.source_prefix = obs.obs_data_get_string(settings, "react_prefix") or ""
    state.reaction.window_prefix = obs.obs_data_get_string(settings, "reaction_prefix") or ""
    state.reaction.enabled = obs.obs_data_get_bool(settings, "reaction_enabled") or (state.reaction.source_prefix ~= "" or state.reaction.scene_name ~= "")
    state.reaction.spacing = obs.obs_data_get_int(settings, "react_spacing") or 30
    state.reaction.x_offset = obs.obs_data_get_int(settings, "react_x_offset") or 0
    state.reaction.y_offset = obs.obs_data_get_int(settings, "react_y_offset") or 0
    state.reaction.split_cameras = obs.obs_data_get_bool(settings, "camera_split") or false
    
    -- Source tracking settings
    state.tracking.enabled = obs.obs_data_get_bool(settings, "tracking_enabled") or false
    state.tracking.monitored_scene = obs.obs_data_get_string(settings, "monitored_scene") or ""
    state.tracking.source_prefix = obs.obs_data_get_string(settings, "tracking_prefix") or "VDO.Ninja_"
    
    -- Load target scenes
    state.tracking.target_scenes = {}
    local all_scenes = obs.obs_frontend_get_scenes()
    if all_scenes then
        for _, scene in ipairs(all_scenes) do
            local scene_name = obs.obs_source_get_name(scene)
            local is_selected = obs.obs_data_get_bool(settings, "target_scene_"..scene_name)
            if is_selected then
                table.insert(state.tracking.target_scenes, scene_name)
            end
        end
        obs.source_list_release(all_scenes)
    end

    -- Initialize temporary UI state
    state.ui.temp_grid_prefix = state.grid.source_prefix
    state.ui.temp_react_prefix = state.reaction.source_prefix
    state.ui.temp_window_prefix = state.reaction.window_prefix
    state.ui.temp_tracking_prefix = state.tracking.source_prefix
    
    -- Start refresh timer
    obs.timer_add(refresh_all, INTERVAL_MS)
    
    -- Force update UI visibility by creating temporary properties
    local temp_props = obs.obs_properties_create()
    on_grid_enabled_changed(temp_props, nil, settings)
    on_reaction_enabled_changed(temp_props, nil, settings)
    on_tracking_enabled_changed(temp_props, nil, settings)
    obs.obs_properties_destroy(temp_props)
end

--- Called when the script is unloaded
function script_unload()
    state.script_active = false
    obs.timer_remove(refresh_all)
end

--- Called when settings need to be saved
function script_save(settings)
    -- Save language
    obs.obs_data_set_string(settings, "language_name", state.current_language)
    
    -- Save grid settings
    obs.obs_data_set_string(settings, "grid_scene", state.grid.scene_name)
    obs.obs_data_set_string(settings, "grid_prefix", state.grid.source_prefix)
    obs.obs_data_set_bool(settings, "grid_enabled", state.grid.enabled)
    obs.obs_data_set_int(settings, "grid_spacing", state.grid.spacing)
    obs.obs_data_set_int(settings, "grid_margin", state.grid.margin)
    obs.obs_data_set_int(settings, "grid_x_offset", state.grid.x_offset)
    obs.obs_data_set_int(settings, "grid_y_offset", state.grid.y_offset)
    obs.obs_data_set_bool(settings, "grid_split_screen", state.grid.split_screen)
    
    -- Save reaction settings
    obs.obs_data_set_string(settings, "react_scene", state.reaction.scene_name)
    obs.obs_data_set_string(settings, "react_prefix", state.reaction.source_prefix)
    obs.obs_data_set_string(settings, "reaction_prefix", state.reaction.window_prefix)
    obs.obs_data_set_bool(settings, "reaction_enabled", state.reaction.enabled)
    obs.obs_data_set_int(settings, "react_spacing", state.reaction.spacing)
    obs.obs_data_set_int(settings, "react_x_offset", state.reaction.x_offset)
    obs.obs_data_set_int(settings, "react_y_offset", state.reaction.y_offset)
    obs.obs_data_set_bool(settings, "camera_split", state.reaction.split_cameras)
    
    -- Save tracking settings
    obs.obs_data_set_bool(settings, "tracking_enabled", state.tracking.enabled)
    obs.obs_data_set_string(settings, "monitored_scene", state.tracking.monitored_scene)
    obs.obs_data_set_string(settings, "tracking_prefix", state.tracking.source_prefix)
    
    -- Save target scenes
    local all_scenes = obs.obs_frontend_get_scenes()
    if all_scenes then
        for _, scene in ipairs(all_scenes) do
            local scene_name = obs.obs_source_get_name(scene)
            local is_selected = false
            for _, target in ipairs(state.tracking.target_scenes) do
                if target == scene_name then
                    is_selected = true
                    break
                end
            end
            obs.obs_data_set_bool(settings, "target_scene_"..scene_name, is_selected)
        end
        obs.source_list_release(all_scenes)
    end
end

--- Returns the script description
function script_description()
    return [[Advanced Scene Manager with Grid Layout, Reaction Layout, and Source Tracking

Features:
1. Grid Layout - Organize sources in a grid pattern
2. Reaction Layout - Side-by-side layout with main content
3. Source Tracking - Automatically copy sources from one scene to others
4. Individual Toggles - Enable/disable each feature independently

Configure all settings in the script properties panel.]]
end

function script_update(settings)
    -- No special update handling needed
end
