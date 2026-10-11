#!/bin/bash

source "$CONFIG_DIR/colors.sh"
source "$CONFIG_DIR/helpers/icon_map.sh"
source "$CONFIG_DIR/helpers/app_alias.sh"

if [ "$SENDER" = "front_app_switched" ]; then APP="$INFO"; else APP=$(aerospace list-windows --focused --format '%{app-name}' 2>/dev/null); fi
[ -z "$APP" ] && { sketchybar --set "$NAME" label=""; exit 0; }
__app_alias "$APP"; __icon_map "$app_alias"
sketchybar --set "$NAME" label="$icon_result"
