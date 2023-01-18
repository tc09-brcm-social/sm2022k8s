#!/bin/bash
MYPATH=$(cd $(dirname "$0"); pwd)
cd "${MYPATH}"
. "${MYPATH}/../base/env.shlib"
if [[ ! -z "$VERSHLIB" ]] ; then
    . "${MYPATH}/../base/$VERSHLIB"
fi

FILE="$1"

if [[ -z "$FILE" ]] ; then
    bash "$MYPATH"/../build/hosts.sh | sed 's/,/ /'
else
    bash "$MYPATH"/../build/hosts.sh | sed 's/,/ /' \
	| sudo sh -c "cat - >> \"$FILE\""
fi
