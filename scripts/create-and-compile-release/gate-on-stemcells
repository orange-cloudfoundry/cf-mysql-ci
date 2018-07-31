#!/bin/bash

set -eux

CWD=$(pwd)

gcp=$(egrep -o "^[0-9]+" "${CWD}/gcp-bosh-stemcell/version")
boshlite=$(egrep -o "^[0-9]+" "${CWD}/bosh-lite-stemcell/version")

if [[ "${gcp}" != "${boshlite}" ]]; then
	set +x
	echo "Not all stemcells are on the same version"
	echo "gcp=${gcp}"
	echo "boshlite=${boshlite}"
	exit 1
fi

