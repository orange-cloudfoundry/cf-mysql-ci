#!/bin/bash

set -eux

MY_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
WORKSPACE_DIR="$( cd "${MY_DIR}/../../" && pwd )"
RELEASE_DIR="$(cd "${WORKSPACE_DIR}/cf-mysql-release" && pwd )"
CHANGED_RELEASE_DIR="$(cd "${WORKSPACE_DIR}/cf-mysql-release-changed" && pwd )"

ACCEPTANCE_TESTS_DIR="${CHANGED_RELEASE_DIR}/src/github.com/cloudfoundry-incubator/cf-mysql-acceptance-tests"


git config --global user.name "${GIT_AUTHOR_NAME:?}"
git config --global user.email "${GIT_AUTHOR_EMAIL:?}"

AWS_ACCESS_KEY_ID="${AWS_ACCESS_KEY_ID:-}"
AWS_SECRET_ACCESS_KEY="${AWS_SECRET_ACCESS_KEY:-}"
BLOBS_BUCKET_NAME="${BLOBS_BUCKET_NAME:-}"

# First argument should be path to file
function write_private_yaml() {
  cat <<EOF > $1
---
blobstore:
  provider: s3
  options:
    bucket_name: ${BLOBS_BUCKET_NAME}
    access_key_id: ${AWS_ACCESS_KEY_ID}
    secret_access_key: ${AWS_SECRET_ACCESS_KEY}
EOF
}


# copy all files, including hidden (e.g. .git/)
shopt -s dotglob
cp -r "${RELEASE_DIR}"/* "${CHANGED_RELEASE_DIR}"

pushd "${CHANGED_RELEASE_DIR}"
  if [[ -n "${AWS_ACCESS_KEY_ID}" && -n "${AWS_SECRET_ACCESS_KEY}" && -n "${BLOBS_BUCKET_NAME}" ]]; then
    write_private_yaml "${PWD}/config/private.yml"
  fi

  pushd "${ACCEPTANCE_TESTS_DIR}/assets/cipher_finder"
    ./gradlew build
  popd

  bosh add-blob "${ACCEPTANCE_TESTS_DIR}/assets/cipher_finder/build/libs/cipher_finder.jar" cipher_finder
  bosh upload-blobs

  git add .
  git commit -m "Rebuild cipher_finder.jar"
popd



