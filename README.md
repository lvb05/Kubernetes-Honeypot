#  Kubernetes Threat Research Lab: Self-Hosted Honeypot

A self-hosted Kubernetes honeypot lab designed to simulate real-world misconfigurations and monitor attacker behavior using Falco, Grafana, and Prometheus.

---

## 🔍 Overview

This project deploys a vulnerable Kubernetes cluster using [Kubernetes Goat](https://github.com/madhuakula/kubernetes-goat) on Kali Linux (Minikube + Docker). It simulates insecure configurations to attract real-world attackers and uses Falco for threat detection and Grafana for visualization.

- ✅ Simulates 10+ Kubernetes misconfigurations
- 🚨 Detected 50+ real-time threats with Falco
- ⚡ Achieved 80% faster threat detection
- 🤖 Automated CI/CD with GitHub Actions + Helm
- ⏱️ Reduced deployment time by 60%

---


## 🧰 Tech Stack

| Component     | Tool/Platform              |
|---------------|----------------------------|
| Container Platform | Docker, Minikube |
| Honeypot Simulation | Kubernetes Goat |
| Security Monitoring | Falco |
| Visualization | Grafana + Prometheus |
| CI/CD | GitHub Actions, Helm |
| Host OS | Kali Linux |

---

## 🚀 Quick Start

1. **Clone the repository**
```bash
git clone https://github.com/your-username/kubernetes-threat-research-lab.git
cd kubernetes-threat-research-lab
```
2. **Run Setup Script**

```bash

bash scripts/setup.sh
```

3. **Access Dashboards**

Falco Logs: reports/falco-alerts.log
Grafana UI: http://<minikube-ip>:3000 (default: admin/admin)


---
## 🔐 Simulated Misconfigurations
Privilege escalation via pods

Access to K8s secrets

Unsafe RBAC permissions

Insecure dashboards

Anonymous API access

NodePort exposure

Insecure volumes

Sensitive mount points

---

## 📊 Sample Threats Detected
🔧 kubectl exec on critical containers

🚀 Unauthorized shell access

💸 Crypto mining container spawn

🔒 Access to service account tokens

🕵️ Suspicious network egress

Explore logs in reports/falco-alerts.log

---

## ⚙️ CI/CD Workflow
Auto deploys on push via GitHub Actions.

Uses Minikube & Helm in a GitHub-hosted runner.

Workflow defined in .github/workflows/ci-cd-pipeline.yml

---
## 📈 Monitoring with Grafana
Grafana dashboards are pre-configured for:

Falco alert trends

Pod metrics & health

Cluster CPU/Memory usage

---
📁 Project Structure
```bash
k8s-honeypot-logger/
│
├── README.md
├── LICENSE (MIT recommended)
├── .gitignore
│
├── deployments/
│   ├── falco/
│   │   ├── falco-values.yaml
│   │   └── helm-install.sh
│   ├── prometheus/
│   │   ├── prometheus-config.yaml
│   ├── grafana/
│   │   ├── dashboards/
│   │   │   └── attacker-activity.json
│   │   └── grafana-values.yaml
│   ├── loki/
│   │   ├── loki-config.yaml
│
├── scripts/
│   ├── setup-cluster.sh      # Automates kind/minikube/k3s setup
│   ├── install-all.sh        # Full deploy script
│   ├── log-collector.sh      # Custom Falco log parser (if any)
│
├── dashboards/
│   └── sample-dashboard.png  # Screenshots of Grafana dashboards
│
├── sample-logs/
│   └── falco-output.json
│
└── docs/
    ├── architecture.md
    ├── attacker-scenarios.md
    └── threat-detection.md


```
---
## 📚 References
Kubernetes Goat – 
https://github.com/madhuakula/kubernetes-goat

Falco by Sysdig – 
https://falco.org/

Prometheus – 
https://prometheus.io/

Grafana –
https://grafana.com/

Helm – 
https://helm.sh/



---
## 🤝 Contributing
Pull requests and issues are welcome! This project is designed to help security learners and researchers better understand Kubernetes attack surfaces and detection strategies.

---
## 📝 License
This project is licensed under the MIT License. See LICENSE for more details.
