#/bin/bash
MYPATH=$(cd $(dirname "$0"); pwd)
cd "${MYPATH}"
. "${MYPATH}/../../base/env.shlib"
if [[ ! -z "$VERSHLIB" ]] ; then
    . "${MYPATH}/../../base/$VERSHLIB"
fi
    if [[ -z "$INGRESSREGISTRYBASE" ]] ; then cat - ; else \
          yq -Y --arg r "$INGRESSHOST" --arg u "$INGRESSUSER" \
              ' .controller.admissionWebhooks.patch.image.registry = $r
              | .controller.admissionWebhooks.patch.image.image = ( $u + "/kube-webhook-certgen" )
	      | .controller.admissionWebhooks.patch.image.digest = ""
	      | .controller.image.registry = $r
	      | .controller.image.image = ( $u + "/controller" )
	      | .controller.image.digest = ""
              '
      fi \
    | if [[ -z "$INGRESSDOCKERSECRET" ]] ; then cat - ; else \
          yq -Y --arg s "$INGRESSDOCKERSECRET" \
              ' .imagePullSecrets[0].name = $s
              '
      fi
#      registry: k8s.gcr.io
#      image: ingress-nginx/controller
      ## for backwards compatibility consider setting the full image url via the repository value below
      ## use *either* current default registry/image or repository format or installing chart by providing the values.yaml will fail
      ## repository:
#      tag: "v1.1.1"
#      digest: sha256:0bc88eb15f9e7f84e8e56c14fa5735aaa488b840983f87bd79b1054190e660de
#	      ' .controller.admissionWebhooks.patch.image.repository = $r
#              | .controller.image.repository = $r
#	      | .controller.image.digest = ""
#              | .defaultBackend.image.repository = $r
#              '
#              ' .controller.admissionWebhooks.patch.image.registry = $r
#	      | .controller.admissionWebhooks.patch.image.digest = ""
#              | .controller.image.registry = $r
#	      | .controller.image.digest = ""
#              | .defaultBackend.image.registry = $r
# .controller.admissionWebhooks.patch.image.registry
# .controller.image.registry
# .defaultBackend.image.registry
# .imagePullSecrets[0].name =  "docker-hub-reg-pullsecret"
