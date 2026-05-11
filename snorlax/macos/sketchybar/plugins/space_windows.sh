#!/bin/bash

source "$CONFIG_DIR/colors.sh"
source "$CONFIG_DIR/helpers/icon_map.sh"

if [ "$SENDER" = "mouse.entered" ]; then
  sketchybar --animate $ANIM_CURVE $ANIM_DURATION \
    --set "$NAME" popup.drawing=on
  exit 0
fi

if [ "$SENDER" = "mouse.exited" ]; then
  sketchybar --animate $ANIM_CURVE $ANIM_DURATION \
    --set "$NAME" popup.drawing=off
  exit 0
fi

WS="${NAME#space.}"
FOCUSED=$(aerospace list-workspaces --focused 2>/dev/null)

apps=$(aerospace list-windows --workspace "$WS" 2>/dev/null | awk -F'|' '{gsub(/^ *| *$/, "", $2); if (!seen[$2]++) print $2}')

icon_strip=""
has_apps=0
if [ -n "$apps" ]; then
  has_apps=1
  while IFS= read -r app; do
    [ -z "$app" ] && continue
    __icon_map "$app"
    icon_strip+=" $icon_result"
  done <<< "$apps"
fi

if [ "$WS" = "$FOCUSED" ]; then
  sketchybar --animate $ANIM_CURVE $ANIM_DURATION \
    --set "$NAME" \
      drawing=on \
      label="$icon_strip" \
      label.drawing=$([ "$has_apps" = "1" ] && echo on || echo off) \
      background.color=$ITEM_HIGHLIGHT_BG \
      background.border_color=$GROVE_TEAL
else
  sketchybar --animate $ANIM_CURVE $ANIM_DURATION \
    --set "$NAME" \
      drawing=on \
      label="$icon_strip" \
      label.drawing=$([ "$has_apps" = "1" ] && echo on || echo off) \
      background.color=$TRANSPARENT \
      background.border_color=$WORKSPACE_BORDER
fi
