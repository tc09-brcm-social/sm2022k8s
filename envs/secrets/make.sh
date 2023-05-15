#!/bin/bash
MYPATH=$(cd $(dirname "$0"); pwd)
cd "${MYPATH}"
. ./env.shlib
if [[ -z "$2" ]] ; then
    SRC="$PATCHSRC"
else
    SRC="$2"
fi
if [[ -z "$1" ]] ; then
    FILE="$PATCHDEST"
else
    FILE="$1"
fi
if [[ -z "$FILE" ]] ; then
    >&2 echo "destination file is required"
    exit 1
fi
. "$SRC"

patchenv() {
    if [[ -z "$FILE" ]] ; then
	echo "$1"=\"$2\"
    else
        x=$(bash "$MYPATH/../../tools/setkeyvalue.sh" "$FILE" "$1" "$2" "'")
	>&2 echo "$1"
    fi
    }

LINES="$(grep '^[^# ]*=' "$SRC" | sed 's/=.*$//')"
for i in $LINES ; do
    patchenv "$i" "$(eval 'echo $'$i)"
done
