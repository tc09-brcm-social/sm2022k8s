#/bin/bash
MYPATH=$(cd $(dirname "$0"); pwd)
cd "${MYPATH}"
. "${MYPATH}/../env.shlib"
GITURI="https://$GITREPOBASE;$GITBRANCH"
    yq -Y --arg s "$AGNAME" --arg u "$GITURI" \
            --arg i "$GITID" --arg k $(b64enc "$GITPAT") \
        ' .sso.configuration.enabled = true
        | .sso.configuration.type = "git"
        | .sso.configuration.source = $u
        | .sso.configuration.git.creds = "gitcreds"
        | .sso.configuration.git.username = $i
        | .sso.configuration.git.accessToken = $k
        | .sso.configuration.git.folderPath = "/deploy/accessgateway"
        '
