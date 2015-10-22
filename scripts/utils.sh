#!/bin/bash

function check_if_deployment_exists () {
    DEPLOYMENT_NAME=${1:?"Pass deployment name as first argument"}
    deployments_output=$( bosh deployments )
    echo ${deployments_output} | grep ${DEPLOYMENT_NAME}
}
