#!/bin/bash

set -eu

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

# sslip_from_ip returns the IPv4 address as an sslip hostname
# e.g. 10.244.3.4 is returned as https://10-244-3-4.sslip.io
# Any input that is not a valid IPv4 address will be returned immediately.
sslip_from_ip () {
    input=$1

    if [[ "${input}" =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}$ ]]; then
      ip_with_dashes=$(echo "${input}" | sed 's/\./-/g')
      echo "https://${ip_with_dashes}.sslip.io"
    else
      echo "${input}"
    fi
}

# release_version returns the version of a bosh release from its
# tarball or the version file.
release_version() {
    release_manifest=$(tar --wildcards -zxOf ${RELEASE_TARBALL_DIR}/${RELEASE_FILE} *release.MF)
    echo $(echo "${release_manifest}" | grep "^version:" | sed 's/version: \(.*\)/\1/' | tr -d '"' | tr -d "'")
}

# release_name returns the name of a bosh release from its
# tarball or the version file.
release_name() {
    if [ -f "${RELEASE_TARBALL_DIR}/version" ]; then
      release_manifest=$(tar --wildcards -zxOf "${RELEASE_TARBALL_DIR}/${RELEASE_FILE}" *release.MF)
      name=$(echo "${release_manifest}" | grep "^name:" | sed 's/name: \(.*\)/\1/')
    else
      name=$(echo ${RELEASE_FILE} | sed 's/\(.*\)-[0-9].*/\1/')
    fi
    echo "${name}"
}
