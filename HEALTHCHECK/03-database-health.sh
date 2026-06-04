#!/bin/bash
echo "=== DATABASE HEALTH ==="
nc -zv mongodb-dev.devopsgeek.online 27017
nc -zv mysql-dev.devopsgeek.online 3306
nc -zv redis-dev.devopsgeek.online 6379
nc -zv rabbitmq-dev.devopsgeek.online 5672
