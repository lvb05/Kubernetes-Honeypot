#!/bin/bash

# deployments/helm-install.sh

set -e

echo "📦 Adding Helm repos..."
helm repo add falcosecurity https://falcosecurity.github.io/charts
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update

echo "🚀 Creating namespace 'honeypot-monitoring'..."
kubectl create namespace honeypot-monitoring || true

# =====================
# 🛡️  Install Falco
# =====================
echo "🔍 Installing Falco..."
helm upgrade --install falco falcosecurity/falco \
  --namespace honeypot-monitoring \
  -f ./falco/falco.yaml

# =====================
# 📊 Install Prometheus
# =====================
echo "📈 Installing Prometheus..."
helm upgrade --install prometheus prometheus-community/prometheus \
  --namespace honeypot-monitoring \
  -f ./prometheus/prometheus-config.yaml

# =====================
# 📂 Install Loki
# =====================
echo "📦 Installing Loki Stack (Loki + Promtail)..."
helm upgrade --install loki grafana/loki-stack \
  --namespace honeypot-monitoring \
  --set promtail.enabled=true \
  --set loki.persistence.enabled=false

# =====================
# 📉 Install Grafana
# =====================
echo "📊 Installing Grafana..."
helm upgrade --install grafana grafana/grafana \
  --namespace honeypot-monitoring \
  --set adminUser=admin \
  --set adminPassword=admin \
  --set service.type=NodePort \
  --set persistence.enabled=false

echo "✅ All components installed successfully!"

echo ""
echo "🔗 Access Grafana via:"
echo "   kubectl port-forward svc/grafana -n honeypot-monitoring 3000:80"
echo "   Then open http://localhost:3000 (user/pass: admin / admin)"
