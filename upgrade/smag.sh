#!/bin/bash
MYPATH=$(cd $(dirname "$0"); pwd)
. "${MYPATH}/../base/env.shlib"
if [[ ! -z "$VERSHLIB" ]] ; then
    . "${MYPATH}/../base/$VERSHLIB"
fi

if [[ -z "$(repoexist "$SMREPO")" ]] ; then
    bash "${MYPATH}/../base/smrepo.sh"
else
    >&2 echo $SMREPO exists
fi
cd "${MYPATH}"
. ./env.shlib

#
## agrelpreq
#
agrelpreq() {
    local _ver="$1"
    local _newver="$2"

    if [[ -z "$_newver" ]] ; then
	>&2 echo upgrade to version not specified
	echo 1
    else
        bash "${MYPATH}/ag/values.sh"  > "$AGVALUES"
	helm search repo "$SMREPO" --versions -o json \
	    | jq '[.[] | select(.name == "'$SMREPO/access-gateway'")]' \
	    > "$HELMSEARCH"
	tag="$(jq -r '.[] | select(.version == "'$_ver'") | .app_version' "$HELMSEARCH")"
	newtag="$(jq -r '.[] | select(.version == "'$_newver'") | .app_version' "$HELMSEARCH")"
	envbase SMTAG "$tag"
	envbase SMNEWTAG "$newtag"
	tag0="$(yq -r '.images.accessGateway.tag' "$AGVALUES")"
	if [[ "$tag" = "$tag0" ]] ; then
	    echo 0
	else
	    >&2 echo runtime version $tag0 does not match with environment version $tag
	    echo 1
	fi
    fi
    }

#
## Start Here
#

createns "$AGNS"

#
## Upgrade SiteMinder Access Gateway chart
#
if [[ -z "$(relexist "$AGNS" "$AGREL")" ]] ; then
    >&2 echo SiteMinder Access Gateway release $AGREL is not installed in namespace $AGNS
else
    AGVALUES="$MYPATH/ag.$$.values.yaml"
    HELMSEARCH="$MYPATH/ag.$SMREPO.$$.json"
    if [ "$(agrelpreq "$(echo "$SMVER" | cut -f2 -d=)" \
	    "$(echo "$SMVERNEW" | cut -f2 -d=)")" -eq 0 ] ; then
        AGS="$(yq -r '.sso.accessGateway.replicas' "$AGVALUES")"
	AGR="$(bash "$MYPATH/../op/ag/pods.sh" | jq 'length')"
	>&2 echo $AGS $AGR
	cat "$AGVALUES" | bash "$MYPATH/../envs/common/ag/upgradeag1.sh" > "$AGVALUES".0
	bash "$MYPATH/../envs/common/ag/newvalues.sh" > "$AGVALUES".1
	if [[ "$ADMINENABLED" = "true" ]] ; then
	    helm upgrade "$AGREL" "$SMREPO/access-gateway" -n "$AGNS" \
	        -f "$AGVALUES".1 -f "$AGVALUES".0 $SMVERNEW \
	        --description="upgrade access gateway pod to $SMVERNEW" \
	        --timeout=30m --wait --debug > "$AGVALUES".debug
        else
	    echo helm upgrade "$AGREL" "$SMREPO/access-gateway" -n "$AGNS" \
	        -f "$AGVALUES".1 -f "$AGVALUES".0 $SMVERNEW \
	        --description="upgrade access gateway pod to $SMVERNEW" \
	        --timeout=30m --wait --debug > "$AGVALUES".debug
           >&2 echo "access gateway is not enabled"
        fi
    else
	>&2 echo pre-req check failed
    fi
fi
