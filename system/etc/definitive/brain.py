
import sys
#!/usr/bin/env python3
# brain.py - Módulo de inferência autônoma DEFINITIVE.AI

import os
import json
import time
import threading
import tflite_runtime.interpreter as tflite

ADJUSTMENTS_PATH = "/system/etc/definitive/adjustments.json"
DEVICES_PATH = "/system/etc/definitive/devices.json"
MODEL_PATH = "/system/etc/definitive/neural_core.tflite"
LOG_PATH = "/data/definitive/logs/brain.log"
STATE_PATH = "/data/definitive/state.json"

def load_json(path):
    with open(path, "r") as f:
        return json.load(f)

def save_json(path, data):
    with open(path, "w") as f:
        json.dump(data, f, indent=2)

def log(message):
    os.makedirs(os.path.dirname(LOG_PATH), exist_ok=True)
    with open(LOG_PATH, "a") as f:
        f.write(f"[{time.ctime()}] {message}\n")

class Brain:
    def __init__(self):
        self.adjustments = load_json(ADJUSTMENTS_PATH)
        self.devices = load_json(DEVICES_PATH)
        self.state = self.load_state()
        self.interpreter = tflite.Interpreter(model_path=MODEL_PATH)
        self.interpreter.allocate_tensors()
        self.input_details = self.interpreter.get_input_details()
        self.output_details = self.interpreter.get_output_details()
        self.device_profile = self.detect_device_profile()

    def load_state(self):
        if os.path.exists(STATE_PATH):
            return load_json(STATE_PATH)
        return {"history": [], "last_mode": None}

    def save_state(self):
        save_json(STATE_PATH, self.state)

    def detect_device_profile(self):
        props = {
            "device": os.popen("getprop ro.product.device").read().strip(),
            "chipset": os.popen("getprop ro.board.platform").read().strip(),
            "architecture": os.popen("getprop ro.product.cpu.abi").read().strip()
        }
        for dev in self.devices:
            if all(dev.get(k) == props.get(k) for k in ["device", "chipset", "architecture"]):
                log(f"Dispositivo detectado: {dev['device']}")
                return dev
        log("Perfil de dispositivo não encontrado. Usando fallback.")
        return None

    def prepare_input(self, mode):
        data = [
            1.0 if mode == k else 0.0
            for k in self.adjustments.keys()
        ]
        return [data]

    def apply_adjustment(self, mode):
        config = self.adjustments.get(mode, {})
        for key, value in config.items():
            os.system(f"echo {value} > /sys/module/definitive_ai/parameters/{key}")
        log(f"Ajuste aplicado para modo '{mode}'")

    def infer_and_apply(self):
        while True:
            for mode in self.adjustments.keys():
                input_data = self.prepare_input(mode)
                self.interpreter.set_tensor(self.input_details[0]['index'], input_data)
                self.interpreter.invoke()
                output_data = self.interpreter.get_tensor(self.output_details[0]['index'])
                score = float(output_data[0][0])
                if score > 0.9:
                    if self.state["last_mode"] != mode:
                        self.state["last_mode"] = mode
                        self.apply_adjustment(mode)
                        self.save_state()
                    break
            time.sleep(15)  # intervalo de reavaliação

if __name__ == "__main__":
    brain = Brain()
    t = threading.Thread(target=brain.infer_and_apply)
    t.daemon = True
    t.start()
    t.join()

# Execução especial se --force-learn for passado como argumento
if __name__ == "__main__":
    if "--force-learn" in sys.argv:
        print("Executando aprendizado forçado...")
        try:
            from data_collector import coletar_dados
            from trainer import treinar_modelo
            dados = coletar_dados()
            modelo = treinar_modelo(dados)
            with open("/data/definitive/state.json", "w") as f:
                import json
                json.dump({"status": "Aprendizado forçado concluído."}, f)
        except Exception as e:
            with open("/data/definitive/state.json", "w") as f:
                import json
                json.dump({"error": f"Erro no aprendizado: {{str(e)}}"}, f)
        sys.exit(0)
