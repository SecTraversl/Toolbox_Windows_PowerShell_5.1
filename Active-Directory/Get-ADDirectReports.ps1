<#
.SYNOPSIS
  The "Get-ADDirectReports" function finds the Direct Reports for a give SamAccountName of a user in Active Directory.

.DESCRIPTION
.EXAMPLE
  PS C:\> Get-ADDirectReports -SamAccountName 'Victour.Parr'

  ManagerName  ManagerSamAccountName DirectReportName            SamAccountName
  -----------  --------------------- ----------------            --------------
  Victour Parr Victour.Parr          {Byron Kart, Marve Smirnov} {Byron.Kart, Marve.Smirnov}


  PS C:\> ADDirectReports 'Victour.Parr'

  ManagerName  ManagerSamAccountName DirectReportName            SamAccountName
  -----------  --------------------- ----------------            --------------
  Victour Parr Victour.Parr          {Byron Kart, Marve Smirnov} {Byron.Kart, Marve.Smirnov}



  Here we demonstrate the verbose and the fast way to run this function.  'ADDirectReports' is the built-in alias for "Get-ADDirectReports" and we show here how we can use it to get the same results as we did when running the function using the full name (the first example) along with an explicit reference to the "-SamAccountName" parameter.

.EXAMPLE
  PS C:\> Invoke-ADUserNameChecker -Name 'Victour Parr'

  Name         AccountFound SamAccountName Mail
  ----         ------------ -------------- ----
  Victour Parr         True Victour.Parr   Victour.Parr@Roxboard.com


  PS C:\> ADNameChecker 'Victour Parr'

  Name         AccountFound SamAccountName Mail
  ----         ------------ -------------- ----
  Victour Parr         True Victour.Parr   Victour.Parr@Roxboard.com


  PS C:\> ADNameChecker 'Victour Parr' | ADDirectReports

  ManagerName  ManagerSamAccountName DirectReportName            SamAccountName
  -----------  --------------------- ----------------            --------------
  Victour Parr Victour.Parr          {Byron Kart, Marve Smirnov} {Byron.Kart, Marve.Smirnov}



  Here we demonstrate the use of a chain of functions and how they can be used together.  We first demonstrate the use of "Invoke-ADUserNameChecker" and its built-in alias 'ADNameChecker' in order to retrieve the SamAccountName for a specic user's Name.  From there, we are able to pipe that object to 'ADDirectReports' (the built-in alias for "Get-ADDirectReports") in order to gain additional information about the user.

.INPUTS
.OUTPUTS
.NOTES
  Name:  Get-ADDirectReports.ps1
  Author:  Travis Logue
  Version History:  1.1 | 2021-03-06 | Initial Version
  Dependencies:  Active Directory Module
  Notes:


  .  
#>
function Get-ADDirectReports {
  [CmdletBinding()]
  [Alias('ADDirectReports')]
  param (
    [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
    [string[]]
    $SamAccountName,
    [Parameter()]
    [switch]
    $ExcludeDisabledUsers
  )
  
  begin {}
  
  process {

    foreach ($Sam in $SamAccountName) {
      
      $UserObject = Get-ADUser -Filter { samaccountname -eq $Sam } -Properties directReports
      
      $ReporteeNameArray = @()
      $ReporteeSamAccountNameArray = @()

      if ($ExcludeDisabledUsers) {        
        foreach ($User in $UserObject.directReports) {        
          $Reportee = Get-ADUser -Filter { DistinguishedName -like $User }
  
          if ($Reportee.Enabled -eq $true) {            
            $ReporteeNameArray += $Reportee.Name
            $ReporteeSamAccountNameArray += $Reportee.SamAccountName
          }  
        }
      }
      else {        
        foreach ($User in $UserObject.directReports) {
        
          $Reportee = Get-ADUser -Filter { DistinguishedName -like $User }
  
          $ReporteeNameArray += $Reportee.Name
          $ReporteeSamAccountNameArray += $Reportee.SamAccountName  
        }
      }

      $prop = [ordered]@{
        ManagerName           = $UserObject.Name
        ManagerSamAccountName = $UserObject.SamAccountName
        DirectReportName      = $ReporteeNameArray
        SamAccountName        = $ReporteeSamAccountNameArray
      }  
      $obj = New-Object -TypeName psobject -Property $prop
      Write-Output $obj

    }

  }
  
  end {}
}