#!/bin/bash
MYPATH=$(cd $(dirname "$0"); pwd)
cd "${MYPATH}"
. "${MYPATH}/../env.shlib"
yq -Y --arg m "$(b64enc "$MKEY")" --arg p "$(b64enc "$SPASS")" --arg e "$(b64enc "$EKEY")" \
    '.global.masterKeySeed = $m
    | .global.superuserPassword= $p
    | .global.encryptionKey = $e
    | .global.fipsMode = "COMPAT"
    '
