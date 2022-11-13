#!/bin/bash
MYPATH=$(cd $(dirname "$0"); pwd)
cd "${MYPATH}"
. "${MYPATH}/../base/env.shlib"
if [[ ! -z "$VERSHLIB" ]] ; then
    . "${MYPATH}/../base/$VERSHLIB"
fi
#
## LOGGING
#

#
## doelasticrepo
#
doelasticrepo() {
    createns "$LOGGING"
    if [[ -z "$(repoexist "$ELASTICREPO")" ]] ; then
        helm repo add "$ELASTICREPO" "$ELASTICURL"
    else
        >&2 echo repo $ELASTICREPO exists
    fi
    helm repo update
    }

#
## doelastichelm
#
doelastichelm() {
    local _action="$1"
    local _output="$2"
    local _option="$3"

    if [[ -z "$ELASTICDOCKERSECRET" ]] ; then
        >&2 echo Not using ElasticSearch docker registry pull secret
    else
        doPullSecret "$ELASTICDOCKERSECRET" \
            "$ELASTICSERVER" "$ELASTICUSERNAME" "$ELASTICPASSWORD" \
            "$LOGGING"
    fi
    if [[ -z "$(relexist "$LOGGING" "$ELASTICREL")" ]] ; then
        if [[ -z "$ELASTICVALUES" ]] ; then
            helm "$_action" "$ELASTICREL" -n "$LOGGING" $ELASTICREPO/elasticsearch \
                $ELASTICVER  \
               $_option > "$_output"
        else
            helm "$_action" "$ELASTICREL" -n "$LOGGING" $ELASTICREPO/elasticsearch \
	        -f "$ELASTICVALUES" \
                $ELASTICVER  \
               $_option > "$_output"
        fi
    else
        >&2 echo release $ELASTICREL exits
    fi
}

#
## dokibanahelm
#
dokibanahelm() {
    local _action="$1"
    local _output="$2"
    local _option="$3"

    createtls "${LOGGING}" "$LOGGINGTLS" "$LOGGINGPEM" "$LOGGINGKEY"
    if [[ -z "$KIBANADOCKERSECRET" ]] ; then
        >&2 echo Not using Kibana docker registry pull secret
    else
        doPullSecret "$KIBANADOCKERSECRET" \
            "$KIBANASERVER" "$KIBANAUSERNAME" "$KIBANAPASSWORD" \
            "$LOGGING"
    fi
    if [[ -z "$(relexist "$LOGGING" "$KIBANAREL")" ]] ; then
        if [[ "$KIBANAVER" == "--version 7.9.3" ]] ; then
            if [[ -z "$KIBANAVALUES" ]] ; then
                helm "$_action" "$KIBANAREL" -n "$LOGGING" $ELASTICREPO/kibana \
                    --set ingress.enabled=true \
                    --set "ingress.annotations.kubernetes\.io/ingress\.class"=nginx \
                    --set ingress.hosts[0]="${KIBANANAME}" \
                    --set ingress.tls[0].secretName="${KIBANASECRET}" \
                    --set ingress.tls[0].hosts[0]="${KIBANANAME}" \
                    $KIBANAVER \
                    $_option > "$_output"
            else
                helm "$_action" "$KIBANAREL" -n "$LOGGING" $ELASTICREPO/kibana \
		    -f "$KIBANAVALUES" \
                    $KIBANAVER \
                    $_option > "$_output"
	    fi
        elif [[ "$KIBANAVER" == "--version 7.16.3" ]] ; then
            if [[ -z "$KIBANAVALUES" ]] ; then
                helm "$_action" "$KIBANAREL" -n "$LOGGING" $ELASTICREPO/kibana \
	            --timeout 20m0s \
                    --set ingress.enabled=true \
                    --set "ingress.className"=nginx \
                    --set ingress.hosts[0].host="${KIBANANAME}" \
	            --set ingress.hosts[0].paths[0].path="/" \
                    --set ingress.tls[0].secretName="${KIBANASECRET}" \
                    --set ingress.tls[0].hosts[0]="${KIBANANAME}" \
                    $KIBANAVER \
                    $_option > "$_output"
            else
                helm "$_action" "$KIBANAREL" -n "$LOGGING" $ELASTICREPO/kibana \
		    -f "$KIBANAVALUES" \
	            --timeout 20m0s \
                    $KIBANAVER \
                    $_option > "$_output"
	    fi
        else
            >&2 echo "Unsupported Kibana version $KIBANAVER"
        fi
    else
        >&2 echo release $KIBANAREL exits
    fi
    }

