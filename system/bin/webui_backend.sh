#!/system/bin/sh

action="$QUERY_STRING"

case "$action" in
    status)
        /system/bin/ai_status.sh
        ;;
    reset)
        /system/bin/ai_reset.sh
        ;;
    debug)
        /system/bin/ai_debug.sh
        ;;
    learn)
        /system/bin/ai_learn.sh
        ;;
    boost)
        /system/bin/ai_boost.sh
        ;;
    dnd)
        /system/bin/ai_dnd_mode.sh
        ;;
    check)
        /system/bin/ai_check.sh
        ;;
    *)
        echo "Comando desconhecido: $action"
        exit 1
        ;;
esac
