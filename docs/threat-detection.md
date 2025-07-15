
---


# 🔎 Threat Detection Logic


This document explains how Falco detects threats and how its rules are used within this honeypot setup.

---

## 🧠 How Falco Works

Falco uses:
- **Syscall hooks (via eBPF or kernel module)**
- **Kubernetes metadata enrichment**
- **Custom rules** to detect malicious or suspicious behavior

When a rule condition matches, Falco generates an event log with fields like:
- Rule name
- Priority (Critical, Warning, Notice)
- Process, command line, container, user

---

## 📜 Example Rule: Shell in Container

```yaml
- rule: Shell in container
  desc: A shell was spawned inside a container
  condition: container and shell_procs and not runc_proc
  output: "Shell spawned in container (user=%user.name command=%proc.name parent=%proc.pname)"
  priority: CRITICAL
  tags: [container, shell, mitre_execution]
