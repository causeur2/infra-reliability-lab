#!/bin/bash

ALB_URL="http://reliability-alb-1619884122.eu-west-3.elb.amazonaws.com"
REQUESTS=${1:-300}

echo "Starting CPU stress test..."
echo "Target: $ALB_URL"
echo "Requests: $REQUESTS"
echo "----------------------------------"

for i in $(seq 1 $REQUESTS); do
  curl -s "$ALB_URL/?stress=cpu" > /dev/null &
done

wait

echo "----------------------------------"
echo "Load test completed."

