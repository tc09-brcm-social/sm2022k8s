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
yq -Y --arg s "$BKPUPFILE" --argjson c "$BKPUPRETRIES"  \
    ' .maintenance.enabled = true
    | .maintenance.operation.name = "XPSExport"
    | .maintenance.operation.args = ( $s + " -xb -npass" )
    | .maintenance.job.restartPolicy = "Never"
    | .maintenance.job.backOffLimit = $c
    | .maintenance.operation.input_file = ""
    '
