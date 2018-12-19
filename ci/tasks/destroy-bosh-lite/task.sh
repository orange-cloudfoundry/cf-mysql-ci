#!/bin/bash
set -eu

bosh delete-env "bosh-lite-info/manifest.yml" \
  --state "bosh-lite-info/bosh-state.json" \
  --vars-store "bosh-lite-info/bosh-creds.yml"

