#!/bin/bash
MYPATH=$(cd $(dirname "$0"); pwd)
cd "${MYPATH}"
. "${MYPATH}/../../../base/env.shlib"
if [[ ! -z "$VERSHLIB" ]] ; then
    . "${MYPATH}/../../../base/$VERSHLIB"
fi
if [[ -z "$BKPUPFILE" ]] ; then
    BKPUPFILE="storebackup.xml"
fi
if [[ -z "$BKPUPRETRIES" ]] ; then
    BKPUPRETRIES=3
fi
yq -Y --arg r "$S3REGION" --arg s "$S3URI" \
	--arg i "$S3ID" --arg k "$S3KEY" \
    ' .global.troubleshootingData.enabled = true
    | .global.troubleshootingData.storageType = "awsS3"
    | .global.troubleshootingData.aws.bucketName = $s
    | .global.troubleshootingData.aws.region = $r
    | .global.troubleshootingData.aws.keyID = $i
    | .global.troubleshootingData.aws.accessKey = $k
    '
