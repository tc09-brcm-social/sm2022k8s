#!/bin/bash
MYPATH=$(cd $(dirname "$0"); pwd)
cd "${MYPATH}/../.."
. ./env.shlib
cd "${MYPATH}"
. "${MYPATH}/../../base/env.shlib"
if [[ ! -z "$VERSHLIB" ]] ; then
    . "${MYPATH}/../../base/$VERSHLIB"
fi
aws s3 ls "$S3URI$1"
