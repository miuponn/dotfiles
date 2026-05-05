#!/bin/bash

APPLE=$'\xEF\x85\xB9'

sketchybar --add item apple left \
  --set apple \
    icon="$APPLE" \
    icon.font="$FONT_APPLE" \
    icon.color=$GROVE_FG \
    icon.padding_left=10 \
    icon.padding_right=10 \
    label.drawing=off \
    background.drawing=off
