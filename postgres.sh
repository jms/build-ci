#!/usr/bin/env bash
set -Eeo pipefail

exec /usr/local/bin/docker-entrypoint.sh  postgres >>/var/log/postgresql_docker.log 2>&1 