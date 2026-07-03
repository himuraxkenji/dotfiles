#!/bin/bash

# GitHub - displays unread notification count

YELLOW=0xfff9e2af
DIM=0xff6c7086

COUNT=$(gh api notifications 2>/dev/null | jq 'length' 2>/dev/null)

if [ -z "$COUNT" ] || [ "$COUNT" = "null" ]; then
  COUNT=0
fi

if [ "$COUNT" -gt 0 ]; then
  sketchybar --set $NAME icon.color=$YELLOW label="$COUNT"
else
  sketchybar --set $NAME icon.color=$DIM label="0"
fi
