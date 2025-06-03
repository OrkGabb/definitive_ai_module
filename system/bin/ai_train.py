#!/data/definitive/python
#!/data/data/com.termux/files/usr/bin/python
import json, time, os

state_path = "/data/definitive/state.json"
history_path = "/data/definitive/train_history.json"

def log(msg):
    with open("/data/definitive/webui_debug.log", "a") as f:
        f.write("[TRAIN] " + msg + "\n")

log("Iniciando aprendizado forçado...")
time.sleep(2)

if os.path.exists(state_path):
    with open(state_path) as f:
        state = json.load(f)
else:
    state = {}

state["last_mode"] = "otimizado"
state["updated_at"] = time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime())

with open(state_path, "w") as f:
    json.dump(state, f)

log("Estado atualizado para 'otimizado'.")

if os.path.exists(history_path):
    with open(history_path) as f:
        history = json.load(f)
else:
    history = {"sessions": [], "last_forced_train": None}

history["sessions"].append({"ts": time.time(), "result": "success"})
history["last_forced_train"] = time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime())

with open(history_path, "w") as f:
    json.dump(history, f)

log("Histórico de treino atualizado.")

echo 'Script ai_train.py executado'
exit 0
