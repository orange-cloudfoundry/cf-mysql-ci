#!/bin/bash

function assert_rebase_attempted_without_changes() {
  if [ -z "$1" ]; then
    echo "no input provided - exiting"
    exit 1
  fi
  rebase_output=$1
  
  acceptable_search_result='rebase.*attempted.*without.*changes'
  (echo $rebase_output | grep -i $acceptable_search_result) > /dev/null 2>&1
  acceptable_search_result_found=$?

  if [ $acceptable_search_result_found -ne 0 ]; then
    echo "Unnacceptable upload output - failed to upload release - exiting"
    exit 1
  fi
  echo "Acceptable upload output - rebase attempted without changes"
}

function source_bosh_environment() {
  ENV=${ENV:?}
  MY_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
  ROOT_DIR="$( cd ${MY_DIR}/.. && pwd )"
  bosh_environment_location=${ROOT_DIR}/${ENV}/bosh_environment

  source ${bosh_environment_location}
}

function current_bosh_deployment() {
  set -eu

  bosh_output=$(bosh deployment)

  # The expected output from bosh deployment is some text
  # followed by the manifest file enclosed as `manifest_file.yml'
  #
  # What follows is a purely bash mechanism to split this string,
  # extracting just the manifest file
  # see http://stackoverflow.com/questions/19482123/extract-part-of-a-string-using-bash-cut-split
  manifest_file=${bosh_output##*\`}
  manifest_file=${manifest_file%\'*}

  echo "${manifest_file}"
}


function check_if_deployment_exists () {
    DEPLOYMENT_NAME=${1:?"Pass deployment name as first argument"}
    deployments_output=$( bosh deployments )
    echo ${deployments_output} | grep ${DEPLOYMENT_NAME}
}