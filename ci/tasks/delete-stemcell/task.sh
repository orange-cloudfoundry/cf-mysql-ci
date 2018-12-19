#!/bin/bash
set -eux

gcloud auth activate-service-account \
    --key-file="./deployments/bosh-lite-gcp/ci-service-account.json"
gcloud config set project cf-core-services

stemcell_id=$(bosh int "./bosh-lite-info/bosh-state.json" --path /stemcells/0/cid)

echo "Deleting stemcell ${stemcell_id}"

gcloud compute images delete \
        ${stemcell_id} \
        --quiet

cp ./bosh-lite-info/* ./bosh-lite-info-stemcell-deleted/

pushd "./bosh-lite-info-stemcell-deleted"
    cat bosh-state.json | jq "del(.stemcells[0])" > bosh-state.json.new
    mv bosh-state.json.new bosh-state.json
popd
