#!/bin/bash
MYPATH=$(cd $(dirname "$0"); pwd)
cd "${MYPATH}"
. ./env.shlib
# resetroot
resetbase
LINES="$(grep '^[^# ]*=' env.shlib | sed 's/=.*$//')"
for i in $LINES ; do
    if [[ "$i" == "CLOUD" ]] ; then
        envroot "$i" "$(eval 'echo $'$i)"
    elif [[ "$i" == "K8SNAME" ]] ; then
        envroot "$i" "$(eval 'echo $'$i)"
    elif [[ "$i" == "K8SVER" ]] ; then
        envroot "$i" "$(eval 'echo $'$i)"
    else
        envbase "$i" "$(eval 'echo $'$i)"
    fi
done
envbase INGRESSVALUES "$MYPATH/nginx-values.yaml"
envbase ELASTICOPVALUES "$MYPATH/elasticop-values.yaml"
if [ ! -z "$ELASTICSC" ] ; then
    envbase ELASTICSCYAML "$MYPATH/../common/StorageClass/$ELASTICSC".yaml
fi
envbase ELASTICYAML "$MYPATH/elasticsearch.yaml"
envbase KIBANAYAML "$MYPATH/kibana.yaml"
envbase KIBANASVCYAML "$MYPATH/kibanasvc.yaml"
envbase PROMETHEUSOPVALUES "$MYPATH/prometheusop-values.yaml"
if [ ! -z "$PROMETHEUSSC" ] ; then
    envbase PROMETHEUSSCYAML "$MYPATH/../common/StorageClass/$PROMETHEUSSC".yaml
fi
envbase GRAFANAOPVALUES "$MYPATH/grafanaop-values.yaml"
envbase GRAFANADSYAML "$MYPATH/grafanads.yaml"
envbase SSPINFRAVALUES "$MYPATH/ssp-infra-values.yaml"
envbase SSPINFRARTVALUES "$MYPATH/ssp-infra-rt-values.sh"
envbase SSPVALUES "$MYPATH/ssp-values.yaml"
envbase SSPDATAVALUES "$MYPATH/ssp-data-values.yaml"
envbase SAVALUES "$MYPATH/ssp-sample-app-values.yaml"
envbase SARTVALUES "$MYPATH/ssp-sample-app-rt-values.sh"
#bash "$MYPATH/nginx-values.sh" > "$MYPATH/nginx-values.yaml"
bash "$INGRESSVALUES" > "$MYPATH/nginx-values.yaml"
bash "$MYPATH/elasticop-values.sh" > "$MYPATH/elasticop-values.yaml"
bash "$MYPATH/elastic-yaml.sh" > "$MYPATH/elasticsearch.yaml"
bash "$MYPATH/kibana-yaml.sh" > "$MYPATH/kibana.yaml"
bash "$MYPATH/kibanasvc-yaml.sh" > "$MYPATH/kibanasvc.yaml"
bash "$MYPATH/prometheusop-values.sh" > "$MYPATH/prometheusop-values.yaml"
bash "$MYPATH/grafanaop-values.sh" > "$MYPATH/grafanaop-values.yaml"
bash "$MYPATH/grafanads-yaml.sh" > "$MYPATH/grafanads.yaml"
bash "$MYPATH/ssp-infra-values.sh" > "$MYPATH/ssp-infra-values.yaml"
bash "$MYPATH/ssp-values.sh" > "$MYPATH/ssp-values.yaml"
bash "$MYPATH/ssp-data-values.sh" > "$MYPATH/ssp-data-values.yaml"
bash "$MYPATH/ssp-sample-app-values.sh" > "$MYPATH/ssp-sample-app-values.yaml"
