#!/usr/bin/env python3
"""Asciify Fluid live ASCII wallpaper as a Wayland background layer.

Loads the real Asciify Fluid page in a single-surface WebKitGTK window and,
when launched under liblayer-shell-preload.so, pins it to the desktop
background layer. Interactive (pointer wake), GPU-rendered, and isolated from
the Omarchy shell so it cannot crash it.

Run via the wrapper: ~/.local/bin/asciify-fluid-wallpaper.sh
"""
import gi

gi.require_version("Gtk", "3.0")
gi.require_version("WebKit2", "4.1")
from gi.repository import Gtk, WebKit2, Gdk  # noqa: E402

URL = "https://asciify.org/docs/backgrounds/fluid"

# Strip the docs chrome so only the live Fluid canvas fills the screen.
INJECT_CSS = """
html, body { margin: 0 !important; padding: 0 !important; overflow: hidden !important;
             background: #080909 !important; }
header, footer, nav, aside, .fluid-background-controls { display: none !important; }
.fluid-background, .fluid-background canvas {
  position: fixed !important; inset: 0 !important;
  width: 100vw !important; height: 100vh !important;
}
"""

INJECT_JS = """
(function () {
  var el = document.querySelector('.fluid-background');
  if (el && document.body) { document.body.replaceChildren(el); }
  window.dispatchEvent(new Event('resize'));
})();
"""


def main():
    win = Gtk.Window()
    win.set_default_size(1920, 1080)

    settings = WebKit2.Settings(
        enable_webgl=True,
        enable_accelerated_2d_canvas=True,
        hardware_acceleration_policy=WebKit2.HardwareAccelerationPolicy.ALWAYS,
    )

    view = WebKit2.WebView(settings=settings)
    view.load_uri(URL)

    user_content = view.get_user_content_manager()
    user_content.add_style_sheet(
        WebKit2.UserStyleSheet(INJECT_CSS,
                               WebKit2.UserContentInjectedFrames.ALL_FRAMES,
                               WebKit2.UserStyleLevel.USER, None, None)
    )

    def on_load_changed(_view, event):
        if event == WebKit2.LoadEvent.FINISHED:
            view.run_javascript(INJECT_JS, None, None, None)

    view.connect("load-changed", on_load_changed)

    win.add(view)
    win.show_all()
    Gtk.main()


if __name__ == "__main__":
    main()
