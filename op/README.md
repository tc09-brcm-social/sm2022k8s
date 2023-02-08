# op
Operation Phase utilities. There are platform specific facilities.
* nodesip.sh - returns external IPs for all nodes.
* nodeip.sh nodeName -- return external IP of a particular node
* adminpods.sh -- list administrative server pods and their k8s worker nodes
	* This is deprecated. Use admin/pods.sh instead
* pspods.sh -- list policy server pods and their k8s worker nodes
	* This is deprecated. Use ps/pods.sh instead
* agpods.sh -- list access gateway pods and their k8s worker nodes
	* This is deprecated. Use ag/pods.sh instead
* nodesdate.sh -- run date on all nodes using $CLOUD/sshnodeindex.sh as a "demo"
* sshnodeindex.sh optionalIndex -- ssh to worker node, defaul 0
* scaleps.sh optionalNumber -- positive to scale up negative to scale down, def 1
	* This is deprecated. Use ps/scale.sh instead
* scaleag.sh optionalNumber -- positive to scale up negative to scale down, def 1
	* This is deprecated. Use ag/scale.sh instead
* sshpsindex.sh optionalIndex optionalOptions -- ssh to policy server using index
	* index default 0, optionalOptions to choose non-default container
	* e.g. "-c policy-server-log" to ssh to policy server log container
	* This is deprecated. Use ps/sshindex.sh instead
* sshadminindex.sh optionalIndex optionalOptions -- ssh to administrative server pod using index
	* similar to sshpsindex.sh
	* This is deprecated. Use admin/sshindex.sh instead
* sshagindex.sh optionalIndex optionalOptions -- ssh to access gateway pod using index
	* similar to sshpsindex.sh
	* This is deprecated. Use ag/sshindex.sh instead
* restartadmin.sh -- resart admin pod
	* This is deprecated. Use admin/restart.sh instead
* restartag.sh -- restart access gateway pod
	* This is deprecated. Use ag/restart.sh instead
* restartps.sh -- restart policy server pod
	* This is deprecated. Use ps/restart.sh instead
