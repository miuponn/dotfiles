#!/bin/bash

SPACE_LIST=("vibe" "code" "ref" "design" "social" "vault" "system")

for i in "${!SPACE_LIST[@]}"; do
  sid="${SPACE_LIST[i]}"
  num="$((i+1))"

  sketchybar --add item space.$sid left \
    --set space.$sid \
      background.color=$TRANSPARENT \
      background.corner_radius=12 \
      background.height=30 \
      background.padding_left=3 \
      background.padding_right=4 \
      background.drawing=on \
      background.border_width=1 \
      background.border_color=$WORKSPACE_BORDER \
      icon="$num" \
      icon.font="$FONT_WS_BADGE" \
      icon.color=$GROVE_FG \
      icon.padding_left=12 \
      icon.padding_right=12 \
      label.font="$FONT_APP_ICONS" \
      label.color=$GROVE_FG_SOFT \
      label.padding_left=0 \
      label.padding_right=12 \
      label.y_offset=-2 \
      label.drawing=off \
      popup.background.color=$BAR_BG \
      popup.background.corner_radius=10 \
      popup.background.border_width=1 \
      popup.background.border_color=$WORKSPACE_BORDER \
      popup.blur_radius=20 \
      click_script="aerospace workspace $sid" \
      script="$PLUGIN_DIR/space_windows.sh" \
    --subscribe space.$sid \
      aerospace_workspace_change \
      front_app_switched \
      window_detected \
      system_woke \
      mouse.entered \
      mouse.exited

  sketchybar --add item space.$sid.hint popup.space.$sid \
    --set space.$sid.hint \
      icon.drawing=off \
      label="$sid  ·  alt+$num" \
      label.font="$FONT_LABEL" \
      label.color=$GROVE_FG \
      label.padding_left=10 \
      label.padding_right=10 \
      background.drawing=off \
      background.height=24
done
