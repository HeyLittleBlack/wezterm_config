local wezterm = require("wezterm")
local M = {}

local choices = {
	{
		id = "/Users/homantix/self/notes/",
		label = "MacOS_ws",
	},
	{
		id = "/mnt/work/",
		label = "Linux_ws",
	},
}
local layouts = {}

layouts[choices[1].label] = {
	{
		tabname = "notes",
	},
	{
		tabname = "configwez",
		cwd = "/Users/homantix/.config/wezterm/",
	},
	{
		tabname = "coding",
		cwd = "/Users/homantix/self/codes/",
	},
}

layouts[choices[2].label] = {}

function M.bind()
	return wezterm.action_callback(function(window, pane)
		window:perform_action(
			wezterm.action.InputSelector({
				title = "Choose Workspace",
				choices = choices,
				action = wezterm.action_callback(function(new_window, new_pane, id, label)
					-- new_pane:send_text(id .. label)
					new_window:perform_action(
						wezterm.action.SwitchToWorkspace({
							name = label,
							spawn = {
								label = "Workspace: " .. label,
								cwd = id,
							},
						}),
						new_pane
					)
					new_window:tabs_with_info().tab:set_title(layouts[label][1].tabname)
					for i = 2, #layouts[label] do
						local n_tab, pane, window = window:spawn_tab({})
					end
				end),
			}),
			pane
		)
	end)
end

return M
