#!/bin/bash
set -eu

my_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
ci_dir="$( cd "${my_dir}/../../" && pwd )"
workspace_dir="$( cd "${ci_dir}/../" && pwd )"

OUTPUT_DIR="${workspace_dir}/${OUTPUT_DIR}"
DEPLOYMENTS_DIR="${workspace_dir}/${DEPLOYMENTS_DIR}"

cp -r \
  "${DEPLOYMENTS_DIR}"/* \
  "${OUTPUT_DIR}"

bosh_lite_dir="${OUTPUT_DIR}/bosh-lite-gcp"

pushd "${bosh_lite_dir}" > /dev/null
  ./create_vars_for_new_ip
  terraform init -input=false
  terraform apply -input=false -auto-approve
popd > /dev/null
