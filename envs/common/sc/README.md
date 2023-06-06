# envs/common/sc
The sc is referring to the Server Component.
Commonly used tools to help build a ps-values.yaml.

* values.sh optionalParameter -- helm show values
	* optionalParameter is expected to be
	* a server-components version default value SMVER
* newvalues.sh -- values.sh "$SMVERNEW"
* rtvalues.sh -- helm get values using PSREL and PSNS
* baseCompat.sh -- base configuration using FIPS Compat
	* set the three required secrets
	* masterKeySeed superuserPassword encryptionKey
* baseOnly.sh -- base configuration using FIPS Only
	* set the three required secrets
	* masterKeySeed superuserPassword encryptionKey
* pull.sh optionalParameter -- helm pull
	* optionalParameter is expected to be
	* a server-components version default value SMVER
* enfdefault.sh -- enforce certain required defaults
* adminpod0.sh -- disable Administrative Server Pod
* adminpod1.sh -- Administrative Server Pod enabled
* configrGit1.sh -- Config Retriver Using Git
* ingress1.sh -- Admin UI Ingress configuration
* pscNP.sh -- policy server container using NodePort and
	* others
* pspod0.sh -- disable policy server pod
* pspod1.sh -- policy server pod enabled
* pstore1.sh -- Policy Store using Symantec Directory
* pstore2.sh -- Policy Store using MSSQL
* rconfigrGit1.sh -- runtime Config Retriever Using Git
* registry.sh -- docker registry settings
* rmAdmin.sh -- remove the administrative pod component
	* Maintenance chart does not seem to need the administrative pod component
* stores0.sh -- simple other stores, no session store
* stores2.sh -- simple other stores, session store using MSSQL
* upgradeps1.sh -- upgrade policy server pod from SMTAG to SMNEWTAG
* upgradeadmin1.sh -- upgrade administrative server pod with XPS schema upgrade 
