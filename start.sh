#!/bin/sh

set -e

#
docker network create inss-local || true
docker compose -f docker-compose-development.yml build
docker compose -f docker-compose-development.yml run --service-ports --rm app bundle exec foreman start
