#!/bin/bash
MYPATH=$(cd $(dirname "$0"); pwd)
cd "${MYPATH}"
. "${MYPATH}/../base/env.shlib"
if [[ ! -z "$VERSHLIB" ]] ; then
    . "${MYPATH}/../base/$VERSHLIB"
fi

#
## dossprepo
#
dossprepo() {
    if [[ -z "$(repoexist "$SSPREPO")" ]] ; then
        bash "${MYPATH}/../base/ssprepo.sh"
    else
        >&2 echo $SSPREPO exists
    fi
    }

#
## dodockersecret
#
dodockersecret() {
    local _secret
    local _server
    local _name
    local _password
    local _email

        _secret="$SADOCKERSECRET"
        _server="$SASERVER"
        _name="$SAUSERNAME"
        _password="$SAPASSWORD"
        _email="$SAEMAIL"
    doPullSecret "$_secret" \
	"$_server" "$_name" "$_password" \
	"$SA"
    }

#
## dosspsahelm
#
dosspsahelm() {
    local _action="$1"
    local _output="$2"
    local _option="$3"

    dodockersecret
    if [[ -z "$(relexist "$SA" "$SAREL")" ]] ; then
        cat "$SAVALUES" \
	     | if [[ -z "$SARTVALUES" ]] ; then cat - ; else \
                  bash "$SARTVALUES"
              fi \
             | helm "$_action" "$SAREL" -n "$SA" "$SSPREPO/ssp-sample-app" \
                   -f - \
                   $SAVER $_option > "$_output"
    fi
    }


#
## Starts Here
#

dossprepo
createns "$SA"
dosspsahelm install "$SAREL.$SA.$$".debug "--debug"
