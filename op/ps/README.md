# op/ps
This subdirectory holds the utilities are used primarily 
during the Operation stage of a SiteMinder Policy Server pod.
* history.sh -- show the Policy Server helm install history
* pods.sh -- show the current Policy Server pods and 
	* container status
* containers.sh -- show the current Policy Server pods and 
	* container status
* restart.sh -- rollout restart the Policy Server pods
* scale.sh optionalScaleCount -- the default count is 1
	* to scale down, use a negative count number
* sshindex.sh optionalIndexNumber otherOption -- ssh to a
	* container of a Policy Server pod.
	* when otherOption is empty, it goes to the default
	* container. use "-c containerName" to specify the
	* desired container.
	* default IndexNumber is 0
