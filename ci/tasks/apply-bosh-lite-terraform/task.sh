#!/bin/bash
set -eu

cp -r \
  "./${DEPLOYMENTS_DIR}"/* \
  "./${OUTPUT_DIR}"

bosh_lite_dir="./${OUTPUT_DIR}/bosh-lite-gcp"

pushd "${bosh_lite_dir}" > /dev/null
  ./create_vars_for_new_ip
  terraform init -input=false
  terraform apply -input=false -auto-approve
popd > /dev/null
