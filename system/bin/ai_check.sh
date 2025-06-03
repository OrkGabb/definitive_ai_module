#!/system/bin/sh

MODULE_PATH="/data/adb/modules/ai_optimizer_neuralcore"
LOG_FILE="/data/ai_optimizer/logs/brain.log"
MODEL_FILE="$MODULE_PATH/neural_core.tflite"
PYTHON_BIN="$MODULE_PATH/bin/python"
BRAIN_SCRIPT="$MODULE_PATH/brain.py"

echo "========================================"
echo "       AI_Optimizer - Status Check      "
echo "========================================"
echo ""

# 1. Checa se o Python leve está disponível
if [ -f "$PYTHON_BIN" ]; then
  echo "[✔] Interpretador Python detectado."
else
  echo "[✖] Python NÃO encontrado em $PYTHON_BIN"
fi

# 2. Verifica se o brain.py existe
if [ -f "$BRAIN_SCRIPT" ]; then
  echo "[✔] brain.py encontrado."
else
  echo "[✖] brain.py ausente!"
fi

# 3. Verifica se o modelo está presente
if [ -f "$MODEL_FILE" ]; then
  echo "[✔] Modelo neural_core.tflite presente."
else
  echo "[✖] Modelo neural_core.tflite ausente!"
fi

# 4. Verifica se o processo brain.py está em execução
if pgrep -f "brain.py" > /dev/null; then
  echo "[✔] Processo brain.py está em execução."
else
  echo "[✖] Processo brain.py NÃO está rodando."
fi

# 5. Mostra as últimas entradas do log, se existir
echo ""
echo "Últimas 10 linhas do log:"
if [ -f "$LOG_FILE" ]; then
  tail -n 10 "$LOG_FILE"
else
  echo "(Log não encontrado em $LOG_FILE)"
fi

echo ""
echo "========================================"

exit 0
