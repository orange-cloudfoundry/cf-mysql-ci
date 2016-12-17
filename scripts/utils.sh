#!/bin/bash

check_if_deployment_exists () {
    DEPLOYMENT_NAME=${1:?"Pass deployment name as first argument"}
    deployments_output=$( bosh deployments )
    echo ${deployments_output} | grep ${DEPLOYMENT_NAME}
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

sslip_from_ip () {
    ip=$1
    ip_with_dashes=$(echo "${ip}" | sed 's/\./-/g')
    echo "https://${ip_with_dashes}.sslip.io"
}
