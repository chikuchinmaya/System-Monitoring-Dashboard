#!/bin/bash

echo "Content-type: text/html"
echo ""
echo "<html><head><title>Chinmaya's System Monitoring Dashboard</title></head><body>"
echo "<h2>Chinmaya's System Status Report</h2>"
echo "<pre>"

# ------------------------ OS Info ------------------------
echo "🖥️  OS Info:"
if [ -f /etc/os-release ]; then
    . /etc/os-release
    echo "$NAME $VERSION"
else
    uname -a
fi

# ------------------------ CPU Uptime ------------------------
echo "⏳ CPU Uptime:"
read system_uptime idle_time < /proc/uptime
total_seconds=${system_uptime%.*}
days=$((total_seconds / 86400))
hours=$(((total_seconds % 86400) / 3600))
minutes=$(((total_seconds % 3600) / 60))
seconds=$((total_seconds % 60))

[[ $days -gt 0 ]] && echo "$days days"
[[ $hours -gt 0 ]] && echo "$hours hours"
[[ $minutes -gt 0 ]] && echo "$minutes minutes"
[[ $seconds -gt 0 ]] && echo "$seconds seconds"

# ------------------------ CPU Usage ------------------------
echo "🔥 CPU Usage:"
top_output=$(top -bn1)
cpu_idle=$(echo "$top_output" | grep "Cpu(s)" | sed 's/.*, *\([0-9.]*\)%* id.*/\1/')
cpu_usage=$(awk -v idle="$cpu_idle" 'BEGIN { printf("%.1f", 100 - idle) }')
echo "Usage: $cpu_usage%"

# ------------------------ Memory Usage ------------------------
echo "🧠 Memory Usage:"
read total_memory available_memory <<< $(awk '/MemTotal/ {t=$2} /MemAvailable/ {a=$2} END {print t, a}' /proc/meminfo)
used_memory=$((total_memory - available_memory))
used_memory_percent=$(awk -v u=$used_memory -v t=$total_memory 'BEGIN { printf("%.1f", (u / t) * 100) }')
available_memory_mb=$(awk -v a=$available_memory 'BEGIN { printf("%.1f", a/1024) }')

echo "Used Memory: $used_memory_percent%"
echo "Free Memory: $available_memory_mb MB"

# ------------------------ Disk Usage ------------------------
echo "💾 Disk Usage:"
df_output=$(df -h /)
size_disk=$(echo "$df_output" | awk 'NR==2 {printf $2}')
read used_disk available_disk <<< $(echo "$df_output" | awk 'NR==2 {print $3, $4}')
df_output_raw=$(df /)
read size_disk_kb used_disk_kb available_disk_kb <<< $(echo "$df_output_raw" | awk 'NR==2 {print $2, $3, $4}')

if command -v bc &> /dev/null; then
  used_disk_percent=$(echo "scale=2; $used_disk_kb * 100 / $size_disk_kb" | bc)
  available_disk_percent=$(echo "scale=2; $available_disk_kb * 100 / $size_disk_kb" | bc)
else
  used_disk_percent=$(( used_disk_kb * 100 / size_disk_kb ))
  available_disk_percent=$((available_disk_kb * 100 / size_disk_kb))
fi

echo "Disk Size: $size_disk | Used: $used_disk ($used_disk_percent%) | Available: $available_disk ($available_disk_percent%)"

# ------------------------ Top Processes ------------------------
echo "🔥 Top 5 Processes by CPU:"
ps aux --sort=-%cpu | awk 'NR==1 || NR<=6 { printf "%-10s %-6s %-5s %-5s %s\n", $1, $2, $3, $4, $11 }'

echo "🧠 Top 5 Processes by Memory:"
ps aux --sort=-%mem | awk 'NR==1 || NR<=6 { printf "%-10s %-6s %-5s %-5s %s\n", $1, $2, $3, $4, $11 }'

echo "</pre>"
echo "</body></html>"
