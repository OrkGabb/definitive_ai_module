#!/system/bin/sh

# Configurar headers JSON
echo "Content-type: application/json"
echo ""

# Variáveis globais
LOG="/data/definitive/webui_debug.log"
COMMAND=""
output=""

# Criar diretório de logs
mkdir -p "$(dirname "$LOG")" 2>/dev/null

# Extrair comando (versão corrigida sem caracteres especiais)
if [ -n "$QUERY_STRING" ]; then
    COMMAND=$(echo "$QUERY_STRING" | sed -n 's/.*cmd=[^&]*.*/\1/p')
else
    COMMAND=$(echo "$1" | sed -n 's/^cmd=.*$/\1/p')
fi

# Registrar comando recebido
echo "[WEBUI] Comando recebido: $COMMAND" >> "$LOG" 2>/dev/null

# Processar comandos
case "$COMMAND" in
    ai_status)
        if [ -f "/data/adb/modules/definitive_ai/data/definitive/state.json" ]; then
            current_mode=$(grep '"last_mode"' /data/adb/modules/definitive_ai/data/definitive/state.json | cut -d'"' -f4)
            device_model=$(getprop ro.product.device)
            output="Modo atual: ${current_mode:-desconhecido}\nDispositivo: ${device_model:-n/a}"
        else
            output="Estado não disponível"
        fi
        ;;

    ai_debug)
        if [ -f "/data/definitive/logs/brain.log" ]; then
            output=$(head -c 2048 /data/definitive/logs/brain.log | sed ':a;N;$!ba;s/\n/\\n/g')
        else
            output="Nenhum log encontrado"
        fi
        ;;

    ai_force_learn)
        /data/adb/modules/definitive_ai/system/bin/ai_force_learn > /dev/null 2>&1
        if [ $? -eq 0 ]; then
            output="Aprendizado forçado executado com sucesso"
        else
            output="Erro ao executar aprendizado forçado"
        fi
        ;;

    ai_reset)
        rm -f /data/adb/modules/definitive_ai/data/definitive/state.json 2>/dev/null
        output="Estado resetado"
        ;;

    ai_dnd_toggle)
        current_dnd=$(settings get global zen_mode 2>/dev/null)
        if [ "$current_dnd" = "0" ]; then
            settings put global zen_mode 1
            output="Modo Não Perturbe ativado"
        else
            settings put global zen_mode 0
            output="Modo Não Perturbe desativado"
        fi
        ;;

    *)
        output="Comando inválido: ${COMMAND:-nenhum}"
        ;;
esac

# Gerar resposta JSON segura
printf '{"status":"%s"}\n' "$(echo "$output" | sed 's/"/\\"/g')"