#/bin/bash
MYPATH=$(cd $(dirname "$0"); pwd)
cd "${MYPATH}"
. "${MYPATH}/../../base/env.shlib"
if [[ ! -z "$VERSHLIB" ]] ; then
    . "${MYPATH}/../../base/$VERSHLIB"
fi
    if [[ -z "$PROMETHEUSREGISTRYBASE" ]] ; then cat - ; else \
          yq -Y --arg r "$PROMETHEUSREGISTRYBASE" \
              ' .alertmanager.alertmanagerSpec.image.repository = ($r + "/alertmanager")
                | .prometheus.prometheusSpec.image.repository = ($r + "/prometheus")
                | .prometheusOperator.admissionWebhooks.patch.image.repository = ($r + "/kube-webhook-certgen")
		| .prometheusOperator.admissionWebhooks.patch.image.sha = ""
                | .prometheusOperator.image.repository = ($r + "/prometheus-operator")
                | .prometheusOperator.prometheusConfigReloader.image.repository = ($r + "/prometheus-config-reloader")
                | .prometheusOperator.thanosImage.repository = ($r + "/thanos")
		| ."prometheus-node-exporter".image.repository = ($r + "/node-exporter")
		| .grafana.image.repository = ($r + "/grafana")
		| .grafana.testFramework.image = ($r + "/bats")
		| .grafana.sidecar.image.repository = ($r + "/k8s-sidecar")
		| ."kube-state-metrics".image.repository = ($r + "/kube-state-metrics")
              '
      fi \
    | if [[ -z "$PROMETHEUSDOCKERSECRET" ]] ; then cat - ; else \
          yq -Y --arg s "$PROMETHEUSDOCKERSECRET" \
              ' .global.imagePullSecrets[0].name = $s
	      | .grafana.image.pullSecrets[0].name = $s
	      | ."kube-state-metrics".imagePullSecrets[0].name = $s
              '
      fi
#.alertmanager.alertmanagerSpec.image.repository
#.prometheus.prometheusSpec.image.repository
#.prometheusOperator.admissionWebhooks.patch.image.repository
#.prometheusOperator.image.repository
#.prometheusOperator.prometheusConfigReloader.image.repository
#.prometheusOperator.thanosImage.repository
#.global.imagePullSecrets[]
