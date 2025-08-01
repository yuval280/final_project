#!/bin/bash

set -e  # עצור אם יש שגיאה

NETWORK_NAME=my-network
MYSQL_CONTAINER=joomla-db
JOOMLA_CONTAINER=joomla-site
MYSQL_IMAGE=mysql:latest
JOOMLA_IMAGE=latest

echo "📡 בודק אם רשת $NETWORK_NAME כבר קיימת..."
if ! docker network ls | grep -q $NETWORK_NAME; then
  echo "🔧 יוצרים רשת בשם $NETWORK_NAME..."
  docker network create $NETWORK_NAME
else
  echo "ℹ️ הרשת כבר קיימת."
fi

echo "📦 בודק אם Image של $MYSQL_IMAGE קיים..."
if ! docker image ls | grep -q "mysql.*latest"; then
  echo "⬇️ מוריד את $MYSQL_IMAGE..."
  docker pull $MYSQL_IMAGE
fi

echo "📦 בודק אם Image של $JOOMLA_IMAGE קיים..."
if ! docker image ls | grep -q "joomla"; then
  echo "⬇️ מוריד את $JOOMLA_IMAGE..."
  docker pull $JOOMLA_IMAGE
fi

echo "🚀 מריץ את קונטיינר $MYSQL_CONTAINER..."
docker run -d \
  --name $MYSQL_CONTAINER \
  --network $NETWORK_NAME \
  -e MYSQL_ROOT_PASSWORD=my-secret-pw \
  -e MYSQL_DATABASE=joomladb \
  -e MYSQL_USER=joomlauser \
  -e MYSQL_PASSWORD=joomlapass \
  -v joomla_mysql_data:/var/lib/mysql \
  $MYSQL_IMAGE

echo "⏳ ממתין 10 שניות ל-MySQL שיתייצב..."
sleep 10

echo "🚀 מריץ את קונטיינר $JOOMLA_CONTAINER..."
docker run -d \
  --name $JOOMLA_CONTAINER \
  --network $NETWORK_NAME \
  -e JOOMLA_DB_HOST=$MYSQL_CONTAINER \
  -e JOOMLA_DB_USER=joomlauser \
  -e JOOMLA_DB_PASSWORD=joomlapass \
  -e JOOMLA_DB_NAME=joomladb \
  -v joomla_data:/var/www/html \
  -p 8080:80 \
  $JOOMLA_IMAGE
