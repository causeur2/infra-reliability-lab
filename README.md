# infra-reliability-lab



## Overview
This project explores how a **simple cloud system behaves in production-like conditions**, with a focus on **reliability, observability and controlled failure**.

The goal is not application complexity, but understanding how to **design, operate and improve infrastructure** based on real signals.

---

## What this lab covers
- Infrastructure deployed entirely as code
- A simple HTTP service behind a load balancer
- Monitoring, logging and alerting fundamentals
- Intentional failure injection and analysis
- Incident postmortems and continuous improvement

---

## Architecture (high level)
- AWS VPC
- Application Load Balancer
- Auto Scaling Group (EC2)
- Simple HTTP service with `/health`
- Cloud-native metrics and logs

Infrastructure is provisioned using **Terraform**.

---

## Scope
This project intentionally keeps the scope small:
- No complex application logic
- No Kubernetes or advanced orchestration
- No external databases

The focus is on **fundamentals and operational thinking**.

---

🚧 Work in progress


