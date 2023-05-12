#/bin/bash
MYPATH=$(cd $(dirname "$0"); pwd)
cd "${MYPATH}"
. "${MYPATH}/../../../base/env.shlib"
if [[ ! -z "$VERSHLIB" ]] ; then
    . "${MYPATH}/../../../base/$VERSHLIB"
fi
>&2 echo bash "$MYPATH/values.sh" "$SMVERNEW"
bash "$MYPATH/values.sh" "$SMVERNEW"
