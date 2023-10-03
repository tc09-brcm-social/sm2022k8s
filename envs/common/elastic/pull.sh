#/bin/bash
MYPATH=$(cd $(dirname "$0"); pwd)
cd "${MYPATH}"
. "${MYPATH}/../../../base/env.shlib"
if [[ ! -z "$VERSHLIB" ]] ; then
    . "${MYPATH}/../../../base/$VERSHLIB"
fi
if [[ ! -z "$1" ]] ; then
    ELASTICOPVER="$1"
fi
helm pull $ELASTICREPO/$ELASTICOPCHART $ELASTICOPVER
