local wezterm = require("wezterm")
local act = wezterm.action
local ce = require("custom_event")

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

local function _send_key(key, mods, new_key, new_mods)
	return {
		key = key,
		mods = mods,
		action = act.SendKey({
			key = new_key,
			mods = new_mods,
		}),
	}
end

function M.work_workspace(cmd)
	local work_ws = nil

	local is_darwin = wezterm.target_triple:find("darwin") ~= nil
	local is_linux = wezterm.target_triple:find("linux") ~= nil

	if is_linux then
		work_ws = ce.layouts[ce.choices[2].label]
	end

	if is_darwin then
		work_ws = ce.layouts[ce.choices[1].label]
	end

	if work_ws == nil then
		return
	end

	print(work_ws)

	local tab, pane, window = wezterm.mux.spawn_window({ cwd = work_ws[1].cwd })
	tab:set_title(work_ws[1].tabname)
	window:set_workspace("work")
	for i = 2, #work_ws do
		local tmp_tab, tmp_pane, tmp_window = window:spawn_tab({ cwd = work_ws[i].cwd })
		tmp_tab:set_title(work_ws[i].tabname)
	end
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
		_ctrl_shift_kb("o", act.ActivateLastTab),
		_leader_kb("j", act.ActivatePaneDirection("Down")),
		_leader_kb("k", act.ActivatePaneDirection("Up")),
		_leader_kb("h", act.ActivatePaneDirection("Left")),
		_leader_kb("l", act.ActivatePaneDirection("Right")),
		_send_key("k", "OPT", "RightArrow", ""),
		_send_key("l", "OPT", "RightArrow", ""),
		_send_key("j", "OPT", "UpArrow", ""),
		-- { key = "l", mods = "ALT", action = ce.bind() },
		{
			key = "9",
			mods = "ALT",
			action = wezterm.action.ShowLauncherArgs({ flags = "TABS|WORKSPACES|LAUNCH_MENU_ITEMS" }),
		},
		-- {
		-- 	key = "0",
		-- 	mods = "ALT",
		-- 	action = wezterm.action.ShowLauncherArgs({ flags = "FUZZY|TABS" }),
		-- },
		{
			key = "0",
			mods = "ALT",
			action = act.InputSelector({
				title = "Search Tabs by Name or Path",
				fuzzy = true,
				choices = (function()
					local choices = {}
					-- 遍历所有活动的标签页
					for _, window in ipairs(wezterm.mux.all_windows()) do
						for _, tab in ipairs(window:tabs()) do
							local active_pane = tab:active_pane()
							local title = tab:get_title()
							-- 获取当前路径 (OSC 7 序列支持)
							local cwd = active_pane:get_current_working_dir()
							local path_str = ""

							if cwd then
								-- 转换路径格式（去除 file:// 前缀）
								path_str = cwd.file_path
							end

							table.insert(choices, {
								id = tostring(tab:tab_id()),
								-- 这里的 label 是搜索的关键，我们将标题和路径拼接在一起
								label = string.format("Tab: %s  |  Path: %s", title, path_str),
							})
						end
					end
					return choices
				end)(),
				action = wezterm.action_callback(function(window, pane, id, label)
					if id then
						local tab = wezterm.mux.get_tab(id)
						if tab then
							tab:activate()
						end
					end
				end),
			}),
		},
		{ key = "UpArrow", mods = "SHIFT", action = act.ScrollToPrompt(-1) },
		{ key = "DownArrow", mods = "SHIFT", action = act.ScrollToPrompt(1) },
	}
	for i = 0, 9 do
		table.insert(keys, _ctrl_kb(tostring(i), act.ActivateTab(i - 1)))
	end
	return keys
end

function M.MacOSKeys()
	return {
		{ key = "LeftArrow", mods = "OPT", action = act.SendString("\x1bb") },
		-- Make Option-Right equivalent to Alt-f; forward-word
		{ key = "RightArrow", mods = "OPT", action = act.SendString("\x1bf") },
		_send_key("s", "CMD", "s", "CTRL"),
	}
end

return M
