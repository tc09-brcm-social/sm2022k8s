#!/bin/bash
MYPATH=$(cd $(dirname "$0"); pwd)
cd "${MYPATH}"
. "${MYPATH}/../base/env.shlib"
if [[ ! -z "$VERSHLIB" ]] ; then
    . "${MYPATH}/../base/$VERSHLIB"
fi

#
## penv
#
penv() {
    local _name="$1"
    local _value="$2"
    if [[ -z "$FILE" ]] ; then
        echo $_name=\"$_value\"
    else
        x=$(bash "$MYPATH/setkeyvalue.sh" $FILE "$_name" "$_value")
        >&2 echo $_name
    fi
    }
#
## Start Here
#
FILE="$1"

penv PSNS "$PSNS"
penv PSREL "$PSREL"
penv SPSACO "$AGACO"
penv HCO "$AGHCO"
