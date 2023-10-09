#/bin/bash
MYPATH=$(cd $(dirname "$0"); pwd)
cd "${MYPATH}"
. "${MYPATH}/../env.shlib"
    yq -Y --arg u "$SMDOCKERID" --arg p "$SMDOCKERPWD" \
        '.global.registry.credentials.username = $u
        | .global.registry.credentials.password = $p
	'
