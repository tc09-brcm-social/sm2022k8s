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
    local _key="$2"
    local _value

    _value="$(kubectl get secret \
        "${SSPRELEASE}-ssp-secret-$_key" -n ${SSP} \
       	-o jsonpath="{.data.clientId}" | base64 --decode; echo)"
    echo "pm.environment.set(\"${_name}ID\", \"$_value\");"
    _value="$(kubectl get secret \
        "${SSPRELEASE}-ssp-secret-$_key" -n ${SSP} \
       	-o jsonpath="{.data.clientSecret}" | base64 --decode; echo)"
    echo "pm.environment.set(\"${_name}Secret\", \"$_value\");"
    }

ahcurlenv() {
    x=$(bash "$MYPATH/setkeyvalue.sh" $FILE ${C} \
        "$(kubectl get secret "${RELEASE}-ssp-secret-${S}" \
                -n "${NAMESPACE}" \
		-o jsonpath="{.data.${D}}" | base64 --decode)")
    echo $C
    }
#
## Start Here
#
FILE="$1"

(NAMESPACE="$SSP"; RELEASE="$SSPRELEASE"; \
    for a in "defaultTenantClientID defaultTenantClientSecret defaulttenantclient" \
	     "infraClientID infraClientSecret infraclient" \
	     "systemClientID systemClientSecret systemclient" \
	     "clientId clientSecret democlient"; do
	read CI CS S < <(echo "$a")
       	for b in "${CI} clientId" "${CS} clientSecret"; do
	    read C D < <(echo "$b")
	    ahcurlenv
        done
    done)
exit
penv defaultClient defaulttenantclient
penv infraClient infraclient
penv systemClient systemclient
penv demoClient democlient
exit

penv "clientId" \
    $(kubectl get secret ${SSP}-ssp-secret-democlient -n ${SSP} -o jsonpath="{.data.clientId}" | base64 --decode; echo)
penv "clientSecret" \
    $(kubectl get secret ${SSP}-ssp-secret-democlient -n ${SSP} -o jsonpath="{.data.clientSecret}" | base64 --decode; echo)
penv "defaultTenantClientID" \
    $(kubectl get secret ${SSP}-ssp-secret-defaulttenantclient -n ${SSP} -o jsonpath="{.data.clientId}" | base64 --decode; echo)
penv "defaultTenantClientSecret" \
    $(kubectl get secret ${SSP}-ssp-secret-defaulttenantclient -n ${SSP} -o jsonpath="{.data.clientSecret}" | base64 --decode; echo)
