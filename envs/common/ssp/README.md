# envs/common/ssp
* ssp-infra-backend.sh -- required to integrate with elasticsearch
	* requires a running elasticsearch deployment
	* ususally used during build time
* ssp-infra-default.sh -- default settings including ssp-infra-demodb
* ssp-infra-demodb.sh -- use demo db
* ssp-infra-ssp-data.sh -- required setting for ssp-data deployment
* ssp-infra-sspfbService.sh -- set sspfbService.parser for docker container type
	* requires a running cluster,
	* ususally used during build time
* ssp-infra-values.sh -- helm show values
# ssp helm chart 
* Sample values combinations
	* bash ../common/ssp/ssp-values.sh \
	*     | bash ../common/ssp/ssp-default.sh \
	*     | bash ../common/ssp/ssp-ingress.sh \
	*     | bash ../common/ssp/ssp-swagger1.sh \
	*     | bash ../common/ssp/ssp-demo.sh
* ssp-default.sh -- default settings
* ssp-ingress.sh -- nginx ingress settings
* ssp-swagger1.sh -- enable swagger UI
* ssp-values.sh -- helm show values
* ssp-demo.sh -- set to demo mode installation
* ssp-data helm chart **
* ssp-data-default.sh -- ssp-data default settings
* ssp-data-values.sh -- helm show values
# ssp-sample helm chart
* Sample values combinations
	* bash ../common/ssp/ssp-sample-app-values.sh \
	*    | bash ../common/ssp/ssp-sample-app-default.sh \
	*    | bash ../common/ssp/ssp-sample-app-dirLB.sh
* Sample RT values combinations
	* bash ../common/ssp/ssp-sample-app-ingress.sh \
	*    | bash ../common/ssp/ssp-sample-app-service.sh
* ssp-sample-app-default.sh -- ssp-sample helm chart efault settings
* ssp-sample-app-dirLB.sh -- symantec sample directory using LoadBalancer
* ssp-sample-app-dirNP.sh -- symantec sample directory using NodePort
* ssp-sample-app-ingress.sh -- nginx ingress settings
* ssp-sample-app-service.sh -- service and OIDC App settings
* ssp-sample-app-values.sh -- helm show values

