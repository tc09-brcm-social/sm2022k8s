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
## psrelpreq
#
psrelpreq() {
    local _ver="$1"
    local _newver="$2"

    if [[ -z "$_newver" ]] ; then
	>&2 echo upgrade to version not specified
	echo 1
    else
        bash "${MYPATH}/../envs/common/sc/rtvalues.sh"  > "$PSVALUES"
	helm search repo "$SMREPO" --versions -o json \
	    | jq '[.[] | select(.name == "'$SMREPO/server-components'")]' \
	    > "$HELMSEARCH"
	pstag="$(yq -r '.policyServer.tag' "$PSVALUES")"
	tag="$(jq -r '.[] | select(.version == "'$_ver'") | .app_version' "$HELMSEARCH")"
	newtag="$(jq -r '.[] | select(.version == "'$_newver'") | .app_version' "$HELMSEARCH")"
	tag0="$(yq -r '.admin.adminUI.tag' "$PSVALUES")"
	if [[ ! "$pstag" = "$newtag" ]] ; then
	    >&2 echo Policy Server Pod $pstag has not yet upgraded to new version $newtag
	    echo 1
	elif [[ "$tag" = "$tag0" ]] ; then
	    envbase SMTAG "$tag"
	    envbase SMNEWTAG "$newtag"
	    echo 0
	else
	    >&2 echo runtime version $tag0 does not match with environment version $tag
	    echo 1
	fi
    fi
    }

#
## upgradeadmin
#
upgradeadmin() {
    ADMINS="$(yq -r '.admin.replicas' "$PSVALUES")"
    ADMINR="$(bash "$MYPATH/../op/admin/containers.sh" | jq 'length')"
    if (( $ADMINR < 2 )) ; then
        bash "$MYPATH/../op/admin/scale.sh" 1
    fi
    if (( $ADMINS < 2 )) ; then
        ADMINS=2
    fi
    >&2 echo $ADMINS $ADMINR
    envbase ADMINS "$ADMINS"
    cat "$PSVALUES" | \
	bash "$MYPATH/../envs/common/sc/upgradeadmin1.sh" > "$PSVALUES".0
    bash "$MYPATH/../envs/common/sc/newvalues.sh" > "$PSVALUES".1
    helm upgrade "$PSREL" "$SMREPO/server-components" -n "$PSNS" \
        -f "$PSVALUES".1 -f "$PSVALUES".0 $SMVERNEW \
        --description="upgrade administrative server pod to $SMVERNEW" \
        --timeout=30m --wait --debug > "$PSVALUES".debug
    }

#
## Start Here
#

createns "$PSNS"

#
## Upgrade SiteMinder Server Components chart
#
if [[ -z "$(relexist "$PSNS" "$PSREL")" ]] ; then
    >&2 echo SiteMinder Server Component release $PSREL is not installed in namespace $PSNS
    exit 1
fi
if [[ "$(bash "$MYPATH/../envs/common/sc/rtvalues.sh" | yq -r '.admin.enabled')" != \
    "true" ]] ; then
    >&2 echo SiteMinder Administrative Server Pod is not enabled, upgrade skipped.
    exit
fi
PSVALUES="$MYPATH/ps.$$.values.yaml"
HELMSEARCH="$MYPATH/ps.$SMREPO.$$.json"
if [ "$(psrelpreq "$(echo "$SMVER" | cut -f2 -d=)" \
        "$(echo "$SMVERNEW" | cut -f2 -d=)")" -eq 0 ] ; then
    >&2 echo to upgrade
    upgradeadmin
else
    >&2 echo pre-requisites are not met, quit upgrading
fi
