#!/system/bin/sh

MODDIR=/data/adb/modules/DEFINITIVE.AI

# Remove arquivos adicionais instalados
rm -rf $MODDIR/python
rm -rf $MODDIR/neural_core.tflite
rm -rf $MODDIR/brain.py
rm -rf $MODDIR/adjustments.json
rm -rf $MODDIR/devices.json
rm -rf $MODDIR/gamelist.json
rm -rf $MODDIR/webui
rm -rf $MODDIR/scripts
rm -rf $MODDIR/logs
rm -rf $MODDIR/service.sh
rm -rf $MODDIR/post-fs-data.sh

# Remove link do WebUI caso tenha sido criado
rm -f /data/local/tmp/definitive_ai_web

# Remove o módulo por completo se for o único conteúdo
rmdir $MODDIR 2>/dev/null

echo "[DEFINITIVE.AI] Módulo e arquivos removidos com sucesso."
