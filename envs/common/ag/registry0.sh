#/bin/bash
MYPATH=$(cd $(dirname "$0"); pwd)
cd "${MYPATH}"
. "${MYPATH}/../../../base/env.shlib"
if [[ ! -z "$VERSHLIB" ]] ; then
    . "${MYPATH}/../../../base/$VERSHLIB"
fi
    yq -Y --arg u "$SMDOCKERID" --arg p "$SMDOCKERPWD" \
          --arg r "$SMDOCKERURL" --arg s "$SMDOCKERREPOBASE" \
        ' .global.registry.credentials.password = $p
        | .global.registry.credentials.username = $u
        | .global.registry.url = $r
        | .images.accessGateway.repository = $s
        | .images.configuration.repository = $s
        | .images.metricsExporter.repository = $s
        | .images.runtime.configuration.repository = $s
        '
