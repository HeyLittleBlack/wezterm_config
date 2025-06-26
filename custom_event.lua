local wezterm = require("wezterm")
local M = {}

local choices = {}

function M.bind()
	return wezterm.action_callback(function(window, pane)
		window:perform_action(
			wezterm.action.InputSelector({
				title = "Choose Workspace",
				choices = choices,
				action = wezterm.action_callback(function(new_window, new_pane, id, label)
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
				end),
			}),
			pane
		)
	end)
end

return M
