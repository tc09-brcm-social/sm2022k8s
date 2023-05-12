# op/sc - SiteMinder Server Component operations
* hcversion.sh TAG -- find helm chart version of a given TAG
* history.sh -- helm install/upgrade history
* rmhistory.sh revisionNumber -- remove one revision from the helm history
* rollback.sh revisionNumber -- helm rollback to a revision
* tags.sh -- output min, max of the tags
* update.sh yamlFile optionalDesc -- helm upgrade server component
	* given a yaml file, - being standard in, and an optional description
