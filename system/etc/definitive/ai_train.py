#!/system/bin/env python3
# ai_train.py - Aprendizado contínuo da IA

import os, time, json, random
from datetime import datetime

# Caminhos
LOG_DIR = "/data/definitive/logs"
MEM_DIR = "/data/definitive/memory"
ADJ_FILE = "/system/etc/definitive/adjustments.json"
DEVICE_FILE = "/system/etc/definitive/devices.json"
BOOTLOG_FILE = "/system/etc/definitive/bootlog.json"

os.makedirs(LOG_DIR, exist_ok=True)
os.makedirs(MEM_DIR, exist_ok=True)

def log(msg):
    with open(f"{LOG_DIR}/training.log", "a") as f:
        f.write(f"[{datetime.now().isoformat()}] {msg}\n")

def carga_ok():
    try:
        with open("/sys/class/power_supply/battery/capacity") as f:
            cap = int(f.read().strip())
        with open("/sys/class/power_supply/battery/status") as f:
            status = f.read().strip().lower()
        return cap >= 65 or "charging" in status
    except Exception as e:
        log(f"Erro verificando carga: {e}")
        return False

def uso_baixo():
    try:
        with open("/proc/stat") as f:
            cpu_line = next((l for l in f if l.startswith("cpu ")), None)
        if cpu_line:
            parts = list(map(int, cpu_line.split()[1:]))
            idle = parts[3] + parts[4]
            total = sum(parts)
            usage = 100 - ((idle / total) * 100)
            return usage < 30
    except Exception as e:
        log(f"Erro verificando uso da CPU: {e}")
    return False

def treino_rapido():
    try:
        with open(ADJ_FILE) as f:
            ajustes = json.load(f)
        for item in ajustes.get("patterns", []):
            item["weight"] = round(random.uniform(0.1, 1.0), 2)
        with open(f"{MEM_DIR}/historical_modes.json", "w") as f:
            json.dump(ajustes, f, indent=2)
        log("Treino leve concluído com sucesso.")
    except Exception as e:
        log(f"Erro no treino: {e}")

def main():
    if not carga_ok():
        log("Treino adiado: bateria insuficiente ou não está carregando.")
        return
    if not uso_baixo():
        log("Treino adiado: sistema sob uso.")
        return
    treino_rapido()

if __name__ == "__main__":
    main()
