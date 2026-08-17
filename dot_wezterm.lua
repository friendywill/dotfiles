local wezterm = require("wezterm")
local act = wezterm.action
local mux = wezterm.mux
local config = {}
-- The filled in variant of the < symbol
local SOLID_LEFT_ARROW = wezterm.nerdfonts.ple_left_half_circle_thick

-- The filled in variant of the > symbol
local SOLID_RIGHT_ARROW = wezterm.nerdfonts.ple_right_half_circle_thick
if wezterm.config_builder then
	config = wezterm.config_builder()
end

config.window_background_opacity = 0.85
config.text_background_opacity = 1.0

-- NOTE: This has only been tested on a 1080P 16:9 screen
-- Size + center on startup
wezterm.on("gui-startup", function(cmd)
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
	gui:perform_action(
		wezterm.action.PromptInputLine({
			description = "Enter name for initial workspace:",
			action = wezterm.action_callback(function(win, p, line)
				if line and line ~= "" then
					wezterm.mux.rename_workspace(win:mux_window():get_workspace(), line)
				end
			end),
		}),
		_)
end)

wezterm.on('trigger-fuzzy-workspace-switcher', function(window, pane)
  local choices = {
    { id = '__CREATE_NEW__', label = '➕ [Create a brand new named workspace]' }
  }
  
  for _, ws in ipairs(wezterm.mux.get_workspace_names()) do
    table.insert(choices, { id = ws, label = '💼 ' .. ws })
  end

  window:perform_action(
    act.InputSelector {
      title = 'Fuzzy Workspace Switcher',
      choices = choices,
      fuzzy = true,
      action = wezterm.action_callback(function(win, p, id, label)
        if id == '__CREATE_NEW__' then
          win:perform_action(
            act.PromptInputLine {
              description = 'Enter name for your new workspace:',
              action = wezterm.action_callback(function(w, pane_inner, line)
                if line and line ~= "" then
                  w:perform_action(act.SwitchToWorkspace { name = line }, pane_inner)
                end
              end),
            },
            p
          )
        elseif id then
          win:perform_action(act.SwitchToWorkspace { name = id }, p)
        end
      end),
    },
    pane
  )
end)

-- 2. Inject it into the Command Palette
wezterm.on('augment-command-palette', function(window, pane)
  return {
    {
      brief = 'Workspace: Switch or Create',
      icon = 'md_folder_swap',
      -- Emit the custom event when selected in the palette
      action = act.EmitEvent('trigger-fuzzy-workspace-switcher'),
    },
  }
end)

local background_color = "#11111b"
local foreground_color = "#89b4fa"
local secondary_color = "#fab387"

wezterm.on("update-right-status", function(window, pane)
  local date = wezterm.strftime '%d %b %H:%M'
	window:set_right_status(
	wezterm.format({
		{ Background = { Color = background_color } },
		{ Foreground = { Color = secondary_color } },
		{ Text = SOLID_LEFT_ARROW },
		{ Background = { Color = secondary_color } },
		{ Foreground = { Color = background_color } },
		{ Text = wezterm.nerdfonts.fa_folder .. " " .. window:active_workspace() },
		{ Background = { Color = background_color } },
		{ Foreground = { Color = secondary_color } },
		{ Text = SOLID_RIGHT_ARROW },
		{ Background = { Color = background_color } },
		{ Foreground = { Color = foreground_color } },
		{ Text = SOLID_LEFT_ARROW },
		{ Background = { Color = foreground_color } },
		{ Foreground = { Color = background_color } },
		{ Text = wezterm.nerdfonts.md_clock .. " " .. date },
		{ Background = { Color = background_color } },
		{ Foreground = { Color = foreground_color } },
		{ Text = SOLID_RIGHT_ARROW },
	})
  )
end)

config.launch_menu = {
	{
		label = "ZSH",
		args = { "zsh" },
	},
	{
		label = "PowerShell",
		args = { "pwsh.exe", "-NoLogo" },
	},
	{
		label = "Command Prompt",
		args = { "cmd.exe" },
	},
}
config.leader = { key = "b", mods = "CTRL", timeout_milliseconds = 5000 }

