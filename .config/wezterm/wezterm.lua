-- Pull in the wezterm API
local wezterm = require("wezterm")
local act = wezterm.action

-- This table will hold the configuration
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
	config = wezterm.config_builder()
end

-- This is where you actually apply your config choices
config.term = "xterm-256color"
config.color_scheme = "Catppuccin Mocha"

config.animation_fps = 60
config.max_fps = 60
config.front_end = "WebGpu"
config.webgpu_power_preference = "HighPerformance"

config.font_size = 15
-- config.line_height = 1.1

config.font = wezterm.font("JetBrains Mono")
config.harfbuzz_features = {
	"calt",
	"liga",
	"ss01",
	"ss02",
	"ss04",
	"ss05",
	"ss06",
	"ss07",
	"ss08",
	"ss10",
	"ss11",
	"ss12",
	"ss17",
	"ss18",
}

config.use_fancy_tab_bar = false
config.enable_tab_bar = false
config.tab_bar_at_bottom = true
config.show_new_tab_button_in_tab_bar = true

config.window_padding = {
	top = "8pt",
	left = "12pt",
	right = "12pt",
	bottom = "4pt",
}
config.native_macos_fullscreen_mode = true
config.window_close_confirmation = "NeverPrompt"
config.window_decorations = "RESIZE"
config.window_background_opacity = 0.8
config.macos_window_background_blur = 30
config.inactive_pane_hsb = {
	saturation = 0.9,
	brightness = 0.65,
}
config.force_reverse_video_cursor = true

config.default_cursor_style = "BlinkingBar"
config.hyperlink_rules = wezterm.default_hyperlink_rules()
-- key bindings
config.keys = {
	{
		key = "d",
		mods = "SUPER|SHIFT",
		action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
	},
	{
		key = "d",
		mods = "SUPER",
		action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }),
	},
	-- close tab
	{ key = "w", mods = "SUPER|SHIFT", action = act.CloseCurrentTab({ confirm = false }) },
	-- close pane
	{ key = "w", mods = "SUPER", action = act.CloseCurrentPane({ confirm = false }) },
}
config.mouse_bindings = {
	{
		event = { Up = { streak = 1, button = "Left" } },
		mods = "SUPER",
		action = wezterm.action.OpenLinkAtMouseCursor,
	},
}
return config
-- return {
-- 	-- color_scheme = 'termnial.sexy',
-- 	color_scheme = "Catppuccin Mocha",
-- 	enable_tab_bar = true,
-- 	font_size = 13.0,
-- 	font = wezterm.font("JetBrains Mono"),
-- 	-- macos_window_background_blur = 40,
-- 	macos_window_background_blur = 30,
--
-- 	-- window_background_image = "/home/himura/Pictures/w1.jpg",
-- 	-- window_background_image = '/Users/omerhamerman/Downloads/3840x1080-Wallpaper-041.jpg',
-- 	-- window_background_image_hsb = {
-- 	-- 	brightness = 0.01,
-- 	-- 	hue = 1.0,
-- 	-- 	saturation = 0.5,
-- 	-- },
-- 	-- window_background_opacity = 0.92,
-- 	-- window_background_opacity = 1.0,
-- 	window_background_opacity = 0.78,
-- 	-- window_background_opacity = 0.20,
-- 	window_decorations = "RESIZE",
-- 	keys = {
-- 		{
-- 			key = "f",
-- 			mods = "CTRL",
-- 			action = wezterm.action.ToggleFullScreen,
-- 		},
-- 	},
-- 	mouse_bindings = {
-- 		-- Ctrl-click will open the link under the mouse cursor
-- 		{
-- 			event = { Up = { streak = 1, button = "Left" } },
-- 			mods = "CTRL",
-- 			action = wezterm.action.OpenLinkAtMouseCursor,
-- 		},
-- 	},
-- }
