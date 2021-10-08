<#
.SYNOPSIS
  This is a wrapper for "netsh advfirewall firewall show rule name=all verbose" which shows all firewall rules on the local machine.  *IMPORTANT* - This output is similar to the work done in creating the "Get-WindowsFWRules.ps1" function.  The benefit of the "Get-WindowsFWRules.ps1" function is that you can specify the "PolicyStore" that you specifically want to query.  While the Count between running the two different functions is different, they are both running a variation of "netsh advfirewall" under the hood; also, this function took only 4 seconds to run while the other takes 1.5 minutes.

  PS C:\> $FwRules = Get-NetshFirewallRules
  PS C:\> Get-CommandRuntime
  Minutes           : 0
  Seconds           : 4
  PS C:\> $FwRules | measure
  Count    : 628

  PS C:\> $FWrules = Get-WindowsFWRules
  PS C:\> Get-CommandRuntime
  Minutes           : 1
  Seconds           : 25
  PS C:\> $FWrules | ? {$_.'rule name' -notlike $null} | measure
  Count    : 648


.DESCRIPTION
.EXAMPLE
  PS C:\> $FwRules = Get-NetshFirewallRules
  PS C:\> Get-CommandRuntime
  Days              : 0
  Hours             : 0
  Minutes           : 0
  Seconds           : 4

  PS C:\> $FwRules | measure
  Count    : 628

  PS C:\> $FwRules | select -f 1

  Rule Name      : @{Microsoft.WindowsCalculator_10.2010.0.0_x64__8wekyb3d8bbwe?ms-resource://Microsoft.WindowsCalculator/Resources/AppStoreName}
  Description    : @{Microsoft.WindowsCalculator_10.2010.0.0_x64__8wekyb3d8bbwe?ms-resource://Microsoft.WindowsCalculator/Resources/AppStoreName}
  Enabled        : Yes
  Direction      : Out
  Profiles       : Domain,Private,Public
  Grouping       : Windows Calculator
  LocalIP        : Any
  RemoteIP       : Any
  Protocol       : Any
  LocalPort      :
  RemotePort     :
  Edge traversal : No
  Program        :
  Service        :
  InterfaceTypes : Any
  Security       : NotRequired
  Rule source    : Local Setting
  Action         : Allow



  Here we ran the function and retrieve 628 Windows Firewall rules with over a dozen properties, including the Program that is allowed, the related Service, and the Profiles the rule apples to.

.INPUTS
.OUTPUTS
.NOTES
  Notes:
  - The bulk of this work was initially done when creating the "Get-WindowsFWRules.ps1" function - see that documentation for more details.


  .
#>
function Get-NetshFirewallRules {
  [CmdletBinding()]
  param (
    [Parameter(HelpMessage="Reference the ComputerName of the remote host(s). This will not work if Windows Firewall service is not running or if it is not configured to allow remote management. What I have found is that this is normally not allowed - and the code below doesn't leverage the '-ComputerName' parameter at this time.")]
    [string[]]
    $ComputerName
  )
  
  begin {}
  
  process {
    
    $NetshAllRules = netsh advfirewall firewall show rule name=all verbose

    
    for ($i = 0; $i -lt $NetshAllRules.Count; $i++) {
      if ($NetshAllRules[$i] -like "Rule Name:*") {
        $counter = 0
        $Rule = @()
        #$ItemsInOrder = [System.Collections.ArrayList]@()
        do {
          $Rule += $NetshAllRules[$i + $counter]
          $counter += 1
          <#if ($null -like ($subset[$i + $counter])) {
            $ItemsInOrder +=  ($subset[$i +1 + $counter])
          }#>
          #Write-Output $counter
        } until ($NetshAllRules[$i+1 + $counter] -like "Rule Name:*" -or $NetshAllRules[$i+ $counter] -like "Ok.*") 
        #Write-Output $content

        foreach ($e in $Rule) {
          switch -regex ($e) {
            'Rule Name:' { $Rule_Name_Value = (($e -split ":",2).trim())[1] }
            'Description:' { $Description_Value = (($e -split ":",2).trim())[1] }
            'Enabled:' { $Enabled_Value = (($e -split ":",2).trim())[1] }
            'Direction:' { $Direction_Value = (($e -split ":",2).trim())[1] }
            'Profiles:' { $Profiles_Value = (($e -split ":",2).trim())[1] }
            'Grouping:' { $Grouping_Value = (($e -split ":",2).trim())[1] }
            'LocalIP:' { $LocalIP_Value = (($e -split ":",2).trim())[1] }
            'RemoteIP:' { $RemoteIP_Value = (($e -split ":",2).trim())[1] }
            'Protocol:' { $Protocol_Value = (($e -split ":",2).trim())[1] }
            'LocalPort:' { $LocalPort_Value = (($e -split ":",2).trim())[1] }
            'RemotePort:' { $RemotePort_Value = (($e -split ":",2).trim())[1] }
            'Edge traversal:' { $Edge_traversal_Value = (($e -split ":",2).trim())[1] }
            'Program:' { $Program_Value = (($e -split ":",2).trim())[1] }
            'Service:' { $Service_Value = (($e -split ":",2).trim())[1] }
            'InterfaceTypes:' { $InterfaceTypes_Value = (($e -split ":",2).trim())[1] }
            'Security:' { $Security_Value = (($e -split ":",2).trim())[1] }
            'Rule source:' { $Rule_source_Value = (($e -split ":",2).trim())[1] }
            'Action:' { $Action_Value = (($e -split ":",2).trim())[1] }
          }
        }
        $prop = [ordered]@{
          'Rule Name' = $Rule_Name_Value
          'Description' = $Description_Value
          'Enabled' = $Enabled_Value
          'Direction' = $Direction_Value
          'Profiles' = $Profiles_Value
          'Grouping' = $Grouping_Value
          'LocalIP' = $LocalIP_Value
          'RemoteIP' = $RemoteIP_Value
          'Protocol' = $Protocol_Value
          'LocalPort' = $LocalPort_Value
          'RemotePort' = $RemotePort_Value
          'Edge traversal' = $Edge_traversal_Value
          'Program' = $Program_Value
          'Service' = if ($Service_Value) { $Service_Value } else { $null }
          'InterfaceTypes' = $InterfaceTypes_Value
          'Security' = $Security_Value
          'Rule source' = $Rule_source_Value
          'Action' = $Action_Value
        }

        $obj = New-Object -TypeName psobject -Property $prop
        Write-Output $obj
      }
    }

  }
  
  end {}
}