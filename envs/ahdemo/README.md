# envs/ahdemo
A sample AuthHub Demo environment.

* env.shlib -- sample configuration for non-ocp implementation
* env.shlib.ocp -- sample configuration file for ocp

Procedure to set it up
* configure the <<home>>>/env.shlib to pick the Cloud Provider
* configure the cluster/<<CLOUD>>/env.shlib to set proper
	* Cloud Provider details including number of worker nodes
* cd <<home>>/envs/ahdemo
* bash make.sh # to set environement variables
* cd <<home>>/cluster
* bash create.sh # to create a cluster according to the setting
	* done in the earlier step
* once a cluster is successfully created
* cd <<home>>build
* follow the README.md there to deploy AuthHub

* patchenv.sh optionalEnvSHLIB #of another environment
	* this is to take the local env.shlib to patch
	* another environment.
	* Note that it does not preserve the
	* deferred evaluation of single quoted values 
