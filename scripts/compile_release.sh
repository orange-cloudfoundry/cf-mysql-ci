#!/bin/bash

set -eux

MY_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
WORKSPACE_DIR="$( cd "${MY_DIR}/../.." && pwd )"
OUTPUT_DIR="${WORKSPACE_DIR}/${OUTPUT_DIR:-release-tarball}"
DEPLOYMENT_NAME=$(cat /proc/sys/kernel/random/uuid)
STEMCELL_VERSION="UNKNOWN"
RELEASE_NAME="cf-mysql"
RELEASE_VERSION="UNKNOWN"

pushd "${WORKSPACE_DIR}"
  echo <<EOF > deployment.yml
---
name: ${DEPLOYMENT_NAME}

director_uuid: 28dc9bd9-c145-4048-b4b1-7e3582a51e9f

releases:
- name: ${RELEASE_NAME}
  version: "${RELEASE_VERSION}"

stemcells:
- alias: default
  os: ubuntu-trusty
  version: ${STEMCELL_VERSION}

jobs: []

update:
  canaries: 1
  max_in_flight: 1
  canary_watch_time: 1000-90000
  update_watch_time: 1000-90000
EOF
  set +x
    $(bosh -u ${BOSH_USER} -p ${BOSH_PASSWORD} target ${BOSH_DIRECTOR})
    $(bosh login ${BOSH_USER} ${BOSH_PASSWORD})
  set -x

  $(bosh deployment deployment.yml)
popd
