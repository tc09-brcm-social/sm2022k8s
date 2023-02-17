#!/bin/bash
MYPATH=$(cd $(dirname "$0"); pwd)
cd "${MYPATH}"
. ./env.shlib
FILE="$1"
patchenv() {
    if [[ -z "$FILE" ]] ; then
	echo "$1"=\"$2\"
    else
        x=$(bash "$MYPATH/../../tools/setkeyvalue.sh" "$FILE" "$1" "$2" "'")
        >&2 echo $1
    fi
    }

LINES="$(grep '^[^# ]*=' env.shlib | sed 's/=.*$//')"
for i in $LINES ; do
    patchenv "$i" "$(eval 'echo $'$i)"
done
