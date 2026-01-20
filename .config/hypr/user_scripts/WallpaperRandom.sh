#!/bin/bash

wallpapers="$HOME/Pictures/wallpapers"
scripts="$HOME/.config/hypr/scripts"

focused_monitor=$(hyprctl monitors | awk '/^Monitor/{name=$2} /focused: yes/{print name}')

PICS=($(find ${wallpapers} -type f \( -name "*.jpg" -o -name "*.jpeg" -o -name "*.png" -o -name "*.gif" \)))
RANDOMPICS=${PICS[ $RANDOM % ${#PICS[@]} ]}

# Transition config
FPS=60
TYPE="random"
DURATION=1
BEZIER=".43,1.19,1,.4"
SWWW_PARAMS="--transition-fps $FPS --transition-type $TYPE --transition-duration $DURATION --transition-bezier $BEZIER"

swww query || swww-daemon --format xrgb && swww img -o $focused_monitor ${RANDOMPICS} $SWWW_PARAMS

${scripts}/WallustSwww.sh
sleep 1
${scripts}/Refresh.sh 
