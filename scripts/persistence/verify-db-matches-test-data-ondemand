#!/bin/bash

set -eux

MY_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
WORKSPACE_DIR="$( cd ${MY_DIR}/../../.. && pwd )"
SQL_QUERY_DIR=$( cd ${MY_DIR}/test-data && pwd )

: "${ENV_TARGET_FILE:?}"

BOSH_ENVIRONMENT="$(cat "${ENV_TARGET_FILE}")"

MYSQL_TUNNEL_IP=127.0.0.1
MYSQL_TUNNEL_PORT=3307
MYSQL_VM_IP="${MYSQL_VM_IP:-10.244.7.2}"
MYSQL_VM_PORT=3306

echo "Targeting remote bosh-lite, starting ssh tunnel..."

SSH_KEY_FILE="${WORKSPACE_DIR}/bosh-lite-info/jumpbox-private-key"

function close-ssh-tunnels() {
  echo "Closing SSH tunnels ..."
  OLD_TUNNELS=`ps aux | grep "ssh" | grep "\-L $MYSQL_TUNNEL_PORT" | awk '{print $2}'`
  [[ -z "${OLD_TUNNELS}" ]] || kill ${OLD_TUNNELS}
}

# open SSH tunnel to mysql container on bosh-lite
trap close-ssh-tunnels EXIT
ssh -L ${MYSQL_TUNNEL_PORT}:${MYSQL_VM_IP}:${MYSQL_VM_PORT} \
  -nNTf \
  -o StrictHostKeyChecking=no \
  -i "${SSH_KEY_FILE}" \
  jumpbox@${BOSH_ENVIRONMENT}

MYSQL_HOST=${MYSQL_TUNNEL_IP}
MYSQL_PORT=${MYSQL_TUNNEL_PORT}

pushd ${SQL_QUERY_DIR}
  echo "Reading test data..."

  mysql \
    --host=${MYSQL_HOST} \
    --port=${MYSQL_PORT} \
    --user=root \
    --password=password \
    --skip-column-names \
    -e "USE mysql_persistence_test; SELECT * FROM test_table;" | sed 's/\t/,/g;s/^//;s/$//;s/\n//g'  \
    > /tmp/exported-test-data.csv
     # exported to /tmp/exported-test-data.csv
     # -B: Batch mode makes it use tab-separation
     # --skip-column-names: Do not print out the first header line
     # sed: Convert from tab-separated to comma-separated

  set +e
  cmp ./test-data.csv /tmp/exported-test-data.csv
  FILES_MATCH=$?
  set -e

  if [ "${FILES_MATCH}" -ne "0" ]; then
    echo "Data in database does not match test data"

    echo "**** Expected Test Data ****"
    cat ./test-data.csv
    echo "**** Actual Test Data ****"
    cat /tmp/exported-test-data.csv
    exit 1
  else
    # removing tmp file
    rm -f /tmp/exported-test-data.csv
  fi

  mysql --host=${MYSQL_HOST} \
    --port=${MYSQL_PORT} \
    --user=root \
    --password=password \
    < clean-bosh-lite-test-database.sql
popd

echo "Data in DB matches test data"
