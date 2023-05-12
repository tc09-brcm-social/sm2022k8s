#!/bin/bash
MYPATH=$(cd $(dirname "$0"); pwd)
cd "${MYPATH}/../.."
. ./env.shlib
cd "${MYPATH}"
. "${MYPATH}/../../base/env.shlib"
if [[ ! -z "$VERSHLIB" ]] ; then
    . "${MYPATH}/../../base/$VERSHLIB"
fi

if [[ -z "$(repoexist "$SMREPO")" ]] ; then
    bash "${MYPATH}/../base/smrepo.sh"
else
    >&2 echo $SMREPO exists
fi
cd "${MYPATH}"
if [[ -f "./env.shlib" ]]; then
    . ./env.shlib
fi
ROLLBACK="$1"
if [[ -z "$ROLLBACK" ]] ; then
    >&2 echo "Required revision number not specified, existing ..."
    exit 1
fi
helm rollback "$PSREL" "$ROLLBACK" -n "$PSNS"
