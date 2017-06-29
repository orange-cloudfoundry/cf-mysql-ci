#!/bin/bash -eux

export BOSH_ENVIRONMENT=$(cat $ENV_TARGET_FILE)

bosh -n delete-deployment --force
bosh -n clean-up --all
