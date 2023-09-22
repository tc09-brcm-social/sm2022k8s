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
## doelasticophelm
#
doelasticophelm() {
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
    if [[ -z "$(relexist "$LOGGING" "$ELASTICOPREL")" ]] ; then
        if [[ -z "$ELASTICOPVALUES" ]] ; then
            helm "$_action" "$ELASTICOPREL" -n "$LOGGING" $ELASTICREPO/$ELASTICOPCHART \
                $ELASTICOPVER  \
               $_option > "$_output"
        else
            helm "$_action" "$ELASTICOPREL" -n "$LOGGING" $ELASTICREPO/$ELASTICOPCHART \
	        -f "$ELASTICOPVALUES" \
                $ELASTICOPVER  \
               $_option > "$_output"
        fi
    else
        >&2 echo release $ELASTICOPREL exits
    fi
}
#
## dostorageclass
#
dostorageclass() {
    local _scyaml="$1"

    if [[ -z "$_scyaml" ]] ; then
        >&2 echo "not doing custom storage class"
    else
	scname="$(cat "$_scyaml" | yq -r '.metadata.name')"
	if [[ -z "$(k8sobjexist "" StorageClass "$scname")" ]] ; then
	    kubectl apply -f "$_scyaml"
	    bash "$MYPATH/../k8s/StorageClass/cleardefault.sh"
	    bash "$MYPATH/../k8s/StorageClass/setdefault.sh" "$scname"
        else
            >&2 echo StorageClass $scname exists
	fi
    fi
    }
