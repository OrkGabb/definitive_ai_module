# DEFINITIVE.AI 🧠⚡

> **Adaptive On-Device Neural Engine & Linux Kernel Optimizer for Android**  
> *Developed by Gabriel Ribeiro ([OrkGabb](https://github.com/OrkGabb))*

[![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20Magisk%20%7C%20KernelSU-brightgreen.svg)]()
[![ML Framework](https://img.shields.io/badge/Inference-TensorFlow%20Lite%20(tflite--runtime)-orange.svg)]()
[![Architecture](https://img.shields.io/badge/Architecture-ARM64%20%7C%20Linux%20Kernel-blue.svg)]()

---

## 📌 Overview

**DEFINITIVE.AI** is an on-device Edge AI module built to dynamically tune Android Linux kernel parameters based on real-time device workload prediction and thermal telemetry. 

Rather than relying on static thermal profiles or hardcoded CPU governor limits, DEFINITIVE.AI uses a lightweight, custom-trained **TensorFlow Lite neural network (2,500+ training epochs)** running locally on the device via `tflite_runtime` with zero cloud dependency.

---

## 🏗️ Architecture & Core Components

```
                +-----------------------------+
                |    Hardware & OS Telemetry   |
                | (Battery, CPU usage, Temps) |
                +--------------+--------------+
                               |
                               v
+-------------------------------------------------------------+
|                     DEFINITIVE.AI Engine                    |
|                                                             |
|  +-----------------------+     +-------------------------+  |
|  |   Safety Guardrails   |     |  Neural Core (TFLite)   |  |
|  | (Capacity >= 65%,     | --> | (2,500+ Epoch Model,    |  |
|  |  CPU Idle checks)     |     |  tflite_runtime engine) |  |
|  +-----------------------+     +------------+------------+  |
|                                             |               |
|                                             v               |
|                        +--------------------+------------+  |
|                        |     Kernel Tuning Dispatcher    |  |
|                        | (/sys/module/..., CPU Governor, |  |
|                        |  Latency & Efficiency Curves)   |  |
|                        +--------------------+------------+  |
+---------------------------------------------+---------------+
                               |
                               v
                +-----------------------------+
                |    Local WebUI & Control    |
                |  (CGI Dashboard, DND/Boost) |
                +-----------------------------+
```

### 1. On-Device Neural Core (`neural_core.tflite`)
* **Trained Model:** Compact Deep Neural Network model trained over **2,500+ epochs** on workload telemetry curves.
* **Low Overhead:** Runs via standalone `tflite_runtime.interpreter` inside an isolated Python environment, maintaining sub-1% memory overhead.
* **Deterministic Inference:** Continuously evaluates system strain patterns and predicts optimal CPU/governor states with confidence thresholding (`score > 0.9`).

### 2. Autonomous Linux Kernel Tuning (`brain.py`)
* Directly dispatches kernel parameter adjustments via Linux `sysfs` (`/sys/module/definitive_ai/parameters/*`).
* Balances latency, thermal dissipation, and battery efficiency without causing micro-stutters or thermal throttling spikes.
* Detects hardware chipset (`ro.board.platform`) and architecture (`ro.product.cpu.abi`) for device-specific calibration.

### 3. Hardware-Aware Safety Guardrails (`ai_train.py`)
* Enforces battery capacity thresholds (>= 65% or active charging) before executing adaptation routines.
* Monitors `/proc/stat` to ensure model adaptation only occurs when system CPU load is under 30%, guaranteeing that background learning never interferes with foreground performance or gaming sessions.

### 4. Local WebUI & Management Dashboard
* Includes a lightweight web service (`webroot/`) accessible via local browser for real-time mode toggles:
  * **AI Status:** Live monitoring of current inference mode and active kernel parameters.
  * **Gaming / DND Boost:** Low-latency scheduling profile prioritization.
  * **Force Learn & Reset:** Trigger training checkpoints or restore baseline factory governors.

### 5. Secure Integrity Verification (`ai_netupdate.py`)
* Over-The-Air (OTA) parameter updates validated via **SHA-256 checksums** over secure Wi-Fi connections, ensuring model weights and adjustments cannot be corrupted during deployment.

---

## 🛠️ Tech Stack & Prerequisites

* **Runtime:** Android 10+ (Rooted via Magisk or KernelSU/APatch)
* **Architecture:** `aarch64` (ARM64)
* **Dependencies:** Embedded Python 3.12, `tflite_runtime`, NumPy
* **Languages:** Python 3, Linux Shell Scripting (POSIX), C / Kernel Sysfs interfaces

---

## 📄 License & Disclaimer

Developed for educational, benchmarking, and experimental purposes. Kernel parameter modifications require root privileges. Always ensure a functional boot backup before modifying device kernel parameters.
