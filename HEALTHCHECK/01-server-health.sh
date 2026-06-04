#!/bin/bash
echo "=== SERVER HEALTH ==="
uptime
free -h
df -h
df -i
top -bn1 | head -20
