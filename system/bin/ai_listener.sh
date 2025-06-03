#!/system/bin/sh
while true; do
  inotifyd /system/bin/ai_train.py /data/definitive/state.json
  sleep 10
done

echo 'Script ai_listener.sh executado'
exit 0
