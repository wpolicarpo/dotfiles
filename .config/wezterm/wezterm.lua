local wezterm = require("wezterm")
local act = wezterm.action
local config = wezterm.config_builder()

-- ─────────────────────────────────────────────
-- Appearance
-- ─────────────────────────────────────────────

config.font = wezterm.font("JetBrains Mono", { weight = "Regular" })
config.font_size = 13.0

config.window_padding = { left = 8, right = 8, top = 8, bottom = 8 }

config.enable_tab_bar = true
config.use_fancy_tab_bar = true -- set to true for a macOS-native look
config.tab_bar_at_bottom = false
config.hide_tab_bar_if_only_one_tab = false

-- ─────────────────────────────────────────────
-- Scrollback
-- ─────────────────────────────────────────────

config.scrollback_lines = 10000

-- ─────────────────────────────────────────────
-- Bell
-- ─────────────────────────────────────────────

config.audible_bell = "Disabled"

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
    action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }),
  },
  {
    key = "d",
    mods = "CMD|SHIFT",
    action = act.SplitVertical({ domain = "CurrentPaneDomain" }),
  },

  -- ── Pane navigation (CMD + arrow) ───────────
  { key = "LeftArrow",  mods = "CMD", action = act.ActivatePaneDirection("Left")  },
  { key = "RightArrow", mods = "CMD", action = act.ActivatePaneDirection("Right") },
  { key = "UpArrow",    mods = "CMD", action = act.ActivatePaneDirection("Up")    },
  { key = "DownArrow",  mods = "CMD", action = act.ActivatePaneDirection("Down")  },

  -- ── Word jump (Option + left / right) ───────
  -- WezTerm on macOS sends ;3C / ;3D by default — override with proper
  -- readline-compatible sequences: ESC+b (back-word) / ESC+f (forward-word)
  { key = "LeftArrow",  mods = "OPT", action = act.SendString("\x1bb") },
  { key = "RightArrow", mods = "OPT", action = act.SendString("\x1bf") },

  -- ── Tabs ────────────────────────────────────
  { key = "t", mods = "CMD",       action = act.SpawnTab("CurrentPaneDomain") },
  { key = "w", mods = "CMD",       action = act.CloseCurrentTab({ confirm = true }) },
  { key = "[", mods = "CMD|SHIFT", action = act.ActivateTabRelative(-1) },
  { key = "]", mods = "CMD|SHIFT", action = act.ActivateTabRelative(1)  },

  -- ── Zoom current pane ────────────────────────
  { key = "z", mods = "CMD", action = act.TogglePaneZoomState },

  -- ── Font size ───────────────────────────────
  { key = "=", mods = "CMD", action = act.IncreaseFontSize },
  { key = "-", mods = "CMD", action = act.DecreaseFontSize },
  { key = "0", mods = "CMD", action = act.ResetFontSize     },

  -- ── Clear scrollback ────────────────────────
  {
    key = "k",
    mods = "CMD",
    action = act.ClearScrollback("ScrollbackAndViewport"),
  },
}

return config
