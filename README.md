# Infra Reliability Lab

Production-like AWS infrastructure designed to explore reliability engineering principles: observability, failure injection, autoscaling, and SLO validation.


## Overview

This project simulates a minimal cloud service running behind an Application Load Balancer with Auto Scaling.

The focus is not application complexity, but operational excellence:

* Structured logging
* Failure simulation
* Error detection from logs
* SLI/SLO monitoring
* Target tracking autoscaling
* Infrastructure as Code

All infrastructure is provisioned using Terraform.


## Architecture

* AWS VPC (multi-AZ)
* Application Load Balancer
* Auto Scaling Group (EC2)
* Dockerized Python service
* Amazon ECR
* CloudWatch (logs, metrics, alarms, dashboards)
* S3 + DynamoDB backend for Terraform state


## Reliability Features

### Failure Injection

The application exposes a controlled failure endpoint:

```
/error
```

Used to simulate production incidents and validate detection mechanisms.


### Structured Logging

* JSON logs
* Request ID tracking
* Latency measurement
* Centralized in CloudWatch Logs


### Log-Based Error Detection

A CloudWatch Metric Filter converts application `"ERROR"` logs into a custom metric:

```
InfraReliabilityLab / AppErrorCount
```

An alarm triggers automatically on error spikes.


### Service Level Indicator (SLI)

Availability SLI is calculated from ALB metrics:

```
Availability = 100 - (5XX / Requests * 100)
```

Target SLO: **99.9% availability**

Custom CloudWatch alarms validate SLO compliance.


### Autoscaling Strategy

Target Tracking Policy:

* Metric: ASGAverageCPUUtilization
* Target: ~55%
* Automatic scale-out under load
* Rolling replacement of unhealthy instances


## CI/CD

GitHub Actions pipeline:

* Builds Docker image (linux/amd64)
* Pushes to Amazon ECR
* Infrastructure deployed via Terraform


## What This Project Demonstrates

* Infrastructure as Code discipline
* Observability-first design
* Controlled failure testing
* Log-to-metric transformation
* Alert-driven reliability validation
* Production-style autoscaling


## Status

Active project — continuously improving SLO modeling and reliability mechanisms.









