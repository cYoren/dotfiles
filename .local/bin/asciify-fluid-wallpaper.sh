#!/bin/sh
export LD_PRELOAD=/usr/lib/liblayer-shell-preload.so
export LAYER_LAYER=background
export LAYER_ANCHOR=lrbt
export LAYER_NAMESPACE=local-asciify-fluid
export LAYER_KEYBOARD=none
export LAYER_EXCLUSIVE=0
exec chromium --ozone-platform=wayland --no-sandbox --disable-background-mode --disable-features=Translate,OptimizationHints --disable-session-crashed-bubble --no-first-run --user-data-dir=/tmp/asciify-fluid-wp --window-size=1920,1080 --window-position=0,0 --app=https://asciify.org/docs/backgrounds/fluid
