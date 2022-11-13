#!/bin/bash
MYPATH=$(cd $(dirname "$0"); pwd)
cd "${MYPATH}"
. "${MYPATH}/../base/env.shlib"
if [[ ! -z "$VERSHLIB" ]] ; then
    . "${MYPATH}/../base/$VERSHLIB"
fi
#
## doingressrepo
#
doingressrepo() {
    createns "$INGRESS"
    if [[ -z "$(repoexist "$INGRESSREPO")" ]] ; then
        helm repo add "$INGRESSREPO" "$INGRESSURL"
    else
        >&2 echo $INGRESSREPO exists
    fi
    helm repo update
    }

#
## doingresshelm
#
doingresshelm() {
    local _action="$1"
    local _output="$2"
    local _option="$3"

    if [[ -z "$INGRESSDOCKERSECRET" ]] ; then
        >&2 echo Not using Ingress docker registry pull secret
    else
	doPullSecret "$INGRESSDOCKERSECRET" \
    	    "$INGRESSSERVER" "$INGRESSUSERNAME" "$INGRESSPASSWORD" \
            "$INGRESS"
    fi
    if [[ -z "$(relexist "$INGRESS" "$INGRESSREL")" ]] ; then
        if [[ -z "$INGRESSVALUES" ]] ; then
            helm "$_action" "$INGRESSREL" -n "$INGRESS" "$INGRESSREPO/ingress-nginx" \
                --set controller.service.externalTrafficPolicy="Local" \
                --set imagePullSecrets[0].name=docker-hub-reg-pullsecret \
                $INGRESSVER \
		"$_option" > "$_output"
        else
            helm "$_action" "$INGRESSREL" -n "$INGRESS" "$INGRESSREPO/ingress-nginx" \
	    -f "$INGRESSVALUES" \
	    "$INGRESSVER" $_option > "$_output"
        fi
#
#
# Azure internal load balancer option
#
#        --set controller.service.annotations."service\.beta\.kubernetes\.io/azure-load-balancer-internal"="true" \
#
# AWS internal load balancer option
#
#        --set controller.service.annotations."service\.beta\.kubernetes\.io/aws-load-balancer-internal"="true" \
    else
        >&2 echo $INGRESSREL exists
    fi
    }

#
## Starts Here
#
doingressrepo
doingresshelm template "$INGRESSREL.$INGRESS.$$.yaml"
doingresshelm install "$INGRESSREL.$INGRESS.$$.debug" "--debug"
