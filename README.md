

# infra-reliability-lab

## Overview

This project simulates a **production-like AWS environment** to explore infrastructure reliability, observability, and controlled failure scenarios.

Rather than focusing on application complexity, the objective is to design, operate, and improve cloud infrastructure based on real operational signals and measurable system behavior.

---

## Reliability Objectives

* Infrastructure fully provisioned as code using **Terraform**
* Load-balanced HTTP service with health checks
* Auto Scaling behavior validation under failure
* Monitoring, logging, and alert analysis
* Controlled failure injection and incident documentation
* Postmortem analysis and continuous improvement practices

---

## Architecture

* AWS VPC
* Application Load Balancer (ALB)
* Auto Scaling Group (EC2)
* Lightweight HTTP service with `/health` endpoint
* Cloud-native metrics and centralized logging

All infrastructure components are provisioned and managed via Terraform.

---

## Operational Focus

This project intentionally keeps the system simple in order to concentrate on:

* Observability-driven decision making
* Resource saturation detection
* Failure recovery validation
* Resilience over feature complexity

No Kubernetes, complex orchestration, or external databases are included by design.

---

## Status

🚧 Work in progress — actively evolving with new reliability experiments and failure scenarios.





