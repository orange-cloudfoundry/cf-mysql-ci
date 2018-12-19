#!/bin/bash

set -eux -o pipefail

WORKSPACE_DIR="$(pwd)"
CI_DIR="${WORKSPACE_DIR}/cf-mysql-ci/"

source ${CI_DIR}/scripts/utils.sh

BOSH_ENVIRONMENT=${BOSH_ENVIRONMENT:-"$(jq_val "target" "${ENV_METADATA}")"}
export BOSH_ENVIRONMENT

BOSH_CLIENT=${BOSH_CLIENT:-"$(jq_val "client" "${ENV_METADATA}")"}
export BOSH_CLIENT

BOSH_CLIENT_SECRET=${BOSH_CLIENT_SECRET:-"$(jq_val "client_secret" "${ENV_METADATA}")"}
export BOSH_CLIENT_SECRET

BOSH_CA_CERT=${BOSH_CA_CERT:-"$(jq_val "ca_cert" "${ENV_METADATA}")"}
export BOSH_CA_CERT

bosh -n delete-deployment

bosh -n clean-up --all
