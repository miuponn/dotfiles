#!/bin/bash

sketchybar --add item battery right \
  --set battery \
    icon.color=$GROVE_FG \
    icon.padding_left=8 \
    icon.padding_right=4 \
    label.color=$GROVE_FG \
    label.padding_left=0 \
    label.padding_right=8 \
    update_freq=30 \
    script="$PLUGIN_DIR/battery.sh" \
    background.drawing=off \
  --subscribe battery system_woke power_source_change
