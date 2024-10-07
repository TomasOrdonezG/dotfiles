#!/bin/bash
# Source: https://github.com/AymanLyesri/hyprland-conf/tree/master/.config/hypr/hyprpaper

wallpaper_dir="/home/samal/Images/Wallpapers"

monitors=$(hyprctl monitors | grep Monitor | awk '{print $2}') # get monitors
wallpapers=$(ls "$wallpaper_dir" | grep -E '\.png$|\.jpg$')

rand_wallpaper=$(printf "%s\n" "${wallpapers[@]}" | shuf -n 1)
echo "$wallpaper_dir/$rand_wallpaper"

hyprctl hyprpaper unload all
for monitor in $monitors; do
    hyprctl hyprpaper preload "$wallpaper_dir/$rand_wallpaper"
    hyprctl hyprpaper wallpaper "$monitor,$wallpaper_dir/$rand_wallpaper" # Set wallpaper
done
