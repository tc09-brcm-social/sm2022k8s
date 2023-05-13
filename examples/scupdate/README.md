# examples/scupdate
Modify the env.shlib to set the script that generates the YAML needed
to helm update the SiteMinder server component.
As an update, the YAML starts with runtime version and further
modified using the script specified through the UPDATE environment
variable.
A list of sample scripts included:
* admin0.sh -- disable administrative pod if it is currently enabled, no op otherwise
* admin1.sh -- enable administative pod if it is currently disabled, no op otherwise
* ps0.sh -- disable policy server pod if it is current enabled, no op otherwise
* ps0admin1.sh -- set policy server disabled and administrative server pod enabled
* ps1.sh -- enable policy server pod if it is current disabled, no op otherwise
* ps1admin0.sh -- set policy server pod enabled and administrative server pod disabled
* ps1admin1.sh -- set both policy server and administrative server pods enabled
