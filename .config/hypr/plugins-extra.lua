-- Extra Hyprland compositor plugins built from source in ~/.local/src.
-- Rebuild after a Hyprland update:
--   make -C ~/.local/src/hypr-kinetic-scroll clean all
--   PKG_CONFIG_PATH="$HOME/.local/lib/pkgconfig" ~/.local/bin/meson setup --reconfigure ~/.local/src/hyprgrass/build \
--     && ninja -C ~/.local/src/hyprgrass/build
-- kinetic-scroll: https://github.com/savonovv/hypr-kinetic-scroll
-- hyprgrass:      https://github.com/horriblename/hyprgrass
-- hypr-dynamic-cursors was tried and removed (unwanted).

local src = os.getenv("HOME") .. "/.local/src"

hl.plugin.load(src .. "/hypr-kinetic-scroll/hypr-kinetic-scroll.so")
hl.plugin.load(src .. "/hyprgrass/build/src/libhyprgrass.so")

hl.config({
  plugin = {
    kinetic_scroll = {
      enabled = 1,
      decel = 0.92,
      min_velocity = 0.5,
      interval_ms = 16,
      delta_multiplier = 1.25,
      disable_in_browser = 1,
      stop_on_target_change = 1,
    },
    hyprgrass = {
      long_press_delay = 400,
      edge_margin = 10,
      resize_on_border_long_press = true,
    },
  },
})

-- hyprgrass only sees Hyprland "input.touch.*" events, i.e. touchscreens. This
-- laptop has no touchscreen (only an ELAN touchpad), so its gestures never fire
-- here. Touchpad gestures are handled natively in hypr/input.lua via hl.gesture.
-- hyprgrass is left loaded for the day a touchscreen is attached.
