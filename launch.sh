#!/bin/sh
DIR="$(dirname "$0")"
cd "$DIR"

# Use system PLATFORM variable, fallback to tg5040 if not set
[ -z "$PLATFORM" ] && PLATFORM="tg5040"

export LD_LIBRARY_PATH="$DIR:$DIR/bin:$DIR/bin/$PLATFORM:$LD_LIBRARY_PATH:/usr/bin"

# Set CPU frequency for music player (power saving)
echo ondemand > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
if [ "$PLATFORM" = "tg5050" ]; then
	echo 672000 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq
	echo 1680000 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
else
	echo 600000 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq
	echo 1200000 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
fi

# Run the platform-specific binary
"$DIR/bin/$PLATFORM/musicplayer.elf" &> "$LOGS_PATH/music-player.txt"

# Restore default CPU settings on exit
if [ "$PLATFORM" = "tg5050" ]; then
	echo 672000 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq
	echo 2160000 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
else
	echo 600000 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq
	echo 2000000 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
fi
