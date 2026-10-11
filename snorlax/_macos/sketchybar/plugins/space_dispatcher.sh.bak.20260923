#!/usr/bin/env bash
source "$CONFIG_DIR/colors.sh"
source "$CONFIG_DIR/helpers/icon_map.sh"

SPACE_LIST=("vibe" "code" "ref" "design" "social" "vault" "system")
FOCUSED=$(aerospace list-workspaces --focused 2>/dev/null)
WINDOWS=$(aerospace list-windows --all --format "%{workspace}|%{app-name}" 2>/dev/null)

declare -A strip seen
for ws in "${SPACE_LIST[@]}"; do strip[$ws]=""; done

while IFS='|' read -r ws app; do
  [ -z "$ws" ] && continue
  ws="${ws#"${ws%%[![:space:]]*}"}"; ws="${ws%"${ws##*[![:space:]]}"}"
  app="${app#"${app%%[![:space:]]*}"}"; app="${app%"${app##*[![:space:]]}"}"
  key="${ws}::${app}"; [ -n "${seen[$key]}" ] && continue; seen[$key]=1
  __icon_map "$app"; strip[$ws]+=" $icon_result"
done <<< "$WINDOWS"

args=()
for ws in "${SPACE_LIST[@]}"; do
  icon_strip="${strip[$ws]}"
  if [ -n "$icon_strip" ]; then label_draw=on; else label_draw=off; fi
  if [ "$ws" = "$FOCUSED" ]; then bg=$ITEM_HIGHLIGHT_BG; border=$GROVE_TEAL; else bg=$TRANSPARENT; border=$WORKSPACE_BORDER; fi
  args+=(--animate "$ANIM_CURVE" "$ANIM_DURATION" --set "space.$ws" drawing=on label="$icon_strip" label.drawing=$label_draw background.color=$bg background.border_color=$border)
done

sketchybar "${args[@]}"
