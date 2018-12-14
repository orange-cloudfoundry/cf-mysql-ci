#!/usr/bin/env bash

set -eux

MY_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
WORKSPACE_DIR="${MY_DIR}/../../../"
RELEASE_DIR="${WORKSPACE_DIR}/pxc-release"
: "${TEST_SUITE_NAME:?TEST_SUITE_NAME must be specified}"

export BOSH_ENVIRONMENT=$(cat bosh-lite-info/external-ip)
export BOSH_CA_CERT=$(cat ${WORKSPACE_DIR}/bosh-lite-info/ca-cert)
export BOSH_GW_PRIVATE_KEY="${WORKSPACE_DIR}/bosh-lite-info/jumpbox-private-key"
export BOSH_GW_USER=jumpbox
export BOSH_ALL_PROXY="ssh+socks5://$BOSH_GW_USER@$BOSH_ENVIRONMENT:22?private-key=$BOSH_GW_PRIVATE_KEY"
export BOSH_UAA_CA=bosh-lite-info/uaa.ca
export CREDHUB_SERVER="https://$(cat bosh-lite-info/external-ip):8844"
export CREDHUB_CLIENT=credhub-admin
export CREDHUB_SECRET=$(bosh int "bosh-lite-info/bosh-creds.yml" --path /credhub_admin_client_secret)
export CREDHUB_CA_CERT="$(echo -e "$(<bosh-lite-info/credhub.ca)\n$(<bosh-lite-info/uaa.ca)")"

source ${RELEASE_DIR}/.envrc # To set GOPATH to release dir
go install -v github.com/onsi/ginkgo/ginkgo

# turn off the resurrector so that `scan-and-fix` tasks don't collide with our tests
bosh update-resurrection off

pushd ${RELEASE_DIR}
  echo "Running tests ..."
  ginkgo "src/specs/integration/${TEST_SUITE_NAME}"
popd
