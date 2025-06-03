#!/system/bin/sh
# Script para aprendizado forçado da IA DEFINITIVE.AI

MODDIR="/data/adb/modules/definitive_ai"
PYTHON="/data/data/com.termux/files/usr/bin/python"

# Log para debug
echo "[AI_LEARN] Aprendizado forçado iniciado." >> /data/definitive/webui_debug.log

# Executar script Python com modo aprendizado forçado
$PYTHON $MODDIR/brain.py --force-learn >> /data/definitive/webui_debug.log 2>&1

exit 0
