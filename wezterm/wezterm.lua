local wezterm = require 'wezterm'
local sessionizer = require('sessionizer')

local config = wezterm.config_builder()
local action = wezterm.action

config.color_scheme = 'Catppuccin Frappe'
local home = ""
if wezterm.target_triple:find("windows") ~= nil then
    home = os.getenv("USERPROFILE") or ""
else
    home = os.getenv("HOME") or ""
end
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

    -- workspaces
    { key = "w", mods = "LEADER",      action = action.ShowLauncherArgs({ flags = "FUZZY|WORKSPACES" }) },
    { key = "w", mods = "LEADER|CTRL", action = action.SwitchToWorkspace({ name = "default", spawn = { cwd = home } }) },
    { key = "u", mods = "LEADER",      action = action.SwitchToWorkspace({ name = "WSL", spawn = { domain = { DomainName = "WSL:Ubuntu" } } }) },
    { key = "f", mods = "LEADER",      action = wezterm.action_callback(sessionizer.toggle_dev) },
    { key = "f", mods = "LEADER|CTRL", action = action.ShowLauncherArgs({ flags = "FUZZY|DOMAINS" }) },
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

return config
