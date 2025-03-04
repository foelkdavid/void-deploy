#!/bin/bash

mute_status=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | grep -q '\[MUTED\]' && echo " " || echo " ")
echo "$mute_status"

