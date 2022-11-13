#!/bin/bash
MYPATH=$(cd $(dirname "$0"); pwd)
cd "$MYPATH"
. ./env.shlib
#resetbase
#setenvs
cd "${MYPATH}/../.."
. ./env.shlib
. "${MYPATH}/../../base/env.shlib"
if [[ ! -z "$VERSHLIB" ]] ; then
    . "${MYPATH}/../../base/$VERSHLIB"
fi
cd "${MYPATH}"
# . ./env.shlib
VALUESPATH="$MYPATH/../../envs"
nginx() {
    VALUES="nginx.$$.values.yaml"
    K8S="nginx.$$.k8s.yaml"
    bash "$VALUESPATH"/common/nginx-registry.sh \
	| bash "$VALUESPATH"/common/nginx-default.sh > "$VALUES"
    helm template "$INGRESSREL" -n "$INGRESS" "$INGRESSREPO/ingress-nginx" \
        -f "$INGRESSVALUES" $INGRESSVER | tee "$K8S" | grep 'image:'
    }

elastic() {
    VALUES="elastic.$$.values.yaml"
    K8S="elastic.$$.k8s.yaml"
    bash "$VALUESPATH"/common/elastic-registry.sh \
	> "$VALUES"
    helm template "$ELASTICREL" -n "$LOGGING" $ELASTICREPO/elasticsearch \
        -f "$VALUES" $ELASTICVER | tee "$K8S" | grep 'image:'
    VALUES="kibana.$$.values.yaml"
    K8S="kibana.$$.k8s.yaml"
    bash "$VALUESPATH"/common/kibana-values.sh \
        > "$VALUES"
    bash "$VALUESPATH"/common/kibana-registry.sh \
        | bash "$VALUESPATH"/common/kibana-default.sh > "$VALUES"
# Bug?	| yq -Y 'del(.updateStrategy)'  \
# coalesce.go:175: warning: skipped value for elasticsearch.updateStrategy: Not a table.
    helm template "$ELASTICREL" -n "$LOGGING" $ELASTICREPO/elasticsearch \
        -f "$VALUES" $ELASTICVER| tee "$K8S" | grep 'image:'
}

prometheus() {
    VALUES="prometheus.$$.values.yaml"
    K8S="prometheus.$$.k8s.yaml"
    bash "$VALUESPATH"/common/prometheus-registry.sh \
        | bash "$VALUESPATH"/common/prometheus-default.sh > "$VALUES"
    helm template "$PROMETHEUSREL" -n "$MONITORING" $PROMETHEUSREPO/kube-prometheus-stack \
        -f "$VALUES" $PROMETHEUSVER| tee "$K8S" | grep 'image:'
#
## The following are manual fix as they do not appear under regular image:
#
    echo -n "image: "
    grep thanos-default-base-image= "$K8S" | cut -d= -f2
    echo -n "image: "
    grep rometheus-config-reloader= "$K8S" | cut -d= -f2
}

sminfra() {
    VALUES="proadp.$$.values.yaml"
    K8S="proadp.$$.k8s.yaml"
    bash "$VALUESPATH"/common/sminfra-registry.sh \
        | bash "$VALUESPATH"/common/proadp-default.sh > "$VALUES"
    helm template "$PROADPREL" $SMREPO/siteminder-infra -n ${PROADPNS} \
        -f "$VALUES" $SMVER| tee "$K8S" | grep 'image:'
    VALUES="fluent.$$.values.yaml"
    K8S="fluent.$$.k8s.yaml"
    bash "$VALUESPATH"/common/sminfra-registry.sh \
        | bash "$VALUESPATH"/common/fluent-default.sh > "$VALUES"
    helm template "$SMINFRAREL" $SMREPO/siteminder-infra -n ${SMINFRANS} \
        -f "$VALUES" $SMVER| tee "$K8S" | grep 'image:'
    }

nginx
elastic
prometheus
sminfra
