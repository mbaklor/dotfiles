local wezterm = require 'wezterm'
local sessionizer = require('sessionizer')

local config = wezterm.config_builder()
local action = wezterm.action

local ctp = wezterm.plugin.require("https://github.com/mbaklor/ctp-wezterm")
ctp.apply_to_config(config, {
    flavor = "macchiato",
})

local bar = wezterm.plugin.require("https://github.com/adriankarlen/bar.wezterm")
bar.apply_to_config(config, {
    position = "top",
    separator = {
        space = 1,
        left_icon = wezterm.nerdfonts.pl_left_soft_divider,
        right_icon = wezterm.nerdfonts.pl_right_soft_divider,
        field_icon = wezterm.nerdfonts.indent_line,
    },
    modules = {
        pane = {
            enabled = false
        },
        username = {
            enabled = false
        },
        hostname = {
            enabled = false
        },
    }
})

config.colors.tab_bar.active_tab.bg_color = ctp.get_color("macchiato", "green")

config.font = wezterm.font('Hack Nerd Font Mono', { weight = 'Regular' })
config.font_size = 12

config.window_decorations = "RESIZE"
config.use_fancy_tab_bar = false
-- config.hide_tab_bar_if_only_one_tab = true

if wezterm.target_triple:find("windows") ~= nil then
    config.window_background_opacity = 0.85
    config.win32_system_backdrop = "Acrylic"
    config.default_prog = { "pwsh" }
end

local mux = wezterm.mux

wezterm.on("gui-startup", function()
    local tab, pane, window = mux.spawn_window {}
    window:gui_window():maximize()
end)

config.leader = { key = 'a', mods = 'CTRL', timeout_milliseconds = 1000 }
config.keys = {
    { key = "a", mods = "LEADER|CTRL", action = action.SendKey({ key = "a", mods = "CTRL" }) },
    { key = "y", mods = "LEADER",      action = action.ActivateCopyMode },
    { key = "q", mods = "LEADER",      action = action.Multiple { action.ClearScrollback('ScrollbackAndViewport'), action.SendKey({ key = "l", mods = "CTRL" }) } },
    -- panes
    { key = "s", mods = "LEADER",      action = action.SplitVertical({ domain = 'CurrentPaneDomain' }) },
    { key = "v", mods = "LEADER",      action = action.SplitHorizontal({ domain = 'CurrentPaneDomain' }) },
    { key = "c", mods = "LEADER",      action = action.CloseCurrentPane({ confirm = true }) },
    { key = "z", mods = "LEADER",      action = action.TogglePaneZoomState },
    { key = "r", mods = "LEADER",      action = action.ActivateKeyTable({ name = "resize_pane", one_shot = false }) },

    -- pane navigation
    { key = "h", mods = "LEADER",      action = action.ActivatePaneDirection('Left') },
    { key = "j", mods = "LEADER",      action = action.ActivatePaneDirection('Down') },
    { key = "k", mods = "LEADER",      action = action.ActivatePaneDirection('Up') },
    { key = "l", mods = "LEADER",      action = action.ActivatePaneDirection('Right') },

    -- tabs
    { key = "t", mods = "LEADER",      action = action.SpawnTab('CurrentPaneDomain') },
    { key = "g", mods = "LEADER",      action = action.SpawnCommandInNewTab({ args = { 'lazygit' } }) },
    { key = "e", mods = "LEADER",      action = action.SpawnCommandInNewTab({ args = { 'yazi' } }) },
    { key = "p", mods = "LEADER",      action = action.ActivateTabRelative(-1) },
    { key = "n", mods = "LEADER",      action = action.ActivateTabRelative(1) },
    { key = "p", mods = "LEADER|CTRL", action = action.MoveTabRelative(-1) },
    { key = "n", mods = "LEADER|CTRL", action = action.MoveTabRelative(1) },

    -- workspaces
    { key = "w", mods = "LEADER",      action = action.ShowLauncherArgs({ flags = "FUZZY|WORKSPACES" }) },
    { key = "w", mods = "LEADER|CTRL", action = action.SwitchToWorkspace({ name = "default", spawn = { domain = { DomainName = "local" }, cwd = wezterm.home_dir } }) },
    { key = "u", mods = "LEADER",      action = action.SwitchToWorkspace({ name = "WSL", spawn = { domain = { DomainName = "WSL:Ubuntu" } } }) },
    { key = "f", mods = "LEADER",      action = wezterm.action_callback(sessionizer.toggle_dev) },
    { key = "f", mods = "LEADER|CTRL", action = wezterm.action_callback(sessionizer.toggle_domain) },
    { key = "[", mods = "LEADER",      action = action.SwitchWorkspaceRelative(-1) },
    { key = "]", mods = "LEADER",      action = action.SwitchWorkspaceRelative(1) },
}

for i = 1, 9 do
    table.insert(config.keys, {
        key = tostring(i), mods = "LEADER", action = action.ActivateTab(i - 1)
    })
end

config.key_tables = {
    resize_pane = {
        { key = "h",      action = action.AdjustPaneSize { "Left", 5 } },
        { key = "j",      action = action.AdjustPaneSize { "Down", 5 } },
        { key = "k",      action = action.AdjustPaneSize { "Up", 5 } },
        { key = "l",      action = action.AdjustPaneSize { "Right", 5 } },
        { key = "Escape", action = "PopKeyTable" },
        { key = "Enter",  action = "PopKeyTable" },
    },
}

-- wezterm.status_update_interval = 1000
-- wezterm.on('update-status', function(window, pane)
--     local left_status = {
--         { Background = { Color = ctp.get_color("macchiato", "blue") } },
--         { Text = "  " } }
--     if window:leader_is_active() then
--         left_status = {
--             { Background = { Color = ctp.get_color("macchiato", "peach") } },
--             { Foreground = { Color = ctp.get_color("macchiato", "crust") } },
--             { Text = "> " }
--         }
--     end
--     window:set_left_status(wezterm.format(left_status))
-- end)
--
return config
