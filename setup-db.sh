#!/bin/sh

set -e

#
docker network create inss-local || true
docker compose -f docker-compose-development.yml build
docker compose -f docker-compose-development.yml run --service-ports --rm app bin/rails db:drop db:create db:migrate db:seed
