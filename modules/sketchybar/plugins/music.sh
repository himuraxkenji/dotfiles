#!/bin/bash

# Music - single osascript call instead of 3 separate ones

GREEN=0xffa6e3a1
RED=0xfff38ba8
DIM=0xff6c7086

if pgrep -x "Spotify" > /dev/null 2>&1; then
  INFO=$(osascript -e 'tell application "Spotify" to if player state is playing then return artist of current track & " - " & name of current track' 2>/dev/null)
  if [ -n "$INFO" ]; then
    sketchybar --set $NAME icon.color=$GREEN label="$INFO"
    exit 0
  fi
fi

if pgrep -x "Music" > /dev/null 2>&1; then
  INFO=$(osascript -e 'tell application "Music" to if player state is playing then return artist of current track & " - " & name of current track' 2>/dev/null)
  if [ -n "$INFO" ]; then
    sketchybar --set $NAME icon.color=$RED label="$INFO"
    exit 0
  fi
fi

sketchybar --set $NAME icon.color=$DIM label="--"
