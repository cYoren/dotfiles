-- Keep only your personal keybinding overrides here. Add new bindings or
-- unbind defaults before replacing them.

-- See current bindings and descriptions:
--   omarchy menu keybindings --print

-- To disable every Omarchy default binding, set this in
-- ~/.config/hypr/hyprland.lua before require("default.hypr.omarchy"), then add
-- only the bindings you want below:
--   omarchy_default_bindings = false

-- To disable all preinstalled app/webapp bindings, set:
--   omarchy_preinstalled_bindings = false

-- Add a new binding.
-- o.bind("SUPER + SHIFT + R", "SSH", "alacritty -e ssh your-server")

-- Change an existing binding by unbinding it first, then binding the key again.
-- This example changes SUPER+SPACE from the launcher to the Omarchy root menu.
-- hl.unbind("SUPER + SPACE")
-- o.bind("SUPER + SPACE", "Omarchy menu", "omarchy-menu toggle root")

-- Disable a default binding without replacing it.
-- hl.unbind("SUPER + SHIFT + B")

-- Logitech MX Keys examples:
-- o.bind("SUPER + SHIFT + S", nil, "omarchy-capture-screenshot")
-- o.bind("SUPER + H", nil, "voxtype record toggle")
-- o.bind("SUPER + PERIOD", nil, "omarchy-shell shell toggle omarchy.emojis")

-- Dev project picker (~/.local/bin/dev)
o.bind("SUPER + SHIFT + D", "Run dev project", "omarchy-launch-terminal dev")

-- Voice typing: tap to start, tap again to stop and transcribe
o.bind("SUPER + H", "Voice typing toggle", "voxtype record toggle")

-- OmaSwitch: Alt+Tab window switcher (replaces Omarchy's default window cycle)
hl.unbind("ALT + TAB")
hl.unbind("ALT + SHIFT + TAB")
o.bind("ALT + TAB", "OmaSwitch", [[omarchy-shell shell summon piyush.omaswitch '{"mode":"cycle","direction":1}']])
o.bind("ALT + SHIFT + TAB", "OmaSwitch (reverse)", [[omarchy-shell shell summon piyush.omaswitch '{"mode":"cycle","direction":-1}']])

-- Stage: Mission Control-style workspace overview
o.bind("SUPER + GRAVE", "Stage", "omarchy-shell shell toggle zzwong.stage")

-- Dictation keys from before Alt + Space and Right Alt became the defaults.
-- Remove these lines to give the keys back to applications.
if o.dictation_installed and o.dictation_installed() then
  o.bind("SUPER + CTRL + X", "Toggle dictation", "omarchy-dictation toggle")
  o.bind_hold("F9", "Start dictation (push-to-talk)", "omarchy-dictation start", "Stop dictation (push-to-talk)", "omarchy-dictation stop")
end
