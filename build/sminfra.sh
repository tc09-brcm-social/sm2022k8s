#!/bin/bash
MYPATH=$(cd $(dirname "$0"); pwd)
cd "${MYPATH}"
. "${MYPATH}/../base/env.shlib"
if [[ ! -z "$VERSHLIB" ]] ; then
    . "${MYPATH}/../base/$VERSHLIB"
fi

#
## dosmrepo
#
dosmrepo() {
    if [[ -z "$(repoexist "$SMREPO")" ]] ; then
        bash "${MYPATH}/../base/smrepo.sh"
    else
        >&2 echo $SMREPO exists
    fi
    }

#
## Deploy Prometheus adapter from SiteMinder Infra chart
#
#
## doproadp
#
doproadp() {
    local _action="$1"
    local _output="$2"
    local _option="$3"

    createns "$PROADPNS"
    if [[ -z "$PROADPDOCKERSECRET" ]] ; then
	>&2 echo Not using PROADP docker registry pull secret
    else
        doPullSecret "$PROADPDOCKERSECRET" \
            "$PROADPSERVER" "$PROADPUSERNAME" "$PROADPPASSWORD" \
            "$PROADPNS"
    fi
    if [[ -z "$(relexist "$PROADPNS" "$PROADPREL")" ]] ; then
        if [[ -z "$PROADPVALUES" ]] ; then
            helm "$_action" "$PROADPREL" $SMREPO/siteminder-infra -n ${PROADPNS} \
                --set prometheus-adapter.enabled=true \
                --set fluent-bit.enabled=false \
	        $SMVER \
                $_option > "$_output"
        else
            helm "$_action" "$PROADPREL" $SMREPO/siteminder-infra -n ${PROADPNS} \
	        -f "$PROADPVALUES" \
	        $SMVER \
                $_option > "$_output"
        fi
# kubectl get pods -n ${PROMETHEUS_ADAPTER_NAMESPACE}
# kubectl describe pod <PROMETHEUS-ADAPTER-POD-NAME> -n ${PROMETHEUS_ADAPTER_NAMESPACE}
    else
        >&2 echo release $PROADPREL exists, attempt to upgrade
        helm upgrade --install "$PROADPREL" $SMREPO/siteminder-infra -n ${PROADPNS} \
           --set prometheus-adapter.enabled=true \
           --set fluent-bit.enabled=false $SMVER \
           $_option > "$_output"
    fi
    }

#
## Deploy Fluent Bit from SiteMinder Infra chart
#
#
## dosminfra
#
dosminfra() {
    local _action="$1"
    local _output="$2"
    local _option="$3"

    createns "$SMINFRANS"
    if [[ -z "$SMINFRADOCKERSECRET" ]] ; then
	>&2 echo Not using SMINFRA docker registry pull secret
    else
        doPullSecret "$SMINFRADOCKERSECRET" \
            "$SMINFRASERVER" "$SMINFRAUSERNAME" "$SMINFRAPASSWORD" \
            "$SMINFRANS"
    fi
    if [[ -z "$(relexist "$SMINFRANS" "$SMINFRAREL")" ]] ; then
        if [[ -z "$SMINFRAVALUES" ]] ; then
            helm "$_action" "$SMINFRAREL" $SMREPO/siteminder-infra -n ${SMINFRANS} \
                --set prometheus-adapter.enabled=false \
                --set fluent-bit.enabled=true \
	        --set ssoReleaseName=${SSORELEASENAME} \
	        $SMVER \
	        $_option > "$_output"
        else
            cat "$SMINFRAVALUES" \
                | if [[ -z "$SMINFRARTVALUES" ]] ; then cat - ; else \
                      bash "$SMINFRARTVALUES"
                  fi \
                | helm "$_action" "$SMINFRAREL" $SMREPO/siteminder-infra -n ${SMINFRANS} \
	              -f - \
	              $SMVER \
	              $_option > "$_output"
        fi
#helm ls -n ${PSNS}
#kubectl get all -n ${PSNS}
#kubectl describe pod <SITEMINDER-INFRA-POD-NAME> -n ${PSNS}
    else
        >&2 echo release $SMINFRAREL exists, attempt to upgrade
        helm upgrade --install "$SMINFRAREL" $SMREPO/siteminder-infra -n ${SMINFRANS} \
            --set fluent-bit.enabled=true --set ssoReleaseName=${SSORELEASENAME} \
            --set prometheus-adapter.enabled=false $SMVER \
	    $_option > "$_output"
    fi
    }
#
## Starts Here
#
dosmrepo
doproadp template "$PROADPREL.$PROADPNS.$$.yaml"
doproadp install "$PROADPREL.$PROADPNS.$$.debug" "--debug"
dosminfra template "$SMINFRAREL.$SMINFRANS.$$.yaml"
dosminfra install "$SMINFRAREL.$SMINFRANS.$$.debug" "--debug"
