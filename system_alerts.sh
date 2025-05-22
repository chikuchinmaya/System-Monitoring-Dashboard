#!/bin/bash

# Define SNS Topic ARN
SNS_TOPIC_ARN="arn:aws:sns:region:account-id:HighMetricsAlerts"

# Fetch CPU usage
cpu_usage=$(top -bn1 | grep "Cpu(s)" | awk '{print 100 - $8}')

# Fetch memory usage
used_memory_percent=$(free | awk '/Mem/ {printf("%.1f", ($3/$2) * 100)}')

# Fetch disk usage
disk_usage_percent=$(df / | awk 'NR==2 {print $5}' | sed 's/%//g')

# Check thresholds and trigger SNS alerts
if (( $(echo "$cpu_usage > 80" | bc -l) )); then
    aws sns publish --topic-arn "$SNS_TOPIC_ARN" --message "🚨 High CPU Usage: $cpu_usage% 🚨"
fi

if (( $(echo "$used_memory_percent > 85" | bc -l) )); then
    aws sns publish --topic-arn "$SNS_TOPIC_ARN" --message "🚨 High Memory Usage: $used_memory_percent% 🚨"
fi

if (( disk_usage_percent > 90 )); then
    aws sns publish --topic-arn "$SNS_TOPIC_ARN" --message "🚨 Disk Space Critical: $disk_usage_percent% used 🚨"
fi

echo "System monitoring report sent to SNS if thresholds exceeded."
