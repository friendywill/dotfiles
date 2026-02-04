local wezterm = require("wezterm")
local config = {}

wezterm.plugin.require("https://gitlab.com/xarvex/presentation.wez").apply_to_config(config, {
	font_size_multiplier = 1.3, -- sets for both "presentation" and "presentation_full"
	presentation_full = {
		font_weight = "Bold",
		font_size_multiplier = 2.4, -- overwrites "font_size_multiplier" for "presentation_full"
	},
})

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

config.launch_menu_size = {
  width = 0.5,
  height = 0.5,
}
config.keys = {
	{
		key = "t",
		mods = "CTRL",
		action = wezterm.action.ShowLauncherArgs{
			flags = "FUZZY|TABS|LAUNCH_MENU_ITEMS|WORKSPACES",
		},
	},
}

config.color_scheme = "Catppuccin Mocha"

config.use_fancy_tab_bar = false

config.window_decorations = "RESIZE"

config.tab_bar_at_bottom = true

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
