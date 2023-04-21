#!/bin/bash
MYPATH="$(cd "$(dirname "$0")"; pwd)"
. "$MYPATH/../../env.shlib"
showenv
. "${MYPATH}/../../base/env.shlib"
if [[ ! -z "$VERSHLIB" ]] ; then
	    . "${MYPATH}/../../base/$VERSHLIB"
    fi
cd "$MYPATH"
. ./env.shlib
showenv
# This is to be run after a cluster has been created to set Storage Class
#eksctl create cluster --name=$K8SNAME \
#    --node-type="$MTYPE" --nodes-min=$MINNODES --nodes-max=$MAXNODES --managed \
#    --ssh-access --nodegroup-name "$K8SNAME-ng" \
#    --region=$REGION --version=$K8SVER
##    --node-type="$MTYPE" --nodes=$NODESNUM --managed \
if [[ -z "$(k8sobjexist "A" "StorageClass" "$SC")" ]] ; then
    if [[ -f "../../envs/common/StorageClass/$SC.sh" ]] ; then
	bash "../../envs/common/StorageClass/$SC.sh"
    fi
    kubectl apply -f  "../../envs/common/StorageClass/$SC.yaml"
else
    >&2 echo "no need to create the existing Storage Class $SC"
fi
NGARN="$(aws eks describe-nodegroup --cluster-name "$K8SNAME" --nodegroup-name  "$K8SNAME"-ng \
| jq -r '.nodegroup.nodeRole')"
>&2 echo $NGARN
NG="$(echo "$NGARN" | cut -d/ -f2)"
if [[ ! -z "$(aws iam list-attached-role-policies  --role-name "$NG" \
	| jq --arg s "$PARN" '.AttachedPolicies[] | select(.PolicyArn == $s)')" ]] ; then
    >&2 echo no need to re-attached policy "$PARN" to role $NG
else
    >&2 echo to attach "$PARN"
    aws iam attach-role-policy --policy-arn "$PARN" --role-name "$NG"
fi
aws iam list-attached-role-policies  --role-name "$NG"
bash ../../k8s/StorageClass/cleardefault.sh
bash ../../k8s/StorageClass/setdefault.sh "$SC"
