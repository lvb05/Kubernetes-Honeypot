#!/bin/bash

set -e

echo "🚀 Starting full honeypot monitoring stack installation..."

# Ensure kubectl context is correct
echo "📡 Current Kubernetes context:"
kubectl config current-context

# Create namespace (if not exists)
echo "📦 Creating namespace 'honeypot-monitoring'..."
kubectl create namespace honeypot-monitoring || true

# ===========================
# 🛡️  Install Falco
# ===========================
echo "🛡️  Installing Falco..."
helm repo add falcosecurity https://falcosecurity.github.io/charts
helm repo update
helm upgrade --install falco falcosecurity/falco \
  --namespace honeypot-monitoring \
  -f ../deployments/falco/falco-values.yaml

# Apply custom Falco rules if present
if [[ -f ../deployments/falco/falco_rules.local.yaml ]]; then
  echo "📜 Applying custom Falco rules..."
  kubectl create configmap falco-rules-local \
    --from-file=../deployments/falco/falco_rules.local.yaml \
    --namespace honeypot-monitoring \
    --dry-run=client -o yaml | kubectl apply -f -
fi

# ===========================
# 📈 Install Prometheus
# ===========================
echo "📈 Installing Prometheus..."
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
helm upgrade --install prometheus prometheus-community/prometheus \
  --namespace honeypot-monitoring \
  -f ../deployments/prometheus/prometheus-config.yaml

# ===========================
# 📦 Install Loki Stack
# ===========================
echo "📦 Installing Loki Stack (Loki + Promtail)..."
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update
helm upgrade --install loki grafana/loki-stack \
  --namespace honeypot-monitoring \
  -f ../deployments/loki/loki-config.yaml \
  --set promtail.enabled=true

# ===========================
# 📊 Install Grafana
# ===========================
echo "📊 Installing Grafana..."
helm upgrade --install grafana grafana/grafana \
  --namespace honeypot-monitoring \
  -f ../deployments/grafana/grafana-values.yaml

# ===========================
# 🧭 Load Dashboards
# ===========================
echo "📂 Creating ConfigMap for Grafana dashboard..."
kubectl create configmap grafana-dashboards \
  --from-file=attacker-activity.json=../deployments/grafana/dashboards/attacker-activity.json \
  --namespace honeypot-monitoring \
  --label grafana_dashboard=true \
  --dry-run=client -o yaml | kubectl apply -f -

echo ""
echo "✅ All components deployed in 'honeypot-monitoring' namespace!"
echo "📍 Access Grafana: http://localhost:3000 (admin / admin)"
echo "💡 Port-forward: kubectl port-forward svc/grafana -n honeypot-monitoring 3000:80"
