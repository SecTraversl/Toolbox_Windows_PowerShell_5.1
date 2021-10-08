


#########################
# OVERVIEW - NOTES #
# The work of using the Switch statement in this Function was modeled after the original work found in "Get-SysmonEvent.ps1"

# This function uses the "-regex" parameter ("switch -regex ($e)") while matching specific lines

# Also, there is the use of "-split ':', 2" in order to only split the line into two pieces, and no more; this was necessary because it was discovered that part of the $Value which contained output of "C:\something\something" was missing... but this was fixed by using the syntax of "-split ':', 2" 




<#
#########################
# WORKSHEET

# This was roughly what I was working with in the terminal, in case a working example is needed in the future to easily replicate and see what the code is doing

$x = @'

Rule Name:                            Core Networking - IPHTTPS (TCP-Out)
----------------------------------------------------------------------
Description:                          Outbound TCP rule to allow IPHTTPS tunneling technology to provide connectivity across HTTP proxies and firewalls.
Enabled:                              Yes
Direction:                            Out
Profiles:                             Domain,Private,Public
Grouping:                             Core Networking
LocalIP:                              Any
RemoteIP:                             Any
Protocol:                             TCP
LocalPort:                            Any
RemotePort:                           IPHTTPS
Edge traversal:                       No
Program:                              C:\WINDOWS\system32\svchost.exe
Service:                              iphlpsvc
InterfaceTypes:                       Any
Security:                             NotRequired
Rule source:                          Local Setting
Action:                               Allow
Ok.

'@


# Necessary statement to break the lines into individually recognized pieces
$x = $x -split "\r?\n"




###################
# This DIDN'T WORK.  I was trying to match the line containing "Description:"

foreach ($e in $x) {
  switch ($e) {
    'Description:.*' { $Key = (($e -split ':').trim())[0]; $Value = (($e -split ':').trim())[1] }
  }
  $Key; $Value
}

###################
# This matched the line containing "Description:"

foreach ($e in $x) {
  switch -regex ($e) {
    'Description:.*' { $Key = (($e -split ':').trim())[0]; $Value = (($e -split ':').trim())[1] }
  }
  $Key; $Value
}


##################
# This also matched the line containing "Description:"

foreach ($e in $x) {
  switch -regex ($e) {
    'Description:' { $Key = (($e -split ':').trim())[0]; $Value = (($e -split ':').trim())[1] }
    Default {$Key = $null; $Value = $null}
  }
  if ($null -notlike $Key) {
    $Key; $Value
  }  
}


###############
# This was effective in using the '|' as an 'OR' separator for the -regex pattern matching

foreach ($e in $x) {
  switch -regex ($e) {
    'Description:|Enabled:' { $Key = (($e -split ':').trim())[0]; $Value = (($e -split ':').trim())[1] }
    Default {$Key = $null; $Value = $null}
  }
  if ($null -notlike $Key) {
    $Key; $Value
  }  
}


###############
# This was also effective to match the line

foreach ($e in $x) {
  switch -regex ($e) {
    '\w+:' { $Key = (($e -split ':').trim())[0]; $Value = (($e -split ':').trim())[1] }
    Default {$Key = $null; $Value = $null}
  }
  if ($null -notlike $Key) {
    $Key; $Value
  }  
}


###############
#############

$x | ? {$_ -and $_ -notlike '*---*' -and $_ -notlike 'Ok.'} | % { $_ -replace ":.*" }

############

$x | ? {$_ -and $_ -notlike '*---*' -and $_ -notlike 'Ok.'} | % {"'" + ($_ -replace ":.*") + "' = " }


#############
# This code... ↓
$x | ? {$_ -and $_ -notlike '*---*' -and $_ -notlike 'Ok.'} | % { "'$($_ -replace '\s\s\s.*')'" + " { $" + ($_ -replace ":.*" -replace "\s","_") + '_Value = (($e -split ":",2).trim())[1] }'  }

# Resulted in this ↓
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



###############
# This code... ↓
$x | ? {$_ -and $_ -notlike '*---*' -and $_ -notlike 'Ok.'} | % { "'$($_ -replace ':.*')'" + " = $" + "$($_ -replace ":.*" -replace "\s","_")_Value"}

# Resulted in this ↓
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
'Service' = $Service_Value
'InterfaceTypes' = $InterfaceTypes_Value
'Security' = $Security_Value
'Rule source' = $Rule_source_Value
'Action' = $Action_Value


