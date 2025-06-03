#!/system/bin/sh
status=$(settings get global zen_mode)
if [ "$status" -eq 1 ]; then
  settings put global zen_mode 0
  echo "Modo DND desativado."
else
  settings put global zen_mode 1
  echo "Modo DND ativado."
fi

exit 0
