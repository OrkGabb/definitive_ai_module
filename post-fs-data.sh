#!/system/bin/sh

MODDIR=${0%/*}
PYTHON_HOME="/data/data/com.termux/files/usr"
PYTHON_BIN="$PYTHON_HOME/bin/python"
PYTHON_LIB="$PYTHON_HOME/lib"
PYTHON_LIB_VERSION="$PYTHON_LIB/python3.12"

log() {
    echo "[DEFINITIVE.AI][BOOT] $1" >> /dev/kmsg
}

log "Inicializando DEFINITIVE.AI via post-fs-data"

# Permissões essenciais
chmod 755 "$MODDIR"/*.sh "$MODDIR"/ai_*.sh
chmod 644 "$MODDIR/neural_core.tflite"
chmod 755 "$PYTHON_BIN"
chmod -R 755 "$PYTHON_HOME"
chmod -R 755 "$MODDIR/webroot"

# Executar backend WebUI (não em background)
if [ -f "$MODDIR/webroot/cgi-bin/webui_backend.sh" ]; then
    chmod 755 "$MODDIR/webroot/cgi-bin/webui_backend.sh"
fi

# Scripts auxiliares
[ -f "$MODDIR/uninstall.sh" ] && chmod 755 "$MODDIR/uninstall.sh"
[ -f "$MODDIR/ai_check.sh" ] && chmod 755 "$MODDIR/ai_check.sh"

# Consentimento via Volume UP
keycheck() {
    timeout 3 getevent -qlc 1 | grep KEY_VOLUMEUP > /dev/null
    return $?
}

if keycheck; then
    log "Volume UP detectado — CONSENTIMENTO ACEITO"
    echo "1" > /data/ai_user_consented
else
    log "Consentimento negado — abortando IA"
    echo "0" > /data/ai_user_consented
    exit 0
fi

# Ativar modo performance temporário
echo performance > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
sleep 2
echo schedutil > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor

# Ambiente Python embutido
export PYTHONPATH="$PYTHON_LIB_VERSION"
export PYTHONHOME="$PYTHON_HOME"
export LD_LIBRARY_PATH="$PYTHON_LIB"

log "Iniciando brain.py com Python embutido"
$PYTHON_BIN "$MODDIR/brain.py" >> /dev/kmsg 2>&1 &n.py com Python embutido"
$PYTHON_BIN "$MODDIR/brain.py" >> /dev/kmsg 2>&1 &
chmod 0755 /system/bin/ai_*
