#!/bin/bash

check_if_deployment_exists () {
    DEPLOYMENT_NAME=${1:?"Pass deployment name as first argument"}
    deployments_output=$( bosh deployments )
    echo ${deployments_output} | grep ${DEPLOYMENT_NAME}
}

read_vars_from_env_lock_file () {
    lock=$(cat ${1})
    lock_keys=$(echo "${lock}" | jq -r keys | tr -d '"' | tr -d ',' | tr -d '[' | tr -d ']')
    for i in $lock_keys
    do
      key_uc=$(echo $i | tr '[:lower:]' '[:upper:]')
      val=$(echo "${lock}" | jq -r .${i})
      echo "export $key_uc=$val"
    done
}

jq_val() {
    JSON_KEY="${1:?Expected key name as first arg}"
    JSON_FILE="${2:?Expected JSON file as second arg}"

    RESULT="$(jq -r ".${JSON_KEY}" "${JSON_FILE}")"
    if [[ "$RESULT" == "null" ]]; then
        echo "Could not find key '${JSON_KEY}' in file '${JSON_FILE}'"
        exit 1
    fi
    echo "${RESULT}"
}
