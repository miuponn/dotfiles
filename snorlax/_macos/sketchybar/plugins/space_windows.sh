#!/bin/bash
source "$CONFIG_DIR/colors.sh"

if [ "$SENDER" = "mouse.entered" ]; then
  sketchybar --animate $ANIM_CURVE $ANIM_DURATION --set "$NAME" popup.drawing=on
elif [ "$SENDER" = "mouse.exited" ]; then
  sketchybar --animate $ANIM_CURVE $ANIM_DURATION --set "$NAME" popup.drawing=off
fi
