#!/bin/bash

# Space/Workspace indicator - zero yabai queries, pure sketchybar state

ACCENT=0xffcba6f7
DIM=0xff6c7086
ISLAND_BORDER=0xff45475a

if [ "$SELECTED" = "true" ]; then
  sketchybar --set $NAME \
    label.color=$ACCENT \
    label.font="IosevkaTerm NF:Bold:12.0" \
    background.border_color=$ACCENT
else
  sketchybar --set $NAME \
    label.color=$DIM \
    label.font="IosevkaTerm NF:Regular:12.0" \
    background.border_color=$ISLAND_BORDER
fi
