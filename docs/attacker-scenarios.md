# 🧪 Simulated Attacker Scenarios

This document outlines attacker behaviors simulated within the Kubernetes honeypot cluster to test Falco rule detections and the logging pipeline.

---

## 🚨 1. Shell Spawned in Container

- **Scenario**: Attacker gains shell access into a running pod using `kubectl exec`, SSH, or a reverse shell.
- **Falco Rule Triggered**: `Shell in container`
- **Example Command**:
```bash
  kubectl exec -it vulnerable-pod -- /bin/bash
```

## 🚨 2. Modifying Sensitive Files
- **Scenario**: Attacker tries to alter system configuration files like /etc/passwd or /etc/shadow.
- **Falco Rule Triggered**: Write below etc

-**Example Command**:

```bash

echo 'malicious' >> /etc/passwd
```
## 🚨 3. Privileged Container Deployment
- **Scenario**: Attacker deploys a pod with securityContext.privileged: true
- **Falco Rule Triggered**: Privileged container started

-**YAML Snippet**:

```yaml

securityContext:
  privileged: true
```
## 🚨 4. Outbound Traffic to Suspicious IP
- **Scenario**: Malware or reverse shell attempts a connection to an external IP.
-**Falco Rule Triggered**: Outbound Connection

-**Example Command**:

```bash

curl http://192.168.1.100
```
## 🚨 5. Accessing Credentials or Secrets
-**Scenario**: Attacker tries to read Kubernetes service account tokens or secret files.
-**Falco Rule Triggered**: Sensitive file read
-**Target Paths**:
-/var/run/secrets/kubernetes.io/

-/etc/shadow
