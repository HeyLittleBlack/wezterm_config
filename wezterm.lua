local wezterm = require("wezterm")
local keys = require("key_binding").Keys()
local config = wezterm.config_builder()
config.font_size = 16

config.leader = { key = "`", mods = "ALT", timeout_milliseconds = 1000 }

config.keys = keys

config.color_scheme = "Catppuccin Mocha"
config.tab_bar_at_bottom = true
config.default_cursor_style = "SteadyBar"
config.enable_scroll_bar = true
return config
