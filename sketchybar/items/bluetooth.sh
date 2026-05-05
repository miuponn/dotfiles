#!/bin/bash

sketchybar --add item bluetooth right \
  --set bluetooth \
    icon.color=$GROVE_FG \
    icon.padding_left=8 \
    icon.padding_right=8 \
    label.drawing=off \
    update_freq=60 \
    script="$PLUGIN_DIR/bluetooth.sh" \
    background.drawing=off \
  --subscribe bluetooth system_woke
