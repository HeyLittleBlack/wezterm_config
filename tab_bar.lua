local wezterm = require("wezterm")

local M = {}
local right_arrow = utf8.char(0xe0b0)

local colors = {
	bar = "#151821",
	active = "#2878d0",
	inactive = "#343b4c",
	hover = "#465168",
	text = "#f2f4f8",
}

function M.apply(config)
	config.use_fancy_tab_bar = false
	config.tab_max_width = 48
	config.colors = config.colors or {}
	config.colors.tab_bar = {
		background = colors.bar,
		new_tab = { bg_color = colors.bar, fg_color = colors.text },
		new_tab_hover = { bg_color = colors.hover, fg_color = colors.text },
	}

	wezterm.on("format-tab-title", function(tab, tabs, _, _, _, max_width)
		local background = tab.is_active and colors.active or colors.inactive
		local title = tab.tab_title
		if title == "" then
			title = tab.active_pane.title:gsub("[/\\]+$", ""):match("([^/\\]+)$") or tab.active_pane.title
		end
		title = string.format("%d: %s", tab.tab_index + 1, title)
		local edge_width = (tab.tab_index > 0 and 1 or 0) + (tab.tab_index == #tabs - 1 and 1 or 0)
		title = wezterm.truncate_right(title, max_width - edge_width - 2)

		local title_format = {}
		if tab.tab_index > 0 then
			local previous = tabs[tab.tab_index]
			local previous_background = previous.is_active and colors.active or colors.inactive
			title_format[#title_format + 1] = { Background = { Color = background } }
			title_format[#title_format + 1] = { Foreground = { Color = previous_background } }
			title_format[#title_format + 1] = { Text = right_arrow }
		end

		title_format[#title_format + 1] = { Background = { Color = background } }
		title_format[#title_format + 1] = { Foreground = { Color = colors.text } }
		title_format[#title_format + 1] = { Text = " " .. title .. " " }

		if tab.tab_index == #tabs - 1 then
			title_format[#title_format + 1] = { Background = { Color = colors.bar } }
			title_format[#title_format + 1] = { Foreground = { Color = background } }
			title_format[#title_format + 1] = { Text = right_arrow }
		end

		return title_format
	end)
end

return M
