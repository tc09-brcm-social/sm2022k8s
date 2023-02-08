# envs/common/ag
Commonly used tools to help maintain a SiteMinder Container Environment.

The ag- scripts are commonly used scripts to build an ag-values.yaml file.
`
* registry.sh -- access gateway (access gateway) docker registry
	* allows private docker registery
* registry0.sh -- ag-registry.sh that needs yaml from stdin
* values.sh -- helm show values for ag use SMVER for the version number
* newvalues.sh -- helm show values use SMVERNEW for the version number
* ps1.sh -- Registration with Policy Server
	* set masterkey
	* policyserver service set to use NodePort on the same cluster
	* ACO, HCO, TrustedHost name
	* SiteMinder registration user/password
* web1.sh -- Web Server Settings
	* httpd using default ssl settings, cert supplied by Config Retriever
	* Certificate at Nginix Ingress,  ingress pass through No
* ag1.sh -- Application Server Settings
	* simple Access Gateway virtual host name
* fed1.sh -- Federation Configuration
	* Access Gateway Fed enabled
	* Fed trace enabled
* configrGit1.sh -- access gateway config retriever
	* using GIT Server
	* /deploy/accessgateway for Access Gateway Pod
* rconfigrGit1.sh -- access gateway runtime config retriever
	* using GIT Server
	* /runtime/accessgateway for Access Gateway Pod
