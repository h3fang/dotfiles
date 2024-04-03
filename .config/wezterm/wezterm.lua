local wezterm = require("wezterm")
local config = wezterm.config_builder()
local act = wezterm.action

config.font = wezterm.font_with_fallback({
  "Hack Nerd Font",
  "Noto Sans Symbols 2",
  "monospace",
})

config.font_size = 13.0
config.window_background_opacity = 0.90
config.scrollback_lines = 10000
config.enable_scroll_bar = true
config.use_fancy_tab_bar = false
config.hide_tab_bar_if_only_one_tab = true
config.use_dead_keys = false

config.disable_default_key_bindings = true
config.keys = {}

local keys = require("default_key_bindings").keys
for _, v in ipairs(keys) do
  if string.find(v.mods, "SUPER") == nil then
    table.insert(config.keys, v)
  end
end

config.mouse_bindings = {
  -- Change the default click behavior so that it only selects
  -- text and doesn't open hyperlinks
  {
    event = { Up = { streak = 1, button = "Left" } },
    mods = "NONE",
    action = act.CompleteSelection("ClipboardAndPrimarySelection"),
  },

  -- and make CTRL-Click open hyperlinks
  {
    event = { Up = { streak = 1, button = "Left" } },
    mods = "CTRL",
    action = act.OpenLinkAtMouseCursor,
  },
}

config.colors = {
  -- The default text color
  foreground = "white",
  -- The default background color
  background = "black",

  -- Overrides the cell background color when the current cell is occupied by the
  -- cursor and the cursor style is set to Block
  cursor_bg = "#1a8fff",
  -- Overrides the text color when the current cell is occupied by the cursor
  cursor_fg = "black",

  -- the foreground color of selected text
  selection_fg = "black",
  -- the background color of selected text
  selection_bg = "#affacd",

  -- The color of the scrollbar "thumb"; the portion that represents the current viewport
  scrollbar_thumb = "#666",

  -- The color of the split lines between panes
  split = "#666",

  ansi = {
    "black",
    "#B61C2B",
    "#00AA00",
    "#AA5500",
    "#0952EB",
    "#BB08BB",
    "#07BBBB",
    "#AAAAAA",
  },
  brights = {
    "#555555",
    "#ff5555",
    "#55FF55",
    "#FFFF55",
    "#1a8fff",
    "#FF55FF",
    "#55FFFF",
    "white",
  },
}

return config