#########################
# This was the first attempt... but it needed refinement... specifically it needed: "-split ':', 2"

# THIS IS GOOD FOR WHAT WE BASICALLY WANTED... But I need to not split on any ':' except the first one

foreach ($e in $x) {
  switch -regex ($e) {
    'Rule Name:' { $Rule_Name_Value = (($e -split ":").trim())[1] }
    'Description:' { $Description_Value = (($e -split ":").trim())[1] }
    'Enabled:' { $Enabled_Value = (($e -split ":").trim())[1] }
    'Direction:' { $Direction_Value = (($e -split ":").trim())[1] }
    'Profiles:' { $Profiles_Value = (($e -split ":").trim())[1] }
    'Grouping:' { $Grouping_Value = (($e -split ":").trim())[1] }
    'LocalIP:' { $LocalIP_Value = (($e -split ":").trim())[1] }
    'RemoteIP:' { $RemoteIP_Value = (($e -split ":").trim())[1] }
    'Protocol:' { $Protocol_Value = (($e -split ":").trim())[1] }
    'LocalPort:' { $LocalPort_Value = (($e -split ":").trim())[1] }
    'RemotePort:' { $RemotePort_Value = (($e -split ":").trim())[1] }
    'Edge traversal:' { $Edge_traversal_Value = (($e -split ":").trim())[1] }
    'Program:' { $Program_Value = (($e -split ":").trim())[1] }
    'Service:' { $Service_Value = (($e -split ":").trim())[1] }
    'InterfaceTypes:' { $InterfaceTypes_Value = (($e -split ":").trim())[1] }
    'Security:' { $Security_Value = (($e -split ":").trim())[1] }
    'Rule source:' { $Rule_source_Value = (($e -split ":").trim())[1] }
    'Action:' { $Action_Value = (($e -split ":").trim())[1] }
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
  'Service' = $Service_Value
  'InterfaceTypes' = $InterfaceTypes_Value
  'Security' = $Security_Value
  'Rule source' = $Rule_source_Value
  'Action' = $Action_Value
}

$obj = New-Object -TypeName psobject -Property $prop
Write-Output $obj









#>


<#


#########################
# REVISION ... THIS WORKED WELL... ONLY split on THE FIRST ONE of these → ':' 

foreach ($e in $x) {
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
  'Service' = $Service_Value
  'InterfaceTypes' = $InterfaceTypes_Value
  'Security' = $Security_Value
  'Rule source' = $Rule_source_Value
  'Action' = $Action_Value
}

$obj = New-Object -TypeName psobject -Property $prop
Write-Output $obj


########################
# FINAL - This worked well

$Rules_ActiveStore = Get-NetFirewallRule -PolicyStore ActiveStore

$Final = $Rules_ActiveStore | % {
  $Netsh_Rule = (netsh advfirewall firewall show rule name="$($_.DisplayName)" verbose)

  foreach ($e in $Netsh_Rule) {
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
    'Service' = $Service_Value
    'InterfaceTypes' = $InterfaceTypes_Value
    'Security' = $Security_Value
    'Rule source' = $Rule_source_Value
    'Action' = $Action_Value
  }
  
  $obj = New-Object -TypeName psobject -Property $prop
  Write-Output $obj

}

#>

##################################

function Get-WindowsFWRules {
  [CmdletBinding()]
  param (
    [Parameter(HelpMessage='Paramater Set of possible PolicyStores. Default is "ActiveStore')]
    [ValidateSet('ActiveStore','StaticServiceStore','ConfigurableServiceStore','RSOP','PersistentStore','SystemDefaults')]
    [string]
    $PolicyStore = 'ActiveStore'
  )
  
  begin {
    $ChosenPolicyStore = Get-NetFirewallRule -PolicyStore $PolicyStore
  }
  
  process {
    
    $ChosenPolicyStore | % {
      #$DisplayName = "'" + $_.DisplayName + "'"
      $Netsh_Rule = netsh advfirewall firewall show rule name="$($_.DisplayName)" verbose
      #Write-Host "netsh advfirewall firewall show rule name=$($DisplayName) verbose"

      foreach ($e in $Netsh_Rule) {
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
        'Service' = $Service_Value
        'InterfaceTypes' = $InterfaceTypes_Value
        'Security' = $Security_Value
        'Rule source' = $Rule_source_Value
        'Action' = $Action_Value
      }
      
      $obj = New-Object -TypeName psobject -Property $prop
      Write-Output $obj

    }
  }
  
  end {
    
  }
}

