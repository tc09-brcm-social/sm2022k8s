#/bin/bash
MYPATH=$(cd $(dirname "$0"); pwd)
cd "${MYPATH}"
. "${MYPATH}/../env.shlib"
    yq -Y --arg u "$SMDOCKERID" --arg p "$SMDOCKERPWD" \
          --arg r "$SMDOCKERURL" --arg s "$SMDOCKERREPOBASE" \
        '.global.registry.credentials.username = $u
        | .global.registry.credentials.password = $p
        | .global.registry.url = $r
        | .admin.adminUI.repository = $s
        | .admin.policyServer.repository = $s
        | .global.configuration.repository = $s
        | .global.logging.repository = $s
        | .global.runtimeConfiguration.repository = $s
        | .policyServer.metricsExporter.repository = $s
        | .policyServer.repository = $s
	'
