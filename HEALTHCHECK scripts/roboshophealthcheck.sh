#chmod +x roboshop-healthcheck.sh
# ./roboshop-healthcheck.sh
#
#
#


#!/bin/bash

echo "==========================================="
echo "      ROBOSHOP INFRA HEALTH CHECK"
echo "==========================================="

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

success() {
  echo -e "${GREEN}[PASS]${NC} $1"
}

fail() {
  echo -e "${RED}[FAIL]${NC} $1"
}

warn() {
  echo -e "${YELLOW}[WARN]${NC} $1"
}

echo
echo "========== SERVER HEALTH =========="

uptime

echo
free -h

echo
df -h

echo
echo "========== SERVICE CHECK =========="

SERVICES=(
mongod
mysqld
redis
rabbitmq-server
)

for svc in "${SERVICES[@]}"
do
    if systemctl is-active --quiet $svc 2>/dev/null
    then
        success "$svc running"
    else
        warn "$svc not installed or stopped"
    fi
done

echo
echo "========== PORT CHECK =========="

PORTS=(
27017
3306
6379
5672
)

for port in "${PORTS[@]}"
do
    ss -lntp | grep -q ":$port "
    if [ $? -eq 0 ]
    then
        success "Port $port listening"
    else
        warn "Port $port not listening"
    fi
done

echo
echo "========== DNS CHECK =========="

HOSTS=(
mongodb-dev.devopsgeek.online
mysql-dev.devopsgeek.online
redis-dev.devopsgeek.online
rabbitmq-dev.devopsgeek.online
)

for host in "${HOSTS[@]}"
do
    nslookup $host >/dev/null 2>&1
    if [ $? -eq 0 ]
    then
        success "$host resolves"
    else
        fail "$host DNS failure"
    fi
done

echo
echo "========== CONNECTIVITY CHECK =========="

check_conn() {

HOST=$1
PORT=$2

nc -zvw3 $HOST $PORT >/dev/null 2>&1

if [ $? -eq 0 ]
then
    success "$HOST:$PORT reachable"
else
    fail "$HOST:$PORT unreachable"
fi
}

check_conn mongodb-dev.devopsgeek.online 27017
check_conn mysql-dev.devopsgeek.online 3306
check_conn redis-dev.devopsgeek.online 6379
check_conn rabbitmq-dev.devopsgeek.online 5672

echo
echo "========== APPLICATION HANDSHAKE =========="

if command -v mongosh >/dev/null 2>&1
then
    mongosh --quiet --eval "db.adminCommand('ping')" >/dev/null 2>&1
    [ $? -eq 0 ] && success "MongoDB Ping" || fail "MongoDB Ping"
fi

if command -v redis-cli >/dev/null 2>&1
then
    redis-cli ping 2>/dev/null | grep -q PONG
    [ $? -eq 0 ] && success "Redis Ping" || fail "Redis Ping"
fi

if command -v mysql >/dev/null 2>&1
then
    warn "Run manual MySQL authentication check"
fi

if command -v rabbitmq-diagnostics >/dev/null 2>&1
then
    rabbitmq-diagnostics ping >/dev/null 2>&1
    [ $? -eq 0 ] && success "RabbitMQ Ping" || fail "RabbitMQ Ping"
fi

echo
echo "========== TOP RESOURCE CONSUMERS =========="

ps aux --sort=-%cpu | head

echo
ps aux --sort=-%mem | head

echo
echo "========== INCIDENT SUMMARY =========="

echo "
1. Service Running?
2. Port Listening?
3. DNS Resolving?
4. Connectivity Working?
5. Authentication Working?
6. Dependency Healthy?
7. CPU OK?
8. Memory OK?
9. Disk OK?
"

echo
echo "Health Check Completed"

#------------------
# One suggestion before you automate everything:

# Build your troubleshooting toolkit in the same order as the infrastructure.

# healthchecks/
# │
# ├── 01-server-health.sh
# ├── 02-network-health.sh
# ├── 03-database-health.sh
# ├── 04-alb-health.sh
# ├── 05-app-health.sh
# └── 99-full-health.sh

# That mirrors how production incidents are diagnosed.

# Example:

# Website Down
#     │
#     ├── Server Alive?
#     │      └── 01-server-health.sh
#     │
#     ├── Network OK?
#     │      └── 02-network-health.sh
#     │
#     ├── DB Reachable?
#     │      └── 03-database-health.sh
#     │
#     ├── ALB Healthy?
#     │      └── 04-alb-health.sh
#     │
#     └── App Healthy?
#            └── 05-app-health.sh

# As you continue with Roboshop, keep adding checks you discover during failures:

# Mongo auth failure
# Redis auth failure
# MySQL schema missing
# RabbitMQ user missing
# Route53 mismatch
# Target group unhealthy
# ACM expired
# CloudFront cache issue
# NAT routing issue
# Disk full
# OOM kill
# CPU saturation

# After a few months you'll have something much more valuable than course notes: a personal production runbook. That's often what separates someone who can deploy Roboshop from someone who can keep it running during outages.