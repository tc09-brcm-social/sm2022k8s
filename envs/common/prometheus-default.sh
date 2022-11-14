#/bin/bash
MYPATH=$(cd $(dirname "$0"); pwd)
cd "${MYPATH}"
. "${MYPATH}/../../base/env.shlib"
if [[ ! -z "$VERSHLIB" ]] ; then
    . "${MYPATH}/../../base/$VERSHLIB"
fi
    yq -Y --arg n "$PROMETHEUSREL" \
	  --arg als "$ALERTMANAGERSECRET" --arg aln "$ALERTMANAGERNAME" \
	  --arg grs "$GRAFANASECRET" --arg grn "$GRAFANANAME" \
        ' .nameOverride = $n
        | .prometheus.prometheusSpec.storageSpec.volumeClaimTemplate.spec.accessModes[0] = "ReadWriteOnce"
        | .prometheus.prometheusSpec.storageSpec.volumeClaimTemplate.spec.resources.requests.storage = "20Gi"
        | .alertmanager.ingress.enabled = true
        | .alertmanager.ingress.annotations = { "kubernetes.io/ingress.class" : "nginx" }
        | .alertmanager.ingress.tls[0].secretName = $als
        | .alertmanager.ingress.hosts[0] = $aln
        | .alertmanager.ingress.tls[0].hosts[0] = $aln
        | .grafana.ingress.enabled = true
        | .grafana.ingress.annotations = { "kubernetes.io/ingress.class" : "nginx" }
        | .grafana.ingress.tls[0].secretName = $grs
        | .grafana.ingress.hosts[0] = $grn
        | .grafana.ingress.tls[0].hosts[0] = $grn
        '
