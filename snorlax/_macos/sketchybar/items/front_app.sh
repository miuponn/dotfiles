#!/bin/bash

sketchybar --add item front_app left \
  --set front_app \
    icon.drawing=off \
    label.font="$FONT_APP_ICONS" \
    label.color=$GROVE_TEAL_DIM \
    label.padding_left=10 \
    label.padding_right=10 \
    background.drawing=off \
    script="$PLUGIN_DIR/front_app.sh" \
  --subscribe front_app front_app_switched
