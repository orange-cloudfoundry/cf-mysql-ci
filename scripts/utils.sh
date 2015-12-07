#!/bin/bash

function check_if_deployment_exists () {
    DEPLOYMENT_NAME=${1:?"Pass deployment name as first argument"}
    deployments_output=$( bosh deployments )
    echo ${deployments_output} | grep ${DEPLOYMENT_NAME}
}

function read_vars_from_env_lock_file () {
    lock=$(cat ${1})
    lock_keys=$(echo "${lock}" | jq -r keys | tr -d '"' | tr -d ',' | tr -d '[' | tr -d ']')
    for i in $lock_keys
    do
      key_uc=$(echo $i | tr '[:lower:]' '[:upper:]')
      val=$(echo "${lock}" | jq -r .${i})
      echo "$key_uc=$val"
    done
}