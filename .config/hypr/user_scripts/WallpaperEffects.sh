#!/bin/bash

# Configuration
HOME_DIR="$HOME"
CONFIG_DIR="$HOME_DIR/.config/hypr"
SCRIPTS_DIR="$CONFIG_DIR/scripts"
WALLPAPER_DIR="$CONFIG_DIR/wallpaper_effects"
SWAYNC_DIR="$HOME_DIR/.config/swaync/images"

# Variables
CURRENT_WALLPAPER="$WALLPAPER_DIR/.wallpaper_current"
MODIFIED_WALLPAPER="$WALLPAPER_DIR/.wallpaper_modified"
FOCUSED_MONITOR=$(hyprctl monitors | awk '/^Monitor/{name=$2} /focused: yes/{print name}')

# Swww transition configuration
FPS=60
TRANSITION_TYPE="wipe"
DURATION=2
BEZIER_CURVE=".43,1.19,1,.4"
SWWW_PARAMS="--transition-fps $FPS --transition-type $TRANSITION_TYPE --transition-duration $DURATION"

# ImageMagick effects
declare -A effects
effects=(
  ["Black & White"]="magick $CURRENT_WALLPAPER -colorspace gray -sigmoidal-contrast 10,40% $MODIFIED_WALLPAPER"
  ["Blurred"]="magick $CURRENT_WALLPAPER -blur 0x5 $MODIFIED_WALLPAPER"
  ["Solarize"]="magick $CURRENT_WALLPAPER -solarize 80% $MODIFIED_WALLPAPER"
  ["Sepia Tone"]="magick $CURRENT_WALLPAPER -sepia-tone 65% $MODIFIED_WALLPAPER"
  ["Negate"]="magick $CURRENT_WALLPAPER -negate $MODIFIED_WALLPAPER"
  ["Charcoal"]="magick $CURRENT_WALLPAPER -charcoal 0x5 $MODIFIED_WALLPAPER"
  ["Edge Detect"]="magick $CURRENT_WALLPAPER -edge 1 $MODIFIED_WALLPAPER"
  ["Emboss"]="magick $CURRENT_WALLPAPER -emboss 0x5 $MODIFIED_WALLPAPER"
  ["Sharpen"]="magick $CURRENT_WALLPAPER -sharpen 0x5 $MODIFIED_WALLPAPER"
  ["Oil Paint"]="magick $CURRENT_WALLPAPER -paint 4 $MODIFIED_WALLPAPER"
  ["Vignette"]="magick $CURRENT_WALLPAPER -vignette 0x5 $MODIFIED_WALLPAPER"
  ["Posterize"]="magick $CURRENT_WALLPAPER -posterize 4 $MODIFIED_WALLPAPER"
  ["Polaroid"]="magick $CURRENT_WALLPAPER -polaroid 0 $MODIFIED_WALLPAPER"
  ["No Effects"]="no-effects"
)

# Function to apply no effects
apply_no_effects() {
  swww img -o "$FOCUSED_MONITOR" "$CURRENT_WALLPAPER" $SWWW_PARAMS &
  wait $!
  wallust run "$CURRENT_WALLPAPER" -s &
  wait $!
  "$SCRIPTS_DIR/Refresh.sh"
  notify-send -u low -i "$SWAYNC_DIR/bell.png" "No wallpaper effects"
  cp "$CURRENT_WALLPAPER" "$MODIFIED_WALLPAPER"
}

# Function to apply an effect
apply_effect() {
  local effect="$1"
  notify-send -u normal -i "$SWAYNC_DIR/bell.png" "Applying $effect effects"
  eval "${effects[$effect]}"
  sleep 1
  swww img -o "$FOCUSED_MONITOR" "$MODIFIED_WALLPAPER" $SWWW_PARAMS &
  wait $!
  wallust run "$MODIFIED_WALLPAPER" -s &
  wait $!
  "$SCRIPTS_DIR/Refresh.sh"
  notify-send -u low -i "$SWAYNC_DIR/bell.png" "$effect effects applied"
}

# Main function
main() {
  local options="No Effects"
  for effect in "${!effects[@]}"; do
    if [ "$effect" != "No Effects" ]; then
      options+="\n$effect"
    fi
  done

  local choice=$(echo -e "$options" | rofi -i -dmenu -config ~/.config/rofi/config-wallpaper-effect.rasi)
  if [ -n "$choice" ]; then
    if [ "$choice" == "No Effects" ]; then
      apply_no_effects
    elif [ "${effects[$choice]+exists}" ]; then
      apply_effect "$choice"
    else
      echo "Effects not recognized."
    fi
  fi
}

# Check if rofi is already running
if pidof rofi > /dev/null; then
  pkill rofi
  exit 0
fi

main
