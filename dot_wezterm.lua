local wezterm = require("wezterm")
local mux = wezterm.mux
local config = {}

config.window_background_opacity = 0.95
config.text_background_opacity = 1.0

-- NOTE: This has only been tested on a 1080P 16:9 screen
-- Size + center on startup
wezterm.on('gui-startup', function(cmd)
  local screen = wezterm.gui.screens().active
  local height_ratio = 0.9
  local width_ratio = 0.98
  local width = math.floor(screen.width * width_ratio)
  local height = math.floor(screen.height * height_ratio - 13)

  local _, _, window = mux.spawn_window(cmd or {})
  local gui = window:gui_window()

  gui:set_inner_size(width, height)
  gui:set_position(
    screen.x + math.floor((screen.width - width) / 2),
    screen.y + math.floor((screen.height - height) / 2 - 20)
  )
end)


config.launch_menu = {
    {
      label = 'ZSH',
      args = { 'zsh' },
    },
    {
      label = 'PowerShell',
      args = { 'pwsh.exe', '-NoLogo' },
    },
    {
      label = 'Command Prompt',
      args = { 'cmd.exe' },
    },
}

config.keys = {
	{
		key = "t",
		mods = "CTRL",
		action = wezterm.action.ShowLauncherArgs{
			flags = "FUZZY|TABS|LAUNCH_MENU_ITEMS|WORKSPACES",
		},
	},
  {
    key = 'w',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.CloseCurrentTab { confirm = false },
  },
}

config.color_scheme = "Catppuccin Mocha"

config.use_fancy_tab_bar = false

config.window_decorations = "RESIZE"

-- config.tab_bar_at_bottom = true

config.animation_fps = 10

config.font = wezterm.font("Hurmit Nerd Font Mono")

config.show_new_tab_button_in_tab_bar = false

config.default_prog = { "zsh" }

config.window_padding = {
	left = 0,
	right = 0,
	top = 0,
	bottom = 0,
}

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
	-- The filled in variant of the < symbol
	local SOLID_LEFT_ARROW = wezterm.nerdfonts.ple_left_half_circle_thick

	-- The filled in variant of the > symbol
	local SOLID_RIGHT_ARROW = wezterm.nerdfonts.ple_right_half_circle_thick
	local original_title = tab.active_pane.title
	local title = original_title
	-- 12 is the actual max width, other wise the text appears broken.
	if #original_title < 12 then
		-- If an application has set a specific title, use it as is.
		title = title
		title = title:gsub("%.[^.]*$", "")
	else
		-- Normalize Windows paths
		title = title:gsub("\\", "/")

		-- Keep only the last path component
		title = title:match("([^/]+)$") or title
		title = title:gsub("%.[^.]*$", "") or title
	end
	if #title > 12 then
		title = string.sub(original_title, 1, 9) .. ".."
		print(title)
	end

	if tab.is_active then
		return {
			{ Background = { Color = "#11111b" } },
			{ Foreground = { Color = "#89b4fa" } },
			{ Text = SOLID_LEFT_ARROW },
			{ Background = { Color = "#89b4fa" } },
			{ Foreground = { Color = "#181825" } },
			{ Text = (tab.tab_index + 1) .. " " .. title .. " " },
			{ Background = { Color = "#11111b" } },
			{ Foreground = { Color = "#89b4fa" } },
			{ Text = SOLID_RIGHT_ARROW },
		}
	else
		return {
			{ Background = { Color = "#11111b" } },
			{ Foreground = { Color = "#181825" } },
			{ Text = SOLID_LEFT_ARROW },
			{ Background = { Color = "#181825" } },
			{ Foreground = { Color = "#89b4fa" } },
			{ Text = (tab.tab_index + 1) .. " " .. title .. " " },
			{ Background = { Color = "#11111b" } },
			{ Foreground = { Color = "#181825" } },
			{ Text = SOLID_RIGHT_ARROW },
		}
	end
end)

return config
