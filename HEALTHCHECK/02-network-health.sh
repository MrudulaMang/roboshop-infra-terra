#!/bin/bash
echo "=== NETWORK HEALTH ==="
for h in mongodb-dev.devopsgeek.online mysql-dev.devopsgeek.online redis-dev.devopsgeek.online rabbitmq-dev.devopsgeek.online
do
 echo "Checking $h"
 nslookup $h
done
