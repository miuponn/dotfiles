#!/bin/bash

source "$CONFIG_DIR/colors.sh"
source "$CONFIG_DIR/helpers/glyphs.sh"

POWER=$(blueutil --power 2>/dev/null)
CONNECTED=$(blueutil --connected 2>/dev/null)

if [ "$POWER" != "1" ]; then
  ICON="$BT_OFF"
  COLOR=$GROVE_FG_DIM
elif [ -n "$CONNECTED" ]; then
  ICON="$BT_ON"
  COLOR=$GROVE_TEAL
else
  ICON="$BT_ON"
  COLOR=$GROVE_FG
fi

sketchybar --set "$NAME" \
  icon="$ICON" \
  icon.color="$COLOR"
