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
createns "$LOGGING"
if [[ -z "$(repoexist "$ELASTICREPO")" ]] ; then
    helm repo add "$ELASTICREPO" "$ELASTICURL"
else
    >&2 echo repo $ELASTICREPO exists
fi
helm repo update
if [[ -z "$(relexist "$LOGGING" "$ELASTICREL")" ]] ; then
    helm install "$ELASTICREL" -n "$LOGGING" elastic/elasticsearch \
        $ELASTICVER  \
       --debug > "$ELASTICREL.$LOGGING.$$.debug"
#	--set replicas=1 --set minimumMasterNodes=1 \
else
    >&2 echo release $ELASTICREL exits
fi
createtls "${LOGGING}" "$LOGGINGTLS" "$LOGGINGPEM" "$LOGGINGKEY"
if [[ -z "$(relexist "$LOGGING" "$KIBANAREL")" ]] ; then
    if [[ "$KIBANAVER" == "--version 7.9.3" ]] ; then
        helm install "$KIBANAREL" -n "$LOGGING" elastic/kibana \
            --set ingress.enabled=true \
            --set "ingress.annotations.kubernetes\.io/ingress\.class"=nginx \
            --set ingress.hosts[0]="${KIBANANAME}" \
            --set ingress.tls[0].secretName="${KIBANASECRET}" \
            --set ingress.tls[0].hosts[0]="${KIBANANAME}" \
            $KIBANAVER \
            --debug > "$KIBANAREL.$LOGGING.$$.debug"
    elif [[ "$KIBANAVER" == "--version 7.16.3" ]] ; then
        helm install "$KIBANAREL" -n "$LOGGING" elastic/kibana \
	    --timeout 20m0s \
            --set ingress.enabled=true \
            --set "ingress.className"=nginx \
            --set ingress.hosts[0].host="${KIBANANAME}" \
	    --set ingress.hosts[0].paths[0].path="/" \
            --set ingress.tls[0].secretName="${KIBANASECRET}" \
            --set ingress.tls[0].hosts[0]="${KIBANANAME}" \
            $KIBANAVER \
            --debug > "$KIBANAREL.$LOGGING.$$.debug"
    else
        >&2 echo "Unsupported Kibana version $KIBANAVER"
    fi
else
    >&2 echo release $KIBANAREL exits
fi
#
## MONITORING
#
createns "$MONITORING"
if [[ -z "$(repoexist "$PROMETHEUSREPO")" ]] ; then
    helm repo add "$PROMETHEUSREPO" "$PROMETHEUSURL"
else
    >&2 echo repo $PROMETHEUSREPO exists
fi
helm repo update
createtls "${MONITORING}" "$MONITORINGTLS" "$MONITORINGPEM" "$MONITORINGKEY"
if [[ -z "$(relexist "$MONITORING" "$PROMETHEUSREL")" ]] ; then
    helm install "$PROMETHEUSREL" -n "$MONITORING" prometheus-community/kube-prometheus-stack \
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
        --debug > "$PROMETHEUSREL.$MONITORING.$$.debug"
else
    >&2 echo release $PROMETHEUSREL exits
fi
