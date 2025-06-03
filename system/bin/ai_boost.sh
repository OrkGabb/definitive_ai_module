#!/system/bin/sh
echo "Boost de performance temporário aplicado."
echo performance > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
sleep 1
echo schedutil > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor

exit 0
