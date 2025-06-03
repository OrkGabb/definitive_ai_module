#!/system/bin/sh

MODULE_PATH="/data/adb/modules/DEFINITIVE.AI"
LOG_FILE="/data/ai_optimizer/logs/brain.log"
MODEL_FILE="$MODULE_PATH/neural_core.tflite"
PYTHON_BIN="$MODULE_PATH/python_termux/data/data/com.termux/files/usr/bin/python"
BRAIN_SCRIPT="$MODULE_PATH/brain.py"

echo "========================================"
echo "       DEFINITIVE.AI - Status Check     "
echo "========================================"
echo ""

if [ -f "$PYTHON_BIN" ]; then
  echo "[✔] Python detectado."
else
  echo "[✖] Python NÃO encontrado em $PYTHON_BIN"
fi

if [ -f "$BRAIN_SCRIPT" ]; then
  echo "[✔] brain.py encontrado."
else
  echo "[✖] brain.py ausente!"
fi

if [ -f "$MODEL_FILE" ]; then
  echo "[✔] Modelo neural_core.tflite presente."
else
  echo "[✖] Modelo neural_core.tflite ausente!"
fi

if pgrep -f "brain.py" > /dev/null; then
  echo "[✔] Processo brain.py em execução."
else
  echo "[✖] Processo brain.py NÃO está rodando."
fi

echo ""
echo "Últimas 10 linhas do log:"
if [ -f "$LOG_FILE" ]; then
  tail -n 10 "$LOG_FILE"
else
  echo "(Log não encontrado em $LOG_FILE)"
fi

echo "========================================"