config.keys = {
	{
		key = "t",
		mods = "CTRL",
		action = act.ShowLauncherArgs({
			flags = "FUZZY|LAUNCH_MENU_ITEMS",
		}),
	},
	{
		key = "w",
		mods = "CTRL|SHIFT",
		action = act.CloseCurrentTab({ confirm = false }),
	},
	{ key = "o", mods = "LEADER", action = act.EmitEvent('trigger-fuzzy-workspace-switcher')},
	-- Send Ctrl+b to terminal when pressed twice
	{ key = "b", mods = "LEADER|CTRL", action = act.SendString("\x02") },

	{ key = "w", mods = "LEADER", action = act.ActivateKeyTable({ name = "window_mode", one_shot = true }) },

	-- Flat binding
	{ key = "-", mods = "LEADER", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
	{ key = "\\", mods = "LEADER", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
	{ key = "s", mods = "LEADER", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
	{ key = "v", mods = "LEADER", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
	{ key = "c", mods = "LEADER", action = act.SpawnTab("CurrentPaneDomain") },
	{ key = "n", mods = "LEADER", action = act.ActivateTabRelative(1) },
	{ key = "p", mods = "LEADER", action = act.ActivateTabRelative(-1) },

	-- Navigation
	{ key = "h", mods = "LEADER", action = act.ActivatePaneDirection("Left") },
	{ key = "j", mods = "LEADER", action = act.ActivatePaneDirection("Down") },
	{ key = "k", mods = "LEADER", action = act.ActivatePaneDirection("Up") },
	{ key = "l", mods = "LEADER", action = act.ActivatePaneDirection("Right") },

	-- Resizing
	{ key = "h", mods = "CTRL", action = act.AdjustPaneSize({ "Left", 5 }) },
	{ key = "j", mods = "CTRL", action = act.AdjustPaneSize({ "Down", 5 }) },
	{ key = "k", mods = "CTRL", action = act.AdjustPaneSize({ "Up", 5 }) },
	{ key = "l", mods = "CTRL", action = act.AdjustPaneSize({ "Right", 5 }) },

	-- Tab Navigation (1-9)
	{ key = "1", mods = "LEADER", action = act.ActivateTab(0) },
	{ key = "2", mods = "LEADER", action = act.ActivateTab(1) },
	{ key = "3", mods = "LEADER", action = act.ActivateTab(2) },
	{ key = "4", mods = "LEADER", action = act.ActivateTab(3) },
	{ key = "5", mods = "LEADER", action = act.ActivateTab(4) },
	{ key = "6", mods = "LEADER", action = act.ActivateTab(5) },
	{ key = "7", mods = "LEADER", action = act.ActivateTab(6) },
	{ key = "8", mods = "LEADER", action = act.ActivateTab(7) },
	{ key = "9", mods = "LEADER", action = act.ActivateTab(8) },

	{ key = "x", mods = "LEADER", action = act.CloseCurrentPane({ confirm = true }) },
}
---[ Key Tables
config.key_tables = {

	-- Triggered by <leader> w
	window_mode = {
		{ key = "v", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
		{ key = "s", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
		{ key = "Escape", action = "PopKeyTable" },
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
			{ Background = { Color = background_color } },
			{ Foreground = { Color = foreground_color } },
			{ Text = SOLID_LEFT_ARROW },
			{ Background = { Color = foreground_color } },
			{ Foreground = { Color = "#181825" } },
			{ Text = (tab.tab_index + 1) .. " " .. title .. " " },
			{ Background = { Color = background_color } },
			{ Foreground = { Color = foreground_color } },
			{ Text = SOLID_RIGHT_ARROW },
		}
	else
		return {
			{ Background = { Color = background_color } },
			{ Foreground = { Color = "#181825" } },
			{ Text = SOLID_LEFT_ARROW },
			{ Background = { Color = "#181825" } },
			{ Foreground = { Color = foreground_color } },
			{ Text = (tab.tab_index + 1) .. " " .. title .. " " },
			{ Background = { Color = background_color } },
			{ Foreground = { Color = "#181825" } },
			{ Text = SOLID_RIGHT_ARROW },
		}
	end
end)

return config
