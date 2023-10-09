#!/bin/bash
MYPATH=$(cd $(dirname "$0"); pwd)
cd "${MYPATH}"
. "${MYPATH}/../env.shlib"
yq -Y --arg s "$LDAP" --arg r "$RDN" --arg b "$BDN" --arg p "$(b64enc "$BPASS")" \
    '.global.policyStore.type = "ldap"
    | .global.policyStore.service = $s
    | .global.policyStore.userPassword = $p
    | .global.policyStore.ldap.type = "cadir"
    | .global.policyStore.ldap.rootDN = $r
    | .global.policyStore.ldap.userDN = $b
    | .global.stores.keyStore.embedded = "YES"
    '
