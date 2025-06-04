local wezterm = require("wezterm")
local act = wezterm.action

local M = {}

local sep = "/"
local pathsep = ":"
if wezterm.target_triple:find("windows") ~= nil then
	sep = "\\"
	pathsep = ";"
end

---split a string `s` by its separator `separator`
---@param s string
---@param separator string?
---@return table
local function split(s, separator)
	if separator == nil then
		separator = "%s"
	end
	local t = {}
	for str in string.gmatch(s, "([^" .. separator .. "]+)") do
		table.insert(t, str)
	end
	return t
end

---merge two tables together and return merged tables
---@param table1 table
---@param table2 table
---@return table
local function merge(table1, table2)
	local t = {}
	for _, v in ipairs(table1) do
		table.insert(t, v)
	end
	for _, v in ipairs(table2) do
		table.insert(t, v)
	end
	return t
end

M.toggle_dev = function(window, pane)
	local dev = os.getenv("DEV")
	local devPaths = {}
	if dev == nil then
		---@type table
		devPaths = { wezterm.home_dir .. sep .. "development" }
	else
		devPaths = split(dev, pathsep)
	end

	local projects = {}

	local success, stdout, stderr = wezterm.run_child_process(merge({
		"fd",
		"-t",
		"d",
		"-d",
		"1",
		"-u",
		".",
	}, devPaths))

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
								args = {
									"pwsh",
									"-NoExit",
									"-c",
									"wezterm",
									"cli",
									"spawn",
									"--cwd",
									label,
									"&",
									"nvim",
								},
							},
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
