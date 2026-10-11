#!/bin/bash

source "$CONFIG_DIR/colors.sh"
source "$CONFIG_DIR/helpers/glyphs.sh"

BATT=$(pmset -g batt)
PERCENTAGE=$(echo "$BATT" | grep -Eo '\d+%' | cut -d% -f1)
CHARGING=$(echo "$BATT" | grep 'AC Power')

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
  label="${PERCENTAGE}%"
