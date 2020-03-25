#!/bin/bash

for BINNAME in jq git terraform
  do if ! which $BINNAME 1>/dev/null; then
    echo "Tool ${BINNAME} was not found."
    exit 1
  fi
done

cd "$(dirname "$0")" || exit 1
CONFIGDIR="."
TFSTATEFILENAME='tfstateconfig.tf.json'
until [[ -e "${CONFIGDIR}/${TFSTATEFILENAME}" ]]
do
  CONFIGDIR="${CONFIGDIR}/.."
done

S3BUCKET_NAME=$(jq -r '.variable.s3bucket_name.default' "${CONFIGDIR}/${TFSTATEFILENAME}")
S3BUCKET_REGION=$(jq -r '.variable.s3bucket_region.default' "${CONFIGDIR}/${TFSTATEFILENAME}")

ROOT=$(git rev-parse --show-toplevel)
PWD=$(pwd)
S3BUCKET_KEY="${PWD#$ROOT/terraform/}/terraform.tfstate"

echo "Registering bucket with following parameters:
  bucket = ${S3BUCKET_NAME}
  region = ${S3BUCKET_REGION}
  key    = ${S3BUCKET_KEY}"

# Make sure we are not re-initialize previous init
[ -d .terraform ] && rm -rf .terraform
terraform init \
    -backend-config="bucket=${S3BUCKET_NAME}" \
    -backend-config="region=${S3BUCKET_REGION}" \
    -backend-config="key=${S3BUCKET_KEY}" \
    -get=true \
    -get-plugins=true \
    -force-copy
