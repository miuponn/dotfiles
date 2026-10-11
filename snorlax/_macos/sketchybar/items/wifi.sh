#!/bin/bash

sketchybar --add item wifi right \
  --set wifi \
    icon.color=$GROVE_FG \
    icon.padding_left=8 \
    icon.padding_right=8 \
    label.drawing=off \
    update_freq=30 \
    script="$PLUGIN_DIR/wifi.sh" \
    click_script="open 'x-apple.systempreferences:com.apple.Network-Settings.extension'" \
    background.drawing=off \
  --subscribe wifi wifi_change system_woke
