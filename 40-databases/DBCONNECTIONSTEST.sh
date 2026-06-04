#!/bin/bash

echo "======================================"
echo " ROBOSHOP DATABASE HEALTH CHECK"
echo "======================================"

check_port() {

NAME=$1
HOST=$2
PORT=$3

echo ""
echo "Checking $NAME"

echo -n "DNS: "
nslookup $HOST >/dev/null 2>&1

if [ $? -eq 0 ]; then
echo "OK"
else
echo "FAILED"
return
fi

echo -n "PORT $PORT: "

nc -zvw3 $HOST $PORT >/dev/null 2>&1

if [ $? -eq 0 ]; then
echo "OPEN"
else
echo "CLOSED"
fi
}

check_port MongoDB  mongodb-dev.devopsgeek.online 27017
check_port Redis    redis-dev.devopsgeek.online 6379
check_port MySQL    mysql-dev.devopsgeek.online 3306
check_port RabbitMQ rabbitmq-dev.devopsgeek.online 5672

echo ""
echo "Done"
