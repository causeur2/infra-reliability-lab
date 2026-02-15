

# infra-reliability-lab

Voici un README propre, professionnel, orienté SRE / production mindset.

Tu peux l’utiliser tel quel (en adaptant si besoin les détails).


# Infra Reliability Lab

Production-oriented infrastructure lab focused on reliability, observability and controlled scaling.

This project simulates a small but realistic cloud architecture designed and operated with SRE principles in mind. The goal is not application complexity, but infrastructure behavior under load, failure scenarios and operational constraints.


## Architecture Overview

The infrastructure is deployed entirely using Terraform and runs on AWS (eu-west-3).

### Core components

* Custom VPC with public subnets (multi-AZ)
* Application Load Balancer (ALB)
* Target Group with health checks
* Auto Scaling Group (EC2)
* Dockerized Python service
* Amazon ECR (container registry)
* CloudWatch dashboards and alarms
* Remote Terraform backend (S3 + DynamoDB locking)

The system is designed to be:

* Horizontally scalable
* Observable
* Fault-tolerant
* Infrastructure-as-Code driven



## Application Layer

The application is a minimal HTTP service built with Flask and containerized with Docker.

### Features

* Structured JSON logging
* Request ID propagation
* Latency measurement per request
* `/health` endpoint for load balancer health checks
* `/metrics` endpoint for uptime tracking
* Failure injection:

  * Artificial delay
  * CPU stress simulation

The application is intentionally simple. The focus is on infrastructure behavior, not business logic.


## Container & Deployment

* Docker image built locally (ARM64 build adjusted for AMD64 EC2 runtime)
* Image pushed to Amazon ECR
* EC2 instances pull image at boot via user data script
* Service exposed on port 8080
* Traffic routed through ALB


## Auto Scaling Strategy

The Auto Scaling Group is configured with:

* Min capacity: 1
* Max capacity: 2
* Target Tracking Scaling policy
* CPU target: 55%
* Estimated instance warmup: 120 seconds

Scaling decisions are based on:

ASGAverageCPUUtilization

This ensures:

* Controlled horizontal scaling
* Avoidance of aggressive scale-out
* Stability during instance warmup
* Reduced scaling “yo-yo” effects


## Observability & Monitoring

A CloudWatch dashboard provides visibility into:

* ASG average CPU utilization
* In-service instance count
* ALB target response time
* ALB request count
* HTTP 5XX errors (ELB + Target)

Alarms are configured for:

* High ASG CPU
* Target 5XX errors
* SLO violation (error threshold breach)

This allows:

* Early detection of saturation
* Visibility into user-facing latency
* Error tracking at the load balancer layer
* Service reliability monitoring


## Service Level Objective (SLO)

This lab defines a reliability objective to simulate production standards.

### SLO

99% availability over a rolling window.

### Error Budget

1% allowable failure rate.

If the error budget is exceeded:

* Deployments should be paused
* Root cause analysis is required
* Reliability improvements take priority

This introduces production-grade reliability thinking beyond simple uptime monitoring.


## Terraform Backend (Production Practice)

Terraform state is stored remotely:

* S3 bucket (versioned and encrypted)
* DynamoDB table for state locking

This ensures:

* Safe collaboration
* Protection against state corruption
* Controlled concurrent operations
* Production-aligned infrastructure management


## Load Testing & Failure Simulation

A custom load script simulates traffic and CPU stress:

* Generates concurrent requests via ALB
* Triggers scaling events
* Validates ASG behavior
* Tests health checks and instance replacement

This allows controlled experimentation of:

* Scale-out under CPU pressure
* ALB health check failures
* Instance termination and replacement
* Response time degradation


## Reliability Experiments Conducted

* CPU stress causing ASG scale-out
* Health check failures triggering instance replacement
* Target draining validation
* Warmup behavior observation
* 5XX monitoring under stress
* Dashboard validation during scaling events


## What This Project Demonstrates

* Infrastructure as Code (Terraform)
* Containerized workloads on EC2
* Horizontal scaling strategies
* Load balancer health modeling
* Observability-first design
* SLO-driven reliability thinking
* Remote state best practices
* Failure injection for validation

This project focuses on operational maturity rather than application complexity.


## Future Improvements

* Rolling updates / zero-downtime deployments
* Blue/Green strategy
* Advanced SLO metric math (error rate ratio)
* SNS-based alerting
* Chaos experiments automation
* p95 latency objective tracking
* CI/CD pipeline integration (GitHub Actions)


## Philosophy

The objective is to treat even a small system as if it were production.

Reliability is not assumed.
It is measured, tested and enforced.







