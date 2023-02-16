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
#envbase INGRESSVALUES "$MYPATH/nginx-values.yaml"
envbase PSVALUES "$MYPATH/ps-values.yaml"
envbase AGVALUES "$MYPATH/ag-values.yaml"
envbase PROADPVALUES "$MYPATH/proadp-values.yaml"
envbase SMINFRAVALUES "$MYPATH/sminfra-values.yaml"
envbase SMINFRARTVALUES "$MYPATH/sminfra-rt-values.sh"
#bash "$MYPATH/nginx-values.sh" > "$MYPATH/nginx-values.yaml"
bash "$MYPATH/ps-values.sh" > "$MYPATH/ps-values.yaml"
bash "$MYPATH/ag-values.sh" > "$MYPATH/ag-values.yaml"
bash "$MYPATH/proadp-values.sh" > "$MYPATH/proadp-values.yaml"
bash "$MYPATH/sminfra-values.sh" > "$MYPATH/sminfra-values.yaml"