#
## doelastick8s
#
doelastick8s() {
    local _output="$1"
    local _option="$2"

    dostorageclass "$ELASTICSCYAML"
    if [[ -z "$(k8sobjexist "$LOGGING" Elasticsearch elasticsearch)" ]] ; then
        if [[ -z "$ELASTICYAML" ]] ; then
	    ELASTICYAML="${MYPATH}/../base/elasticsearch.yaml"
	fi
	if [[ ! -z "$KIBANADEFUSERSECRET" ]] ; then
            if [[ -z "$(k8sobjexist "$LOGGING" secret "$KIBANADEFUSERSECRET")" ]] ; then
		kubectl create secret generic "$KIBANADEFUSERSECRET"  -n "$LOGGING" \
                    --from-literal roles=superuser \
                    --from-literal username="$KIBANADEFUSERNAME" \
                    --from-literal password="$KIBANADEFUSERPWD"
            else
		>&2 echo Kibana default user secret $KIBANADEFUSERSECRET exists
	    fi
	fi
        cat "$ELASTICYAML" \
	    | if [[ -z "$KIBANADEFUSERSECRET" ]] ; then cat - ; else \
		  yq -Y --arg s "$KIBANADEFUSERSECRET" \
	              '.spec.auth.fileRealm[0].secretName = $s'
	      fi \
	    | yq -Y --arg n "$LOGGING" \
		    --arg v "$(echo "$ELASTICVER" | cut -f2 -d=)" \
		    '.metadata.namespace = $n
		    | .spec.version = $v ' \
	    | tee $$.elasticsearch.yaml \
            | kubectl apply -f - $_option > "$_output"
    else
        >&2 echo Elasticsearch elasticsearch exits
    fi
}
#
## dokibanak8s
#
dokibanak8s() {
    local _output="$1"
    local _option="$2"

    createtls "${LOGGING}" "$LOGGINGTLS" "$LOGGINGPEM" "$LOGGINGKEY"
    if [[ -z "$KIBANADOCKERSECRET" ]] ; then
        >&2 echo Not using Kibana docker registry pull secret
    else
        doPullSecret "$KIBANADOCKERSECRET" \
            "$KIBANASERVER" "$KIBANAUSERNAME" "$KIBANAPASSWORD" \
            "$LOGGING"
    fi
    if [[ -z "$(k8sobjexist "$LOGGING" Kibana kibana)" ]] ; then
        if [[ -z "$KIBANAYAML" ]] ; then
	    KIBANAYAML="${MYPATH}/../base/kibana.yaml"
	fi
            cat "$KIBANAYAML" \
                | yq -Y --arg n "$LOGGING" \
		     --arg v "$(echo "$ELASTICVER" | cut -f2 -d=)" \
		     --arg d "$KIBANANAME" \
		      '.metadata.namespace = $n
		      | .spec.version = $v
		      | .spec.http.tls.selfSignedCertificate.subjectAltNames[0].dns = $d
		      ' \
		| tee $$.kibana.yaml \
                | kubectl apply -f - $_option > "$_output"
    else
        >&2 echo Kibana kibana exits
    fi
    if [[ -z "$(k8sobjexist "$LOGGING" Ingress kibana)" ]] ; then
        if [[ -z "$KIBANASVCYAML" ]] ; then
	    KIBANASVCYAML="${MYPATH}/../base/kibanasvc.yaml"
	fi
            cat "$KIBANASVCYAML" \
	        | yq -Y --arg n "$LOGGING" --arg s "$LOGGINGTLS" \
		     --arg d "$KIBANANAME" \
		      '.metadata.namespace = $n
                       | .spec.rules[0].host = $d
		       | .spec.tls[0].hosts[0] = $d
		       | .spec.tls[0].secretName = $s ' \
		| tee $$.kibanasvc.yaml \
                | kubectl apply -f - $_option > "$_output"
    else
        >&2 echo Ingress kibana exits
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
## doprometheusophelm
#
doprometheusophelm() {
    local _action="$1"
    local _output="$2"
    local _option="$3"

    createtls "${MONITORING}" "$MONITORINGTLS" "$MONITORINGPEM" "$MONITORINGKEY"
    if [[ -z "$PROMETHEUSDOCKERSECRET" ]] ; then
        >&2 echo Not using Prometheus docker registry pull secret
    else
        doPullSecret "$PROMETHEUSDOCKERSECRET" \
            "$PROMETHEUSSERVER" "$PROMETHEUSUSERNAME" "$PROMETHEUSPASSWORD" \
            "$MONITORING"
    fi
    dostorageclass "$PROMETHEUSSCYAML"
    if [[ -z "$(relexist "$MONITORING" "$PROMETHEUSREL")" ]] ; then
            helm "$_action" "$PROMETHEUSREL" -n "$MONITORING" $PROMETHEUSREPO/kube-prometheus \
	        -f "$PROMETHEUSOPVALUES" \
                $PROMETHEUSVER \
                $_option > "$_output"
    else
        >&2 echo release $PROMETHEUSREL exits
    fi
    }
#
## dografanaophelm
#
dografanaophelm() {
    local _action="$1"
    local _output="$2"
    local _option="$3"

    createns "$MONITORING"
    createtls "${MONITORING}" "$MONITORINGTLS" "$MONITORINGPEM" "$MONITORINGKEY"
    if [[ -z "$PROMETHEUSDOCKERSECRET" ]] ; then
        >&2 echo Not using Prometheus docker registry pull secret
    else
        doPullSecret "$PROMETHEUSDOCKERSECRET" \
            "$PROMETHEUSSERVER" "$PROMETHEUSUSERNAME" "$PROMETHEUSPASSWORD" \
            "$MONITORING"
    fi
    if [[ -z "$(relexist "$MONITORING" "$GRAFANAREL")" ]] ; then
        cat "$GRAFANAOPVALUES" \
        | if [[ -z "$GRAFANAOPRTVALUES" ]] ; then cat - ; else \
              bash "$GRAFANAOPRTVALUES"
          fi \
        | tee $$.grafanaop.yaml \
        | helm "$_action" "$GRAFANAREL" -n "$MONITORING" $PROMETHEUSREPO/$GRAFANACHART \
	      -f - \
              $GRAFANAVER \
              $_option > "$_output"
    else
        >&2 echo release $GRAFANAREL exits
    fi
    }
#
## dografanadsk8s
#
dografanadsk8s() {
    local _output="$1"
    local _option="$2"

    if [[ -z "$(k8sobjexist "$MONITORING" GrafanaDataSource grafana-datasource)" ]] ; then
	# OCP or not
        if [[ ! -z "$GRAFANADSOCP" ]] ; then
	    bash "$GRAFANADSOCP"
        else
            if [[ ! -z "$GRAFANADSYAML" ]] ; then
                cat "$GRAFANADSYAML" \
                    | yq -Y --arg n "$MONITORING" \
		      '.metadata.namespace = $n
		      ' \
                    | kubectl apply -n "$MONITORING" -f - $_option > "$_output"
	    else
                >&2 echo env.shlib issue, unable to create GrafanaDataSource grafana-datasource exits
	    fi
        fi
    else
        >&2 echo GrafanaDataSource grafana-datasource exits
    fi
    }

#
## Starts Here
#

#
## Deploy Elasticsearch and Kibana for Logging
#
doelasticrepo
doelasticophelm template "$ELASTICOPREL.$LOGGING.$$.yaml"
doelasticophelm install "$ELASTICOPREL.$LOGGING.$$.debug" "--debug"
doelastick8s "$ELASTICREL.$LOGGING.$$.debug"
dokibanak8s "$KIBANAREL.$LOGGING.$$.debug"
doprometheusrepo
if [[ ! -z "$PROMETHEUSCHART" ]] ; then
    doprometheusophelm template "$PROMETHEUSREL.$MONITORING.$$.yaml"
    doprometheusophelm install "$PROMETHEUSREL.$MONITORING.$$.debug" "--debug"
fi
dografanaophelm template "$GRAFANAREL.$MONITORING.$$.yaml"
dografanaophelm install "$GRAFANAREL.$MONITORING.$$.debug" "--debug"
dografanadsk8s "grafanads.$MONITORING.$$.debug"
