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





echo "==> [INFO] running docker-compose to stop user-service-db"
docker-compose -f $USER_SERVICES_COMPOSE_FILE down

echo "==> [INFO] running docker-compose to stop account-service-db"
docker-compose -f $ACCOUNT_SERVICES_COMPOSE_FILE down

echo "==> [INFO] running docker-compose to stop transaction-service-db"
docker-compose -f $TRANSACTION_SERVICES_COMPOSE_FILE down




echo "==> [INFO]  running docker-compose to stop user-service-api"
docker-compose -f $USER_APPLICATION_COMPOSE_FILE down

echo "==> [INFO]  running docker-compose to stop account-service-api"
docker-compose -f $ACCOUNT_APPLICATION_COMPOSE_FILE down

echo "==> [INFO]  running docker-compose to stop transaction-service-api"
docker-compose -f $TRANSACTION_APPLICATION_COMPOSE_FILE down



