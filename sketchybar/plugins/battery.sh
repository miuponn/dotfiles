#!/bin/bash

source "$CONFIG_DIR/colors.sh"

BATT_FULL=$'\xEF\x89\x80'
BATT_3Q=$'\xEF\x89\x81'
BATT_HALF=$'\xEF\x89\x82'
BATT_1Q=$'\xEF\x89\x83'
BATT_EMPTY=$'\xEF\x89\x84'
BATT_CHARGE=$'\xEF\x83\xA7'

PERCENTAGE=$(pmset -g batt | grep -Eo '\d+%' | cut -d% -f1)
CHARGING=$(pmset -g batt | grep 'AC Power')

if [ -z "$PERCENTAGE" ]; then
  sketchybar --set "$NAME" drawing=off
  exit 0
fi

if [ -n "$CHARGING" ]; then
  ICON="$BATT_CHARGE"
else
  case "$PERCENTAGE" in
    9[0-9]|100) ICON="$BATT_FULL" ;;
    [6-8][0-9]) ICON="$BATT_3Q" ;;
    [3-5][0-9]) ICON="$BATT_HALF" ;;
    [1-2][0-9]) ICON="$BATT_1Q" ;;
    *)          ICON="$BATT_EMPTY" ;;
  esac
fi

sketchybar --set "$NAME" \
  drawing=on \
  icon="$ICON" \
  icon.color=$GROVE_FG \
  label="${PERCENTAGE}%"
