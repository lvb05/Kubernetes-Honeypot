#!/bin/bash

# Description:
# Stream Falco logs in real-time, extract key fields, and store as JSON
# Dependencies: jq

set -e

NAMESPACE="honeypot-monitoring"
OUTPUT_FILE="../sample-logs/falco-output.json"

echo "📡 Looking for Falco pod..."
FALCO_POD=$(kubectl get pods -n $NAMESPACE -l app.kubernetes.io/name=falco -o jsonpath="{.items[0].metadata.name}")

if [[ -z "$FALCO_POD" ]]; then
  echo "❌ Falco pod not found in namespace $NAMESPACE"
  exit 1
fi

echo "✅ Found Falco pod: $FALCO_POD"
echo "📝 Writing parsed logs to: $OUTPUT_FILE"

kubectl logs -n $NAMESPACE -f "$FALCO_POD" | \
  grep '{' | \
  jq -c '{
    time: .time,
    rule: .rule,
    priority: .priority,
    output: .output,
    container_id: .output_fields["container.id"] // "",
    process_name: .output_fields["proc.name"] // "",
    user: .output_fields["user.name"] // "",
    cmdline: .output_fields["proc.cmdline"] // ""
  }' >> "$OUTPUT_FILE"
