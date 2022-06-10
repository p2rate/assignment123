#!/usr/bin/env bash

SCRIPT_DIR="$(dirname "$(perl -e "use Cwd 'abs_path';print abs_path('${BASH_SOURCE[0]}');")" )"

USER_PROJECT_ROOT="${SCRIPT_DIR}/user-service"
USER_APPLICATION_COMPOSE_FILE="${SCRIPT_DIR}/user-service/_config/docker/compose/application.yml"
USER_SERVICES_COMPOSE_FILE="${SCRIPT_DIR}/user-service/_config/docker/compose/services.yml"

TRANSACTION_PROJECT_ROOT="${SCRIPT_DIR}/transaction-service"
TRANSACTION_APPLICATION_COMPOSE_FILE="${SCRIPT_DIR}/transaction-service/_config/docker/compose/application.yml"
TRANSACTION_SERVICES_COMPOSE_FILE="${SCRIPT_DIR}/transaction-service/_config/docker/compose/services.yml"

ACCOUNT_PROJECT_ROOT="${SCRIPT_DIR}/account-service"
ACCOUNT_APPLICATION_COMPOSE_FILE="${SCRIPT_DIR}/account-service/_config/docker/compose/application.yml"
ACCOUNT_SERVICES_COMPOSE_FILE="${SCRIPT_DIR}/account-service/_config/docker/compose/services.yml"


if [[ -f "${SCRIPT_DIR}/check-dependencies.sh" ]]; then
  source "${SCRIPT_DIR}/check-dependencies.sh"
else
  echo "==> [ERROR] check-dependencies.sh was not found in project root."
  exit 0
fi
util::src::check_dependencies




echo "==> [INFO] creating microservices docker network" && \
docker network create microservices && \

echo "==> [INFO] creating account-service docker network" && \
docker network create account-service && \

echo "==> [INFO] creating user-service docker network" && \
docker network create user-service && \

echo "==> [INFO] creating transaction-service docker network" && \
docker network create transaction-service && \





echo "==> [INFO] running docker-compose to run user-service-db" && \
docker-compose -f $USER_SERVICES_COMPOSE_FILE up -d && \

echo "==> [INFO] running docker-compose to run account-service-db" && \
docker-compose -f $ACCOUNT_SERVICES_COMPOSE_FILE up -d && \

echo "==> [INFO] running docker-compose to run transaction-service-db" && \
docker-compose -f $TRANSACTION_SERVICES_COMPOSE_FILE up -d






echo "==> [INFO] running gradlew bootJar to build user-service" && \
cd $USER_PROJECT_ROOT && \
"${USER_PROJECT_ROOT}/"gradlew bootJar && \

echo "==> [INFO] running gradlew bootJar to build account-service" && \
cd $ACCOUNT_PROJECT_ROOT && \
"${ACCOUNT_PROJECT_ROOT}/"gradlew bootJar && \

echo "==> [INFO] running gradlew bootJar to build transaction-service" && \
cd $TRANSACTION_PROJECT_ROOT && \
"${TRANSACTION_PROJECT_ROOT}/"gradlew bootJar && \





cd $SCRIPT_DIR && \

echo "==> [INFO]  build docker image for user-service" && \
docker-compose -f $USER_APPLICATION_COMPOSE_FILE build && \

echo "==> [INFO]  build docker image for account-service" && \
docker-compose -f $ACCOUNT_APPLICATION_COMPOSE_FILE build && \

echo "==> [INFO]  build docker image for transaction-service" && \
docker-compose -f $TRANSACTION_APPLICATION_COMPOSE_FILE build && \






echo "==> [INFO} waiting 30 seconds for services to start running" && \
sleep 30 && \




echo "==> [INFO]  running docker-compose to run user-service-api" && \
docker-compose -f $USER_APPLICATION_COMPOSE_FILE up -d && \

echo "==> [INFO]  running docker-compose to run account-service-api" && \
docker-compose -f $ACCOUNT_APPLICATION_COMPOSE_FILE up -d && \

echo "==> [INFO]  running docker-compose to run transaction-service-api" && \
docker-compose -f $TRANSACTION_APPLICATION_COMPOSE_FILE up -d && \





echo "==> [INFO} script finished running successfully"
