#!/bin/bash
MYPATH=$(cd $(dirname "$0"); pwd)
cd "${MYPATH}"
. "${MYPATH}/../base/env.shlib"
if [[ ! -z "$VERSHLIB" ]] ; then
    . "${MYPATH}/../base/$VERSHLIB"
fi
createns "$INGRESS"
if [[ -z "$(repoexist "$INGRESSREPO")" ]] ; then
    helm repo add "$INGRESSREPO" "$INGRESSURL"
else
    >&2 echo $INGRESSREPO exists
fi
helm repo update
if [[ -z "$(relexist "$INGRESS" "$INGRESSREL")" ]] ; then
    helm install "$INGRESSREL" -n "$INGRESS" ingress-nginx/ingress-nginx \
        --set controller.service.externalTrafficPolicy="Local" \
        --set imagePullSecrets[0].name=docker-hub-reg-pullsecret \
        $INGRESSVER \
       --debug > "$INGRESSREL.$INGRESS.$$.debug"
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
