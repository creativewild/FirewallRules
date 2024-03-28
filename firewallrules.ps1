 <#
    .DESCRIPTION: This script adds and removes firewall rules both by passing hardcoded information the the $HardcodedRules or Dynamicaly by passing the arguments to the script as: .\firewallrule.ps1 "RedM,40120,TCP,in,add" "RedM,30120,Both,in,add"
                  IMPORTANT: !!! Firewall rules passed as arguments have priority over the hardcoded rules !!!

    .AUTHOR: Black Pegasus - VORP TEAM

    .GITHUB: https://github.com/creativewild

    .REVISION HISTORY: 1.6
 #>

$HardcodedRules = @(
    @("RedM", "40120", "TCP", "in", "add"),
    @("RedM", "30120", "Both", "in", "add")
)

$ArgumentRules = @()
foreach ($arg in $args) {
    $rule = $arg -split ","
    $ArgumentRules += ,$rule
}

$Rules = $HardcodedRules + $ArgumentRules
foreach ($rule in $Rules) {
    $gameName = $rule[0]
    $port = $rule[1]
    $protocolInput = $rule[2]
    $directionShorthand = $rule[3]
    $action = $rule[4].ToLower()
    $direction = if ($directionShorthand -eq 'in') {'Inbound'} else {'Outbound'}

    $protocols = @()
    if ($protocolInput -eq "Both") {
        $protocols += "TCP", "UDP"
    } else {
        $protocols += $protocolInput
    }

    foreach ($protocol in $protocols) {
        $ruleName = $gameName + "_Port" + $port + "_" + $protocol + "_" + $direction
        $existingRule = Get-NetFirewallRule -DisplayName $ruleName -ErrorAction SilentlyContinue

        if ($action -eq "add") {
            if ($null -eq $existingRule) {
                New-NetFirewallRule -DisplayName $ruleName `
                                    -Direction $direction `
                                    -LocalPort $port `
                                    -Protocol $protocol `
                                    -Action Allow `
                                    -Enabled True
                Write-Host "Created new firewall rule: $ruleName" -ForegroundColor White -BackgroundColor Green
            } else {
                Write-Host "Firewall rule $ruleName already exists." -ForegroundColor Black -BackgroundColor Yellow
            }
        } elseif ($action -eq "del") {
            if ($null -ne $existingRule) {
                Remove-NetFirewallRule -DisplayName $ruleName
                Write-Host "Deleted firewall rule: $ruleName" -ForegroundColor White -BackgroundColor Red
            } else {
                Write-Host "Firewall rule $ruleName does not exist, so it cannot be deleted." -ForegroundColor Black -BackgroundColor Yellow
            }
        }
    }
}