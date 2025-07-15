# 📐 Architecture: Kubernetes Honeypot Logger

This document explains the overall architecture of the Kubernetes-based honeypot logging system designed to detect, log, and visualize attacker behavior in a sandboxed cluster.

---

## 🧱 System Overview

The system consists of the following core components:

### 1. ⚠️ **Honeypot Kubernetes Cluster**
- Simulated with vulnerable containers or misconfigured pods
- Can be run locally using `kind` or `minikube`

### 2. 🛡️ **Falco (Security Detection Engine)**
- Runs as a DaemonSet across all nodes
- Uses syscall-level monitoring to detect suspicious behavior (e.g., shell inside container, file tampering)
- Emits JSON-formatted logs of alerts

### 3. 📦 **Promtail**
- Collects logs from Falco and Kubernetes
- Forwards them to Loki for centralized storage

### 4. 📥 **Loki**
- Lightweight log aggregator by Grafana
- Stores time-series logs efficiently
- Supports powerful queries like filtering by Falco rule or pod

### 5. 📊 **Grafana**
- Visualizes Loki logs and Prometheus metrics
- Dashboards display attacker behavior in real-time
- Configured with pre-loaded dashboards and data sources

---

## 🔄 Data Flow Diagram

```text
          [ Attacker ]
               │
         ┌─────▼─────┐
         │  K8s Pods │ ◄────── (vulnerable / misconfigured)
         └─────┬─────┘
               │
         ┌─────▼─────┐
         │   Falco   │ ◄──── (Syscall monitoring)
         └─────┬─────┘
               │
         ┌─────▼─────┐
         │  Promtail │ ◄──── (Reads Falco logs)
         └─────┬─────┘
               │
         ┌─────▼─────┐
         │   Loki    │ ◄──── (Centralized log store)
         └─────┬─────┘
               │
         ┌─────▼─────┐
         │  Grafana  │ ◄──── (Visualize alerts, queries)
         └───────────┘
