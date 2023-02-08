#!/bin/bash
MYPATH=$(cd $(dirname "$0"); pwd)
cd "${MYPATH}/../.."
. ./env.shlib
cd "${MYPATH}"
. "${MYPATH}/../../base/env.shlib"
if [[ ! -z "$VERSHLIB" ]] ; then
    . "${MYPATH}/../../base/$VERSHLIB"
fi
VALUES="$MYPATH/ps.$$.yaml"
bash "$MYPATH/values.sh" > "$VALUES"
bash "$MYPATH/../../tools/attrs.sh" "$VALUES" | grep '\.tag$' > "$VALUES".tags
for i in $(cat "$VALUES".tags) ; do
    echo "$i: $(yq -r "$i" "$VALUES")"
done
