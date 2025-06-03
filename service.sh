#!/system/bin/sh
# service.sh - Inicia o cérebro DEFINITIVE.AI em background

MODDIR=${0%/*}
PYTHON_HOME="$MODDIR/python_ai_env"
PYTHON_BIN="$PYTHON_HOME/python"
PYTHON_LIB="$PYTHON_HOME/Lib"
PYTHON_SITE="$PYTHON_LIB/site-packages"
BRAIN_SCRIPT="$MODDIR/brain.py"
LOG_FILE="/data/definitive/logs/brain_runtime.log"

# Espera até que /data esteja montado
while [ ! -d /data ]; do
    sleep 1
done

# Garante que o diretório de logs exista
mkdir -p /data/definitive/logs

# Exporta variáveis de ambiente para o Python funcionar corretamente
export PYTHONHOME="$PYTHON_HOME"
export PYTHONPATH="$PYTHON_SITE"
export LD_LIBRARY_PATH="$PYTHON_HOME"

# Verifica e executa o brain.py
if [ -f "$PYTHON_BIN" ] && [ -f "$BRAIN_SCRIPT" ]; then
    echo "[DEFINITIVE.AI] Iniciando cérebro em background..." >> "$LOG_FILE"
    "$PYTHON_BIN" "$BRAIN_SCRIPT" >> "$LOG_FILE" 2>&1 &
else
    echo "[DEFINITIVE.AI] ERRO: Python embutido ou brain.py não encontrado!" >> "$LOG_FILE"
fi
