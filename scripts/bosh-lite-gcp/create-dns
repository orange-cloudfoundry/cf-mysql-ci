#!/bin/bash
set -eux

my_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
workspace_dir="$( cd "${my_dir}/../../../" && pwd )"
source "${workspace_dir}/cf-mysql-ci/scripts/utils.sh"

service_key="${workspace_dir}/deployments-core-services/bosh-lite-gcp/ci-service-account.json"

gcloud auth activate-service-account --key-file=${service_key}
gcloud config set project cf-core-services

zone="bosh-lite"

domain="bosh-lite.gcp.core-services.cf-app.com"
host=$(date +"%s")
url="${host}.${domain}"
wildcard_url="*.${url}"

ip_address=$(cat "${workspace_dir}/bosh-lite-info/external-ip")

gcloud dns record-sets transaction start --zone bosh-lite
gcloud dns record-sets transaction add --zone bosh-lite --name "${wildcard_url}" --ttl 300 --type A "${ip_address}"
gcloud dns record-sets transaction execute --zone bosh-lite

echo "${url}" > "${workspace_dir}/url/url"
echo "system_domain: ${url}" > "${workspace_dir}/url/url-vars.yml"
echo "${wildcard_url}" > "${workspace_dir}/url/wildcard_url"

credhub_login
credhub set -n /lite/system_domain -t value -v "${url}"
credhub set -n /lite/wildcard_url -t value -v "${wildcard_url}"
