This script adds and removes firewall rules both by passing hardcoded information the the **$HardcodedRules** :
```
$HardcodedRules = @(
	@("RedM", "40120", "TCP", "in", "add"),
    @("RedM", "30120", "Both", "in", "add")
)
```
or Dynamically by passing the **arguments** to the script as:

```
.\firewallrule.ps1 "RedM,40120,TCP,in,add" "RedM,30120,Both,in,add"
```

in all cases the syntax is **Game name**, **Port**, **Protocol** ***(TCP/UDP or Both)***, **Direction** ***(in or out)*** and **Action** ***(add or del)***

####  IMPORTANT: !!! Firewall rules passed as arguments have priority over the hardcoded rules !!!
