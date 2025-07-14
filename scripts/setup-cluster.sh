#!/bin/bash


set -e

echo "🔧 Checking dependencies..."

# Check if kind is installed
if ! command -v kind &> /dev/null
then
  echo "❌ kind is not installed. Install it from https://kind.sigs.k8s.io/"
  exit 1
fi

# Check if kubectl is installed
if ! command -v kubectl &> /dev/null
then
  echo "❌ kubectl is not installed. Install it from https://kubernetes.io/docs/tasks/tools/"
  exit 1
fi

echo "✅ Dependencies OK"

# Define cluster name
CLUSTER_NAME="honeypot-cluster"

# Create kind config
cat <<EOF > kind-config.yaml
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
name: $CLUSTER_NAME
nodes:
  - role: control-plane
    extraPortMappings:
      - containerPort: 30000
        hostPort: 30000
        protocol: TCP
      - containerPort: 3100
        hostPort: 3100
        protocol: TCP
EOF

echo "🚀 Creating kind cluster named '$CLUSTER_NAME'..."
kind create cluster --name $CLUSTER_NAME --config kind-config.yaml

echo "📡 Setting current context to '$CLUSTER_NAME'..."
kubectl cluster-info --context kind-$CLUSTER_NAME

echo "🧼 Cleaning up temp config file..."
rm kind-config.yaml

echo "✅ Cluster '$CLUSTER_NAME' is ready!"
