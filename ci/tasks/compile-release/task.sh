#!/bin/bash

set -eux

MY_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
WORKSPACE_DIR="$( cd "${MY_DIR}/../.." && pwd )"
OUTPUT_DIR="${WORKSPACE_DIR}/${OUTPUT_DIR:-compiled-release-tarball}"
DEPLOYMENT_NAME=d-$(cat /proc/sys/kernel/random/uuid)

jb_tmp_file=$(mktemp)
set +x
echo "$BOSH_JUMPBOX_PRIVATE_KEY" > $jb_tmp_file
set -x

BOSH_ALL_PROXY="$BOSH_ALL_PROXY=$jb_tmp_file"

source "${MY_DIR}/utils.sh"

RELEASE_TARBALL_DIR=${RELEASE_TARBALL_DIR:-release-tarball}
RELEASE_TARBALL_DIR="${WORKSPACE_DIR}/${RELEASE_TARBALL_DIR}"
export RELEASE_TARBALL_DIR

RELEASE_FILENAME=${RELEASE_FILENAME:-tgz}
STEMCELL_LINE=${STEMCELL_LINE:-ubuntu-trusty}

RELEASE_FILE=$(ls ${RELEASE_TARBALL_DIR}/ | grep ${RELEASE_FILENAME})
export RELEASE_FILE

name=${RELEASE_NAME:-$(release_name)}
version=$(release_version)

# egrep for pivnet-resource stemcells that will have the etag after the version
stemcell_version=$(cat *stemcell/version | egrep -o '^[0-9.]+')

pushd "${WORKSPACE_DIR}"
  cat << EOF > deployment.yml
---
name: ${DEPLOYMENT_NAME}

releases:
- name: ${name}
  version: "${version}"
  url: "file://${RELEASE_TARBALL_DIR}/${RELEASE_FILE}"

stemcells:
- alias: default
  os: ${STEMCELL_LINE}
  version: "${stemcell_version}"

instance_groups: []

update:
  canaries: 1
  max_in_flight: 1
  canary_watch_time: 1000-90000
  update_watch_time: 1000-90000
EOF

  bosh upload-stemcell *stemcell/*.tgz
  bosh -n -d ${DEPLOYMENT_NAME} deploy deployment.yml

  bosh -d ${DEPLOYMENT_NAME} export-release --dir ${OUTPUT_DIR} ${name}/${version} ${STEMCELL_LINE}/${stemcell_version}

  bosh -d ${DEPLOYMENT_NAME} -n delete-deployment
popd
