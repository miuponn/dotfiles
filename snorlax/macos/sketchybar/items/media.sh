#!/bin/bash

MUSIC=$'\xEF\x80\x81'
SPOTIFY=$'\xEF\x86\xBC'

sketchybar --add item media left \
  --set media \
    icon="$MUSIC" \
    icon.font="JetBrainsMono Nerd Font:Bold:14.0" \
    icon.color=$GROVE_LAVENDER \
    icon.padding_left=10 \
    icon.padding_right=6 \
    label.color=$GROVE_FG \
    label.padding_left=0 \
    label.padding_right=10 \
    label.max_chars=35 \
    scroll_texts=on \
    drawing=off \
    background.drawing=off \
    popup.background.color=$BAR_BG \
    popup.background.corner_radius=10 \
    popup.background.border_width=1 \
    popup.background.border_color=$WORKSPACE_BORDER \
    popup.blur_radius=20 \
    script="$PLUGIN_DIR/media.sh" \
    click_script="sketchybar --animate $ANIM_CURVE $ANIM_DURATION --set media popup.drawing=toggle" \
    update_freq=5 \
  --subscribe media media_change system_woke

sketchybar --add item media.spotify popup.media \
  --set media.spotify \
    icon="$SPOTIFY" \
    icon.font="JetBrainsMono Nerd Font:Bold:14.0" \
    icon.color=$GROVE_MINT \
    icon.padding_left=12 \
    icon.padding_right=8 \
    label="Open Spotify" \
    label.font="$FONT_LABEL" \
    label.color=$GROVE_FG \
    label.padding_left=0 \
    label.padding_right=12 \
    background.drawing=off \
    click_script="open -a Spotify; sketchybar --set media popup.drawing=off"
