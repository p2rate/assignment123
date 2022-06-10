#!/usr/bin/env bash

function util::src::check_dependencies() {
  # ----------------------------------------------------------------------------
  # JAVA CHECK
  # ----------------------------------------------------------------------------
  echo "==> [INFO] Checking for JAVA on system."
  [[ -n "${JAVA_HOME}" ]] || { echo "==> [ERROR] JAVA_HOME not set on your system."; }
  if [[ -z "${JAVA_HOME}" ]]; then
    echo "==> [INFO] Setting JAVA_HOME to OS X Default."
    export JAVA_HOME="$(/usr/libexec/java_home)"
  fi
  [[ -n "$(command -v java)" ]] || { echo "==> [ERROR] No java found."; exit 1; }
  echo "==> [SUCCESS] JAVA configured. JAVA_HOME is ${JAVA_HOME}"

  # ----------------------------------------------------------------------------
  # GRADLE CHECK
  # ----------------------------------------------------------------------------
  echo "==> [INFO] Checking for 'gradle' on system."
  [[ -n "$(command -v gradle)" ]] || { echo "==> [ERROR] 'gradle' was not found on system."; exit 1; }
  echo "==> [SUCCESS] 'gradle' configured."

  # ----------------------------------------------------------------------------
  # DOCKER CHECK
  # ----------------------------------------------------------------------------
  echo "==> [INFO] Checking for 'docker' on system."
  [[ -n "$(command -v docker)" ]] || { echo "==> [ERROR] 'docker' was not found on system."; exit 1; }
  [[ -n "$(command -v docker-compose)" ]] || ( echo "==> [ERROR] 'docker-compose' was not found on system." && exit 1 )
  echo "==> [SUCCESS] 'docker' configured."

  # ----------------------------------------------------------------------------
  # TAR CHECK
  # ----------------------------------------------------------------------------
  echo "==> [INFO] Checking for 'tar' on system."
  [[ -n "$(command -v tar)" ]] || { echo "==> [ERROR] 'tar' not found on system."; exit 1; }
  echo "==> [SUCCESS] 'tar' configured."
}
readonly -f util::src::check_dependencies
