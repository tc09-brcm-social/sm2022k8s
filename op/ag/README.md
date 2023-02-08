# op/ag
This subdirectory holds the utilities are used primarily 
during the Operation stage of a SiteMinder Access Gateway pod.
* history.sh -- show the Access Gateway helm install history
* pods.sh -- show the current Access Gateway pods and 
	* container status
* restart.sh -- rollout restart the Policy Server pods
* scale.sh optionalScaleCount -- the default count is 1
	* to scale down, use a negative count number
* sshindex.sh optionalIndexNumber otherOption -- ssh to a
	* container of an Access Gateway pod.
	* when otherOption is empty, it goes to the default
	* container. use "-c containerName" to specify the
	* desired container.
	* default IndexNumber is 0
