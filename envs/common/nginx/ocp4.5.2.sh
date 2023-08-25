#/bin/bash
MYPATH=$(cd $(dirname "$0"); pwd)
cd "${MYPATH}"
. "${MYPATH}/../../../base/env.shlib"
if [[ ! -z "$VERSHLIB" ]] ; then
    . "${MYPATH}/../../../base/$VERSHLIB"
fi
bash "$MYPATH/ocpuid4.5.2.sh" \
    | bash "$MYPATH/ocpfsG4.5.2.sh"
