# infra-reliability-lab


# Cloud Reliability & Observability Lab

## Overview
This project is a **small, production-oriented cloud system** designed to explore **reliability, observability and controlled failure**.

The goal is not to build a feature-rich application, but to **design, operate and improve a simple system under realistic conditions**, similar to what infrastructure and SRE teams face in production.


## What this project demonstrates
- Infrastructure deployed **entirely as code**
- A simple service running behind a load balancer
- Basic but effective **monitoring, logging and alerting**
- **Intentional failure injection** to observe system behavior
- Clear analysis of incidents and improvements (postmortems)


## Architecture 
- AWS VPC with public subnets
- Application Load Balancer
- Auto Scaling Group with Linux EC2 instances
- Simple HTTP service exposing a `/health` endpoint
- Cloud-native monitoring and logs

Infrastructure is provisioned using **Terraform**.


## Reliability & failure scenarios
The system is intentionally stressed using realistic scenarios, such as:
- Service process crash
- High CPU usage
- Memory exhaustion (OOM)
- Disk full situations
- Network latency and packet loss
- Dependency unavailability

Each scenario is documented with:
- Expected behavior
- Observed behavior
- Root cause analysis
- Mitigation and follow-up actions

---

## Scope & limitations
This project intentionally keeps the scope small:
- No complex application logic
- No Kubernetes or advanced orchestration
- No external databases

The focus is on **fundamentals**: visibility, resilience, and operational thinking.

---

## Why this project
This lab reflects how I approach infrastructure:
- Design for failure
- Observe before reacting
- Prefer simple systems that are easy to reason about
- Continuously improve based on real signals

---

## Tech stack
- **Cloud**: AWS
- **Infrastructure as Code**: Terraform
- **Compute**: Linux (EC2)
- **Observability**: metrics, logs, alerts
- **Service**: simple HTTP application



## Status
🚧 Work in progress — this project evolves as new scenarios and improvements are added.