#
## MONITORING
#
#
## doprometheusrepo
#
doprometheusrepo() {
    createns "$MONITORING"
    if [[ -z "$(repoexist "$PROMETHEUSREPO")" ]] ; then
        helm repo add "$PROMETHEUSREPO" "$PROMETHEUSURL"
    else
        >&2 echo repo $PROMETHEUSREPO exists
    fi
    helm repo update
    }
#
## doprometheushelm
#
doprometheushelm() {
    local _action="$1"
    local _output="$2"
    local _option="$3"

    createtls "${MONITORING}" "$MONITORINGTLS" "$MONITORINGPEM" "$MONITORINGKEY"
    if [[ -z "$PROMETHEUSDOCKERSECRET" ]] ; then
        >&2 echo Not using Kibana docker registry pull secret
    else
        doPullSecret "$PROMETHEUSDOCKERSECRET" \
            "$PROMETHEUSSERVER" "$PROMETHEUSUSERNAME" "$PROMETHEUSPASSWORD" \
            "$MONITORING"
    fi
    if [[ -z "$(relexist "$MONITORING" "$PROMETHEUSREL")" ]] ; then
        if [[ -z "$PROMETHEUSVALUES" ]] ; then
            helm "$_action" "$PROMETHEUSREL" -n "$MONITORING" $PROMETHEUSREPO/kube-prometheus-stack \
                --set nameOverride="prometheus-operator" \
                --set prometheus.prometheusSpec.storageSpec.volumeClaimTemplate.spec.accessModes[0]=ReadWriteOnce \
                --set prometheus.prometheusSpec.storageSpec.volumeClaimTemplate.spec.resources.requests.storage=20Gi \
                --set alertmanager.ingress.enabled=true \
                --set "alertmanager.ingress.annotations.kubernetes\.io/ingress\.class"=nginx \
                --set alertmanager.ingress.tls[0].secretName="$ALERTMANAGERSECRET" \
                --set alertmanager.ingress.hosts[0]="$ALERTMANAGERNAME" \
                --set alertmanager.ingress.tls[0].hosts[0]="$ALERTMANAGERNAME" \
                --set grafana.ingress.enabled=true \
                --set "grafana.ingress.annotations.kubernetes\.io/ingress\.class"=nginx \
                --set grafana.ingress.tls[0].secretName="$GRAFANASECRET" \
                --set grafana.ingress.hosts[0]="$GRAFANANAME" \
                --set grafana.ingress.tls[0].hosts[0]="$GRAFANANAME" \
                $PROMETHEUSVER \
                $_option > "$_output"
        else
            helm "$_action" "$PROMETHEUSREL" -n "$MONITORING" $PROMETHEUSREPO/kube-prometheus-stack \
	        -f "$PROMETHEUSVALUES" \
                $PROMETHEUSVER \
                $_option > "$_output"
        fi
    else
        >&2 echo release $PROMETHEUSREL exits
    fi
    }
#
## Starts Here
#
doelasticrepo
doelastichelm template "$ELASTICREL.$LOGGING.$$.yaml"
doelastichelm install "$ELASTICREL.$LOGGING.$$.debug" "--debug"
dokibanahelm template "$KIBANAREL.$LOGGING.$$.yaml"
dokibanahelm install "$KIBANAREL.$LOGGING.$$.debug" "--debug"
doprometheusrepo
doprometheushelm template "$PROMETHEUSREL.$MONITORING.$$.yaml"
doprometheushelm install "$PROMETHEUSREL.$MONITORING.$$.debug" "--debug"
