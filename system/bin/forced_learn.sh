#!/system/bin/sh
# Aprendizado forçado via DEFINITIVE.AI
log -p i -t DEFINITIVE.AI "Iniciando aprendizado forçado..."
cd /data/definitive || exit 1

# Executa brain.py com flag especial de aprendizado
/data/definitive/python/bin/python3 /data/definitive/brain.py --force-learn >> /data/definitive/ai_forced_learn.log 2>&1

log -p i -t DEFINITIVE.AI "Aprendizado forçado concluído."
exit 0
