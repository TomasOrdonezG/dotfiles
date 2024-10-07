#!/bin/bash

# Set your desired gaps and border_radius variables
gaps=4  # Change this to whatever value you want
border_radius=10  # Set your desired border radius for both Hyprland and Waybar

# Paths to configuration files
hyprland_conf="$HOME/.config/hypr/hyprland.conf"
waybar_conf="$HOME/.config/waybar/config.jsonc"
waybar_style="$HOME/.config/waybar/style.css"

# Edit hyprland.conf
if [[ -f "$hyprland_conf" ]]; then
    # Use sed to find the "general" block and replace gaps_out and gaps_in inside it
    sed -i "/general {/,/}/ s/gaps_out *= *[0-9]*/gaps_out = $gaps/" "$hyprland_conf"
    sed -i "/general {/,/}/ s/gaps_in *= *[0-9]*/gaps_in = $(($gaps / 2))/" "$hyprland_conf"

    # Update rounding value in the "decoration" block
    sed -i "/decoration {/,/}/ s/rounding *= *[0-9]*/rounding = $border_radius/" "$hyprland_conf"
    
    echo "Updated $hyprland_conf with gaps_out = $gaps, gaps_in = $(($gaps / 2)), and rounding = $border_radius"
else
    echo "Error: $hyprland_conf not found."
fi

# Edit waybar/config.jsonc
if [[ -f "$waybar_conf" ]]; then
    sed -i "s/\"margin-left\":.*/\"margin-left\": $gaps,/" "$waybar_conf"
    sed -i "s/\"margin-right\":.*/\"margin-right\": $gaps,/" "$waybar_conf"
    sed -i "s/\"margin-top\":.*/\"margin-top\": $gaps,/" "$waybar_conf"
    echo "Updated $waybar_conf with margins set to $gaps"
else
    echo "Error: $waybar_conf not found."
fi

# Edit waybar/style.css to set border-radius
if [[ -f "$waybar_style" ]]; then
    sed -i "s/border-radius: *[0-9]*px;/border-radius: ${border_radius}px;/" "$waybar_style"
    echo "Updated $waybar_style with border-radius = ${border_radius}px"
else
    echo "Error: $waybar_style not found."
fi

# Kill and restart Waybar
pkill waybar
if [[ $? -eq 0 ]]; then
    echo "Waybar killed successfully."
else
    echo "Waybar was not running or could not be killed."
fi

# Ensure Waybar runs under Wayland by exporting the WAYLAND_DISPLAY and launching it
waybar &
echo "Waybar restarted."
