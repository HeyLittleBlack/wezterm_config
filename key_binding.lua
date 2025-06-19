local wezterm = require("wezterm")
local act = wezterm.action
local M = {}

local function _leader_kb(key, action)
	return {
		key = key,
		mods = "LEADER",
		action = action,
	}
end

local function _ctrl_shift_kb(key, action)
	return {
		key = key,
		mods = "CTRL|SHIFT",
		action = action,
	}
end

local function _ctrl_shift_alt_kb(key, action)
	return {
		key = key,
		mods = "CTRL|SHIFT|ALT",
		action = action,
	}
end

local function _ctrl_kb(key, action)
	return {
		key = key,
		mods = "CTRL",
		action = action,
	}
end

function M.Keys()
	local keys = {
		_leader_kb("\\", act.SplitHorizontal),
		_leader_kb("-", act.SplitVertical),
		_leader_kb("UpArrow", act.ActivatePaneDirection("Up")),
		_leader_kb("DownArrow", act.ActivatePaneDirection("Down")),
		_leader_kb("LeftArrow", act.ActivatePaneDirection("Left")),
		_leader_kb("RightArrow", act.ActivatePaneDirection("Right")),
		_ctrl_shift_kb("LeftArrow", act.ActivateTabRelative(-1)),
		_ctrl_shift_kb("RightArrow", act.ActivateTabRelative(1)),
		_ctrl_shift_kb("j", act.ActivateTabRelative(-1)),
		_ctrl_shift_kb("k", act.ActivateTabRelative(1)),
		_ctrl_shift_alt_kb(
			"r",
			act.PromptInputLine({
				description = "Enter this tab name",
				action = wezterm.action_callback(function(window, pane, line)
					if line then
						window:active_tab():set_title(line)
					end
				end),
			})
		),
		_ctrl_shift_kb("<", act.MoveTabRelative(-1)),
		_ctrl_shift_kb(">", act.MoveTabRelative(1)),
		_leader_kb("j", act.ActivatePaneDirection("Down")),
		_leader_kb("k", act.ActivatePaneDirection("Up")),
		_leader_kb("h", act.ActivatePaneDirection("Left")),
		_leader_kb("l", act.ActivatePaneDirection("Right")),
	}
	for i = 1, 9 do
		table.insert(keys, _ctrl_kb(tostring(i), act.ActivateTab(i - 1)))
	end
	return keys
end

return M
