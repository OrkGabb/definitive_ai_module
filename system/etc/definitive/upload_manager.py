#!/data/data/com.termux/files/usr/bin/python

import os
import requests
from base64 import b64encode

def get_directory_size(path):
    total = 0
    for dirpath, _, filenames in os.walk(path):
        for f in filenames:
            fp = os.path.join(dirpath, f)
            if os.path.isfile(fp):
                total += os.path.getsize(fp)
    return total

def upload_to_github(file_path, token, repo, branch="main"):
    if not token:
        print("[UploadManager] GITHUB_TOKEN not configured.")
        return 401, "No token provided"
    headers = {
        "Authorization": f"token {token}",
        "Accept": "application/vnd.github+json"
    }
    filename = os.path.basename(file_path)
    with open(file_path, "rb") as f:
        content = f.read()
    data = {
        "message": f"Upload {filename}",
        "content": b64encode(content).decode(),
        "branch": branch
    }
    url = f"https://api.github.com/repos/{repo}/contents/{filename}"
    r = requests.put(url, headers=headers, json=data)
    return r.status_code, r.text

# Caminho dos dados da IA
data_dir = "/data/ai_shared_cache"
if not os.path.exists(data_dir):
    os.makedirs(data_dir)

# Check e upload
if get_directory_size(data_dir) > 100 * 1024 * 1024:
    zip_file = "/data/ai_cache_upload.zip"
    os.system(f"cd {data_dir} && zip -r {zip_file} .")
    token = os.getenv("GITHUB_TOKEN", "")
    repo = "Gabriel6163/A.I-automatic-Updates"
    if token:
        code, resp = upload_to_github(zip_file, token, repo)
        if code == 201:
            os.system(f"rm -rf {data_dir}/*")
