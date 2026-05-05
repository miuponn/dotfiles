#!/bin/bash

source "$CONFIG_DIR/colors.sh"

WIFI_ON=$'\xEF\x87\xAB'
WIFI_OFF=$'\xEF\x9A\xAC'

SSID=$(ipconfig getsummary "$(networksetup -listallhardwareports | awk '/Wi-Fi|AirPort/{getline; print $2}')" 2>/dev/null | awk -F ' SSID : '  '/ SSID : / {print $2; exit}')

if [ -n "$SSID" ]; then
  ICON="$WIFI_ON"
  COLOR=$GROVE_FG
else
  ICON="$WIFI_OFF"
  COLOR=$GROVE_FG_DIM
fi

sketchybar --set "$NAME" \
  icon="$ICON" \
  icon.color="$COLOR"
