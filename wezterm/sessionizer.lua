local wezterm = require("wezterm")
local act = wezterm.action

local M = {}

local sep = "/"
if wezterm.target_triple:find("windows") ~= nil then
    sep = "\\"
end

local rootPath = os.getenv("DEV")

M.toggle_dev = function(window, pane)
    local projects = {}

    local success, stdout, stderr = wezterm.run_child_process({
        "fd",
        "-t",
        "d",
        "-d",
        "1",
        "-u",
        ".",
        rootPath,
        rootPath .. sep .. "alerts-server"
        -- add more paths here
    })

    if not success then
        wezterm.log_error("Failed to run fd: " .. stderr)
        return
    end

    for line in stdout:gmatch("([^\n]*)\n?") do
        local project = line:gsub(sep .. "$", "")
        local label = project
        local id = project:gsub(".*" .. sep, "")
        table.insert(projects, { label = tostring(label), id = tostring(id) })
    end

    window:perform_action(
        act.InputSelector({
            action = wezterm.action_callback(function(win, _, id, label)
                if not id and not label then
                    wezterm.log_info("Cancelled")
                else
                    wezterm.log_info("Selected " .. label)
                    win:perform_action(
                        act.SwitchToWorkspace({
                            name = id,
                            spawn = {
                                domain = { DomainName = "local" },
                                cwd = label,
                                args = { 'pwsh', '-c', 'wezterm', 'cli', 'spawn', '--cwd', label, '&', 'nvim', },
                            }
                        }),
                        pane
                    )
                end
            end),
            fuzzy = true,
            title = "Select project",
            choices = projects,
        }),
        pane
    )
end


M.toggle_domain = function(window, pane)
    local domains = wezterm.mux.all_domains()
    table.sort(domains, function(a, b)
        return a:name() < b:name()
    end)
    local list = {}
    for _, domain in ipairs(domains) do
        table.insert(list, { label = domain:name(), id = domain:name() })
    end

    window:perform_action(
        act.InputSelector({
            action = wezterm.action_callback(function(win, _, id, label)
                if not id and not label then
                    wezterm.log_info("Cancelled")
                else
                    wezterm.log_info("Selected " .. label)
                    win:perform_action(
                        act.SwitchToWorkspace({ name = id, spawn = { domain = { DomainName = label } } }),
                        pane
                    )
                end
            end),
            fuzzy = true,
            title = "Select domain",
            choices = list,
        }),
        pane
    )
end

return M
