#!/bin/bash

set -eux

MY_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
WORKSPACE_DIR="$( cd ${MY_DIR}/../../.. && pwd )"
SQL_QUERY_DIR=$( cd ${MY_DIR}/test-data && pwd )

source "${WORKSPACE_DIR}/cf-mysql-ci/scripts/utils.sh"

credhub_login

export BOSH_ENVIRONMENT=$(cat bosh-lite-info/external-ip)
export MYSQL_PASSWORD=$(credhub_value /lite/pxc/cf_mysql_mysql_admin_password)

pushd ${SQL_QUERY_DIR}
  echo "Reading test data..."

  mysql --host=${BOSH_ENVIRONMENT} \
    --user=root \
    --password=${MYSQL_PASSWORD} \
    --skip-column-names \
    -e "USE mysql_persistence_test; SELECT * FROM test_table;" | sed 's/\t/,/g;s/^//;s/$//;s/\n//g'  \
    > /tmp/exported-test-data.csv
     # exported to /tmp/exported-test-data.csv
     # --skip-column-names: Do not print out the first header line
     # sed: Convert from tab-separated to comma-separated

  set +e
  cmp ./test-data.csv /tmp/exported-test-data.csv
  FILES_MATCH=$?
  set -e

  if [ "${FILES_MATCH}" -ne "0" ]; then
    err "Data in database does not match test data"

    err "**** Expected Test Data ****"
    cat ./test-data.csv >&2
    err "**** Actual Test Data ****"
    cat /tmp/exported-test-data.csv >&2
    exit 1
  else
    # removing tmp file
    rm -f /tmp/exported-test-data.csv
  fi

  mysql --host=${BOSH_ENVIRONMENT} \
    --user=root \
    --password=${MYSQL_PASSWORD} \
    < clean-bosh-lite-test-database.sql
popd

echo "Data in DB matches test data"
