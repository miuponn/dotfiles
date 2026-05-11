#!/bin/bash

CLOCK=$'\xEF\x80\x97'

sketchybar --add item clock right \
  --set clock \
    icon="$CLOCK" \
    icon.color=$GROVE_FG \
    icon.y_offset=-1 \
    icon.padding_left=10 \
    icon.padding_right=8 \
    label.color=$GROVE_FG \
    label.padding_left=0 \
    label.padding_right=10 \
    update_freq=10 \
    script="$PLUGIN_DIR/clock.sh" \
    background.drawing=off
