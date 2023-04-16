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
