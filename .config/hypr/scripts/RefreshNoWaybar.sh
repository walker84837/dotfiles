#!/bin/bash
# Modified version of Refresh but no waybar refresh
# Used by automatic wallpaper change
# Modified inorder to refresh rofi background, Wallust, SwayNC

SCRIPTSDIR=$HOME/.config/hypr/scripts
user_scripts=$HOME/.config/hypr/user_scripts

# Define file_exists function
file_exists() {
    if [ -e "$1" ]; then
        return 0  # File exists
    else
        return 1  # File does not exist
    fi
}

# Kill already running processes
_ps=(rofi)
for _prs in "${_ps[@]}"; do
    if pidof "${_prs}" >/dev/null; then
        pkill "${_prs}"
    fi
done

# quit ags
ags -q

# Wallust refresh
${SCRIPTSDIR}/WallustSwww.sh &

# Relaunching rainbow borders if the script exists
sleep 1
# if file_exists "${user_scripts}/RainbowBorders.sh"; then
#     ${user_scripts}/RainbowBorders.sh &
# fi


exit 0
