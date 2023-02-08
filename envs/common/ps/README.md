# envs/common/ps
Commonly used tools to help maintain a SiteMinder Container Environment.

The ps scripts are commonly used scripts to build a ps-values.yaml file.

* values.sh -- helm show values for ps
* newvalues.sh -- helm show values for ps use SMVERNEW
* admin1.sh -- Administrative Server Pod Settings
	* Administrative Server Pod enabled
	* set Nginx Ingress name and cert
* upgradeadmin1.sh -- upgrade Administrative Server 1
* upgradeps1.sh -- upgrade Policy Server 1
