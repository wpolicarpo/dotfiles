local wezterm = require("wezterm")
local act = wezterm.action
local config = wezterm.config_builder()

-- ─────────────────────────────────────────────
-- Appearance
-- ─────────────────────────────────────────────

config.font_size = 18.0

config.window_padding = { left = 8, right = 8, top = 8, bottom = 8 }

config.enable_tab_bar = true
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = true
config.hide_tab_bar_if_only_one_tab = false

config.inactive_pane_hsb = {
  saturation = 0.1,
  brightness = 0.8,
}

config.colors = {
  tab_bar = {
    active_tab = {
      bg_color = "#b5d5f5", -- pastel blue
      fg_color = "#1a1a2e",
    },
    inactive_tab = {
      bg_color = "#2b2b3b",
      fg_color = "#888899",
    },
    inactive_tab_hover = {
      bg_color = "#3a3a4a",
      fg_color = "#aaaacc",
    },
    new_tab = {
      bg_color = "#2b2b3b",
      fg_color = "#888899",
    },
    new_tab_hover = {
      bg_color = "#3a3a4a",
      fg_color = "#aaaacc",
    },
  },
}

-- ─────────────────────────────────────────────
-- Scrollback
-- ─────────────────────────────────────────────

config.scrollback_lines = 100000

-- ─────────────────────────────────────────────
-- Bell
-- ─────────────────────────────────────────────

config.audible_bell = "Disabled"

-- ─────────────────────────────────────────────
-- Hyperlinks (CMD+click to open file paths)
-- ─────────────────────────────────────────────

config.hyperlink_rules = wezterm.default_hyperlink_rules()

-- Match absolute file paths: /foo/bar/baz.lua or /foo/bar/baz.lua:42:5
table.insert(config.hyperlink_rules, {
  regex = [[(/{1}[^\s"'<>()]+\.\w+(?::\d+(?::\d+)?)?)]],
  format = "file://$1",
})

-- Match relative file paths: ./foo/bar.lua, .config/foo/bar.lua, or with :line:col
table.insert(config.hyperlink_rules, {
  regex = [[(\.[/\w][^\s"'<>()]*\.\w+(?::\d+(?::\d+)?)?)]],
  format = "relfile://$1",
})

config.mouse_bindings = {
  -- Plain left-click: complete selection only, never open a link
  {
    event = { Up = { streak = 1, button = "Left" } },
    mods = "NONE",
    action = act.CompleteSelection("ClipboardAndPrimarySelection"),
  },
  -- CMD+click: highlight (on hover) and open link
  {
    event = { Up = { streak = 1, button = "Left" } },
    mods = "CMD",
    action = act.OpenLinkAtMouseCursor,
  },
}

-- ─────────────────────────────────────────────
-- Search mode key table
-- Override ESC to clear the pattern before closing, so the next CMD+F starts empty
-- ─────────────────────────────────────────────

local search_mode = {}
local defaults = wezterm.default_key_tables and wezterm.default_key_tables() or {}
for _, b in ipairs(defaults.search_mode or {}) do
  if b.key ~= "Escape" then
    table.insert(search_mode, b)
  end
end
table.insert(search_mode, {
  key = "Escape",
  mods = "NONE",
  action = act.Multiple({
    act.CopyMode("ClearPattern"),
    act.CopyMode("Close"),
  }),
})
config.key_tables = { search_mode = search_mode }

-- ─────────────────────────────────────────────
-- Key bindings
-- ─────────────────────────────────────────────

config.keys = {
  -- ── Pane splitting ──────────────────────────
  -- CMD+D        → split right (vertical divider, like iTerm "Split Vertically")
  -- CMD+SHIFT+D  → split down  (horizontal divider, like iTerm "Split Horizontally")
  {
    key = "d",
    mods = "CMD",
    action = act.SplitHorizontal({ domain = "CurrentPaneDomain" })
  },
  {
    key = "d",
    mods = "CMD|SHIFT",
    action = act.SplitVertical({ domain = "CurrentPaneDomain" })
  },

  -- ── Pane navigation (CMD + OPT + arrow) ─────
  {
    key = "LeftArrow",
    mods = "CMD|OPT",
    action = act.ActivatePaneDirection("Left")
  },
  {
    key = "RightArrow",
    mods = "CMD|OPT",
    action = act.ActivatePaneDirection("Right")
  },
  {
    key = "UpArrow",
    mods = "CMD|OPT",
    action = act.ActivatePaneDirection("Up")
  },
  {
    key = "DownArrow",
    mods = "CMD|OPT",
    action = act.ActivatePaneDirection("Down")
  },

  -- ── Line jump (CMD + left / right) ─────────────────
  {
    key = "LeftArrow",
    mods = "CMD",
    action = act.SendString("\x01")
  },
  {
    key = "RightArrow",
    mods = "CMD",
    action = act.SendString("\x05")
  },

  -- ── Word jump (Option|Ctrl + left / right) ───────
  -- WezTerm on macOS sends ;3C / ;3D by default — override with proper
  -- readline-compatible sequences: ESC+b (back-word) / ESC+f (forward-word)
  {
    key = "LeftArrow",
    mods = "OPT",
    action = act.SendString("\x1bb") },
  {
    key = "RightArrow",
    mods = "OPT",
    action = act.SendString("\x1bf") },
  {
    key = "LeftArrow",
    mods = "CTRL",
    action = act.SendString("\x1bb")
  },
  {
    key = "RightArrow",
    mods = "CTRL",
    action = act.SendString("\x1bf")
  },

  -- ── Tabs ────────────────────────────────────
  {
    key = "t",
    mods = "CMD",
    action = act.SpawnTab("CurrentPaneDomain") },
  {
    key = "[",
    mods = "CMD|SHIFT",
    action = act.ActivateTabRelative(-1) },
  {
    key = "]",
    mods = "CMD|SHIFT",
    action = act.ActivateTabRelative(1)  },

  -- ── Panes ───────────────────────────────────
  {
    key = "w",
    mods = "CMD",
    action = act.CloseCurrentPane({ confirm = true })
  },
  {
    key = "Enter",
    mods = "CMD|OPT",
    action = act.TogglePaneZoomState
  },

  -- ── Font size ───────────────────────────────
  {
    key = "=",
    mods = "CMD",
    action = act.IncreaseFontSize
  },
  {
    key = "-",
    mods = "CMD",
    action = act.DecreaseFontSize
  },
  {
    key = "0",
    mods = "CMD",
    action = act.ResetFontSize
  },

  -- ── Clear scrollback ────────────────────────
  {
    key = "k",
    mods = "CMD",
    action = act.ClearScrollback("ScrollbackAndViewport")
  },

  -- ── Search  ─────────────────────────────────
  {
    key = "f",
    mods = "CMD",
    action = act.Search({ CaseInSensitiveString = "" }),
  },
  {
    key = "g",
    mods = "CMD",
    action = act.CopyMode("NextMatch"),
  },
  {
    key = "g",
    mods = "CMD|SHIFT",
    action = act.CopyMode("PriorMatch"),
  }
}

return config
