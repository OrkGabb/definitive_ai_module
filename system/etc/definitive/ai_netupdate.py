#!/system/bin/python3
# -*- coding: utf-8 -*-
# DEFINITIVE.AI — Atualização remota de inteligência e dados
import os
import hashlib
import urllib.request
import socket
import json
from datetime import datetime

BASE_DIR = "/system/etc/definitive"
UPDATE_LOG = os.path.join(BASE_DIR, "logs", "ai_netupdate.log")
UPDATE_SOURCES = [
    "https://your-secure-server.com/ai/updates.json"
]

def log(msg):
    timestamp = datetime.now().strftime("[%Y-%m-%d %H:%M:%S]")
    with open(UPDATE_LOG, "a") as f:
        f.write(f"{timestamp} {msg}\n")
    print(f"{timestamp} {msg}")

def is_on_wifi():
    try:
        with os.popen("ip route get 1.1.1.1") as route:
            return 'wlan0' in route.read()
    except Exception:
        return False

def internet_available():
    try:
        socket.setdefaulttimeout(5)
        socket.socket(socket.AF_INET, socket.SOCK_STREAM).connect(("8.8.8.8", 53))
        return True
    except Exception:
        return False

def download_file(url, dest, expected_sha256):
    try:
        urllib.request.urlretrieve(url, dest)
        sha256_hash = hashlib.sha256()
        with open(dest, "rb") as f:
            for byte_block in iter(lambda: f.read(4096), b""):
                sha256_hash.update(byte_block)
        if sha256_hash.hexdigest() == expected_sha256:
            log(f"✅ {os.path.basename(dest)} atualizado com sucesso.")
            return True
        else:
            log(f"⚠️ Checksum incorreto para {os.path.basename(dest)}.")
            os.remove(dest)
            return False
    except Exception as e:
        log(f"❌ Falha ao baixar {url}: {str(e)}")
        return False

def main():
    log("📡 Iniciando busca por atualizações...")
    if not is_on_wifi():
        log("❌ Wi-Fi não detectado. Atualização cancelada.")
        return
    if not internet_available():
        log("❌ Sem acesso à internet. Abortando.")
        return

    for source_url in UPDATE_SOURCES:
        try:
            response = urllib.request.urlopen(source_url)
            data = json.load(response)
            for item in data.get("files", []):
                filename = item.get("name")
                url = item.get("url")
                sha256 = item.get("sha256")
                target_path = os.path.join(BASE_DIR, filename)
                log(f"⬇️ Atualizando {filename}...")
                download_file(url, target_path, sha256)
        except Exception as e:
            log(f"⚠️ Falha ao acessar {source_url}: {str(e)}")
            continue

    log("🔁 Verificação finalizada.")

if __name__ == "__main__":
    main()
