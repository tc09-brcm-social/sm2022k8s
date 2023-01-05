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
