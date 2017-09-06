#!/bin/bash
set -eux

export BOSH_ENVIRONMENT="$(cat "${ENV_TARGET_FILE}")"
export BOSH_CA_CERT="$(cat "${BOSH_CA_CERT_PATH}")"

bosh -n update-cloud-config "${CLOUD_CONFIG}"