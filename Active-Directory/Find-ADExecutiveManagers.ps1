<#
.SYNOPSIS
  The "Find-ADExecutiveManagers" function takes the SamAccountName of any user in the Active Directory domain (which user is chosen does not matter because the tool will walk up the hierarchy until it gets to the top), finds the top executive manager in the domain, and returns information about the top executive manager and their direct reports.  By default, the '-SamAccountName' is set to the value in the $env:USERNAME variable, but this can be overridden by explicitly referencing a SamAccountName of your choosing.

.DESCRIPTION
.EXAMPLE
  PS C:\> Find-ADExecutiveManagers


  TopExecManagerName            : Mia Hammilet
  TopExecManagerSamAccountName  : smia
  ExecManagerNames              : {Mia Hammilet, Billy Peckson, Phil Dunkerson, Razel Dazzle...}
  ExecManagerSamAccountNames    : {smia, Billy.Peckson, Phil.Dunkerson, Razel.Dazzle...}
  ExecManagerDistinguishedNames : {CN=Mia Hammilet,OU=Operations
                                  Admin,OU=Operations,OU=MyDomain,DC=corp,DC=MyDomain,DC=com, CN=Billy Peckson,OU=Human
                                  Resources,OU=Org Dev & HR,OU=MyDomain,DC=corp,DC=MyDomain,DC=com, CN=Phil
                                  Dunkerson,OU=Operations Admin,OU=Operations,OU=MyDomain,DC=corp,DC=MyDomain,DC=com,
                                  CN=Razel Dazzle,OU=Hold,OU=Operators,DC=corp,DC=MyDomain,DC=com...}



  Here we run the function without any additional parameters.  This tool, by default, will reference the -SamAccountName found in the value of the $env:USERNAME variable.  If you want to override this default behavior, simply explicitly reference a "SamAccountName" of your choosing, with the "-SamAccountName" parameter.

.EXAMPLE
  PS C:\> FindExecutiveManagers -SamAccountName bart.simpson -ExcludeDisabledUsers

  TopExecManagerName            : Mia Hammilet
  TopExecManagerSamAccountName  : smia
  ExecManagerNames              : {Mia Hammilet, Bilheel Peck, Emily Brown, Billy Peckson...}
  ExecManagerSamAccountNames    : {smia, Bilheel.Peck, Emily.Brown, Billy.Peckson...}
  ExecManagerDistinguishedNames : {CN=Mia Hammilet,OU=Operations Admin,OU=Operations,OU=Roxboard,DC=corp,DC=Roxboard,DC=com,
                                  CN=Bilheel Peck,OU=Operations Admin,OU=Operations,OU=Roxboard,DC=corp,DC=Roxboard,DC=com, CN=Emily
                                  Brown,OU=New Business Innovation,OU=Roxboard,DC=corp,DC=Roxboard,DC=com, CN=Billy Peckson,OU=Human
                                  Resources,OU=Org Dev & HR,OU=Roxboard,DC=corp,DC=Roxboard,DC=com...}



  Here we run the "Find-ADExecutiveManagers" using its built-in alias of 'FindExecutiveManagers'.  We specify the SamAccountName of one of the Users in the Active Directory Domain (which user is chosen does not matter because the tool will walk up the hierarchy until it gets to the top), and the function returns information about the Top Executive Manager, and their Direct Reports.  We also specified the switch parameter "-ExcludeDisabledUsers" so that the returned objects did not contain any accounts that are disabled in Active Directory.

.INPUTS
.OUTPUTS
.NOTES
  Name:  Find-ADExecutiveManagers.ps1
  Author:  Travis Logue
  Version History:  1.1 | 2021-03-06 | Initial Version
  Dependencies:  Active Directory Module
  Notes:


  .  
#>
function Find-ADExecutiveManagers {
  [CmdletBinding()]
  [Alias('FindExecutiveManagers')]
  param (
    [Parameter()]
    [switch]
    $ExcludeDisabledUsers,
    [Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName)]
    [string]
    $SamAccountName = $env:USERNAME
  )
  
  begin {}
  
  process {
    $UserObject = Get-ADUser -Filter { SamAccountName -eq $SamAccountName } -Properties Manager, DirectReports

    $IteratorUserObject = $UserObject

    while ($IteratorUserObject.DistinguishedName -ne $IteratorUserObject.Manager) {
      $IteratorUserObject = Get-ADUser -Filter { DistinguishedName -eq $IteratorUserObject.Manager } -Properties Manager, DirectReports
    }

    $TopExecutiveManager = $IteratorUserObject

    $ReporteeNames = @()
    $ReporteeSamAccountNames = @()
    $ReporteeDistinguishedNames = @()


    if ($ExcludeDisabledUsers) {      

      foreach ($Reportee in $TopExecutiveManager.DirectReports) {      
        $TempUserObject = Get-ADUser -Filter { DistinguishedName -eq $Reportee }

        if ($TempUserObject.Enabled -eq $true) {

          $ReporteeNames += $TempUserObject.Name
          $ReporteeSamAccountNames += $TempUserObject.SamAccountName
          $ReporteeDistinguishedNames += $TempUserObject.DistinguishedName  

        }  
      }

    }
    else {

      foreach ($Reportee in $TopExecutiveManager.DirectReports) {      
        $TempUserObject = Get-ADUser -Filter { DistinguishedName -eq $Reportee }

        $ReporteeNames += $TempUserObject.Name
        $ReporteeSamAccountNames += $TempUserObject.SamAccountName
        $ReporteeDistinguishedNames += $TempUserObject.DistinguishedName  
      }      
      
    }

    $prop = [ordered]@{

      TopExecManagerName            = $TopExecutiveManager.Name
      TopExecManagerSamAccountName  = $TopExecutiveManager.SamAccountName
      ExecManagerNames              = @( $TopExecutiveManager.Name ) + $ReporteeNames 
      ExecManagerSamAccountNames    = @( $TopExecutiveManager.SamAccountName ) + $ReporteeSamAccountNames
      ExecManagerDistinguishedNames = @( $TopExecutiveManager.DistinguishedName ) + $ReporteeDistinguishedNames 

    }

    $obj = New-Object -TypeName psobject -Property $prop
    Write-Output $obj

  }
  
  end {}
}