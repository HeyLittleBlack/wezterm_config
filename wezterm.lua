local wezterm = require("wezterm")
local keys = require("key_binding").Keys()
local mouse_bindings = require("mouse_binding").MouseBindings()
local config = wezterm.config_builder()
config.font_size = 16

config.leader = { key = "`", mods = "ALT", timeout_milliseconds = 1000 }

config.keys = keys
config.mouse_bindings = mouse_bindings

-- config.color_scheme = "Catppuccin Mocha"
-- config.color_scheme = "Dracula (Gogh)"
-- config.color_scheme = "Catppuccin Latte"
config.color_scheme = "Sakura"
config.tab_bar_at_bottom = true
config.default_cursor_style = "SteadyBar"
config.enable_scroll_bar = true
-- config.window_background_image = "/Users/homantix/Pictures/wallpaper/wallhaven-j3dgmy.jpg"
--
-- config.background = {
-- 	{
-- 		source = {
-- 			-- File = "/Users/homantix/Pictures/wallpaper/wallhaven-6dr5rl.jpg",
-- 			-- File = "/Users/homantix/Pictures/wallpaper/wallhaven-zpxzrj.png",
-- 		},
-- 		-- width = "100%",
-- 		height = "100%",
-- 		-- opacity = 0.9,
-- 		hsb = {
-- 			hue = 1.0,
-- 			saturation = 1.0,
-- 			brightness = 0.2,
-- 		},
-- 	},
-- }
return config
