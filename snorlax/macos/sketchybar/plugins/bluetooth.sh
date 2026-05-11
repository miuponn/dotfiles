#!/bin/bash

source "$CONFIG_DIR/colors.sh"

BT_ON=$'\xEF\x8A\x93'
BT_OFF=$'\xEF\x8A\x94'

POWER=$(defaults read /Library/Preferences/com.apple.Bluetooth.plist ControllerPowerState 2>/dev/null)
CONNECTED=$(system_profiler SPBluetoothDataType 2>/dev/null | awk '/Connected: Yes/{print NR; exit}')

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
