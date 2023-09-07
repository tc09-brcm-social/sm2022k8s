#/bin/bash
MYPATH=$(cd $(dirname "$0"); pwd)
cd "${MYPATH}"
. "${MYPATH}/../../../base/env.shlib"
if [[ ! -z "$VERSHLIB" ]] ; then
    . "${MYPATH}/../../../base/$VERSHLIB"
fi
if [[ -z "$(k8sobjexist "openshift-monitoring" configmap cluster-monitoring-config)" ]] ; then
    cat <<EOF | kubectl create -f -
apiVersion: v1
kind: ConfigMap
metadata:
  name: cluster-monitoring-config
  namespace: openshift-monitoring
data:
  config.yaml: |
    enableUserWorkload: true
EOF
fi
SECRET_NAME="$(kubectl get secret -n openshift-user-workload-monitoring \
    | grep  prometheus-user-workload-token | head -n 1 | awk '{print $1 }')"
TOKEN="$(echo $(kubectl get secret $SECRET_NAME -n openshift-user-workload-monitoring -o json \
	| jq -r '.data.token') | base64 -d)"
TOKEN="$(kubectl get secret $SECRET_NAME -n openshift-user-workload-monitoring -o json \
	| jq -r '.data.token' | base64 -d)"
cat <<EOF | kubectl apply -n ${MONITORING} -f -
apiVersion: integreatly.org/v1alpha1
kind: GrafanaDataSource
metadata:
  name: grafana-datasource
spec:
  name: grafana-datasource.yaml
  datasources:
    - name: Prometheus
      type: prometheus
      version: 1
      access: proxy
      editable: true
      isDefault: true
      url: 'https://prometheus-k8s.openshift-monitoring.svc:9091'
      jsonData:
        timeInterval: 5s
        tlsSkipVerify: true
        httpHeaderName1: 'Authorization'
      secureJsonData:
        httpHeaderValue1: "Bearer ${TOKEN}"
EOF
cat <<EOF | kubectl apply -n "${MONITORING}" -f -
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: grafana
spec:
  ingressClassName: nginx
  rules:
    - host: ${GRAFANANAME}
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: grafana-service
                port:
                  number: 3000
  tls:
    - hosts:
      - ${GRAFANANAME}
      secretName: ${MONITORINGTLS}
EOF
