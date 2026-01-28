## Simple HTTP Service

very simple HTTP service used for reliability and observability experiments.

Endpoints:
- `/` → main endpoint (supports artificial latency via `?delay=` parameter)
- `/health` → health check endpoint
