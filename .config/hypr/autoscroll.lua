-- Windows-style middle-click autoscroll (hypr-autoscroll plugin).
-- Built from source in ~/.local/src/hypr-autoscroll against Hyprland 0.56.2.
-- Rebuild after Hyprland updates:
--   make -C ~/.local/src/hypr-autoscroll clean all
-- Upstream: https://github.com/estebanhiram/hypr-autoscroll

hl.plugin.load(os.getenv("HOME") .. "/.local/src/hypr-autoscroll/build/hypr-autoscroll.so")

hl.config({
  plugin = {
    hypr_autoscroll = {
      enabled = true,
      direct_activation = true,
      sensitivity = 4.0,
    },
  },
})

-- Middle click always autoscrolls. Press SUPER + A to toggle the mode off/on;
-- while off, middle click works normally again (e.g. paste in terminals).
o.bind("SUPER + A", "Toggle middle-button autoscroll", "hyprctl hypr-autoscroll toggle")
