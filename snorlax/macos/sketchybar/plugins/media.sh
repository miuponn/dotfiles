#!/bin/bash

source "$CONFIG_DIR/colors.sh"

PLAY=$'\xEF\x81\x8B'
PAUSE=$'\xEF\x81\x8C'

if ! command -v nowplaying-cli >/dev/null 2>&1; then
  sketchybar --set "$NAME" drawing=off
  exit 0
fi

TITLE=$(nowplaying-cli get title 2>/dev/null)
ARTIST=$(nowplaying-cli get artist 2>/dev/null)
STATE=$(nowplaying-cli get playbackRate 2>/dev/null)

if [ -z "$TITLE" ] || [ "$TITLE" = "null" ]; then
  sketchybar --set "$NAME" drawing=off
  exit 0
fi

if [ "$STATE" = "0" ]; then
  ICON="$PAUSE"
else
  ICON="$PLAY"
fi

if [ -n "$ARTIST" ] && [ "$ARTIST" != "null" ]; then
  LABEL="$ARTIST - $TITLE"
else
  LABEL="$TITLE"
fi

sketchybar --set "$NAME" \
  drawing=on \
  icon="$ICON" \
  label="$LABEL"
