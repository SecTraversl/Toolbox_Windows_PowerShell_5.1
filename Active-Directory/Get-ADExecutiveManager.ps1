<#
.SYNOPSIS
  The "Get-ADExecutiveManager" function takes the SamAccountName of Active Directory users and determines who their corresponding Executive Manager is at the top of the organization's hierarchy by iterating through the "Manager" property of the User Object in Active Directory.  This function requires the "Find-ADExecutiveManagers.ps1" function (which automatically searches the domain, finds the top executive manager, and the direct reports of the top executive manager).

.DESCRIPTION
.EXAMPLE
  PS C:\> Get-ADExecutiveManager -SamAccountName 'Tom.Storkin'

  UserName    UserSamAccountName ExecManagerName SamAccountName
  --------    ------------------ --------------- --------------
  Tom Storkin Tom.Storkin        Emily Brown     Emily.Brown


  PS C:\> ADExecutiveManager 'Tom.Storkin'

  UserName    UserSamAccountName ExecManagerName SamAccountName
  --------    ------------------ --------------- --------------
  Tom Storkin Tom.Storkin        Emily Brown     Emily.Brown



  Here we demonstrate the verbose and the fast way to run this function.  'ADExecutiveManager' is the built-in alias for "Get-ADExecutiveManager" and we show here how we can use it to get the same results as we did when running the function using the full name (the first example) along with an explicit reference to the "-SamAccountName" parameter.

.EXAMPLE
  PS C:\> Invoke-ADUserNameChecker 'Tom Storkin'

  Name        AccountFound SamAccountName Mail
  ----        ------------ -------------- ----
  Tom Storkin         True Tom.Storkin    Tom.Storkin@Roxboard.com


  PS C:\> ADNameChecker 'Tom Storkin'

  Name        AccountFound SamAccountName Mail
  ----        ------------ -------------- ----
  Tom Storkin         True Tom.Storkin    Tom.Storkin@Roxboard.com


  PS C:\> ADNameChecker 'Tom Storkin' | Get-ADManager

  UserName    UserSamAccountName ManagerName  SamAccountName
  --------    ------------------ -----------  --------------
  Tom Storkin Tom.Storkin        Bilheel Peck Bilheel.Peck


  PS C:\> Invoke-ADUserNameChecker 'Tom Storkin' | Get-ADExecutiveManager

  UserName    UserSamAccountName ExecManagerName SamAccountName
  --------    ------------------ --------------- --------------
  Tom Storkin Tom.Storkin        Emily Brown     Emily.Brown



  Here we demonstrate the use of a chain of functions and how they can be used together.  We first demonstrate the use of "Invoke-ADUserNameChecker" and its built-in alias 'ADNameChecker' in order to retrieve the SamAccountName for a specic user's Name.  From there, we are able to pipe that object to both "Get-ADManager" and "Get-ADExecutiveManager" in order to gain additional information about the user.

.INPUTS
.OUTPUTS
.NOTES
  Name:  Get-ADExecutiveManager.ps1
  Author:  Travis Logue
  Version History:  1.2 | 2021-09-24 | Explicitly selected one SamAccountName
  Dependencies:  Active Directory Module | Find-ADExecutiveManagers
  Notes:


  .  
#>
function Get-ADExecutiveManager {
  [CmdletBinding()]
  [Alias('ADExecutiveManager')]
  param (
    [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
    [string[]]
    $SamAccountName,
    [Parameter(HelpMessage = 'This parameter is used to add the SamAccountNames of AD Users who are Executive Managers, but who do not directly report to the CEO.  For instance, someone may be an Executive Manager, and report to another who is also an Executive Manager.')]
    [string[]]
    $IncludeExecManagerSamAccountName # You can add defaults right here if you want them hard-coded # = @('SamAccount1','SamAccount2')
  )
  
  begin {}
  
  process {
    # Main code for the function

    # We only need to run this once, and will reference the results throughout the rest of the function
    $OneSamAccount = $SamAccountName | Select-Object -First 1
    $ExecResults = Find-ADExecutiveManagers -SamAccountName ($OneSamAccount) -ExcludeDisabledUsers

    if ($IncludeExecManagerSamAccountName) {
      foreach ($AddedExecManagerSamAccount in $IncludeExecManagerSamAccountName) {
        $ADUserLookup = Get-ADUser -Filter { SamAccountName -eq $AddedExecManagerSamAccount } -Properties Manager, DirectReports
        
        $ExecResults.ExecManagerNames += @( $ADUserLookup.Name )
        $ExecResults.ExecManagerSamAccountNames += @( $ADUserLookup.SamAccountName )
        $ExecResults.ExecManagerDistinguishedNames += @( $ADUserLookup.DistinguishedName )
      }
    }    

    foreach ($SamAccount in $SamAccountName) {      

      $UserObject = Get-ADUser -Filter { SamAccountName -eq $SamAccount } -Properties Manager, DirectReports

      # If the User is an ExecManager...
      if ($UserObject.SamAccountName -in $ExecResults.ExecManagerSamAccountNames) {

        $SpecialCaseExecManager = Get-ADUser -Filter { DistinguishedName -eq $UserObject.Manager } -Properties Manager, DirectReports

        $prop = [ordered]@{
          UserName           = $UserObject.Name
          UserSamAccountName = $UserObject.SamAccountName
          ExecManagerName    = $SpecialCaseExecManager.Name
          SamAccountName     = $SpecialCaseExecManager.SamAccountName
        }
        $obj = New-Object -TypeName psobject -Property $prop
        Write-Output $obj
      }
      else {        
        $IteratorUserObject = $UserObject

        do {
          $IteratorUserObject = Get-ADUser -Filter { DistinguishedName -eq $IteratorUserObject.Manager } -Properties Manager, DirectReports
        } until ($IteratorUserObject.SamAccountName -in $ExecResults.ExecManagerSamAccountNames)

        $prop = [ordered]@{
          UserName           = $UserObject.Name
          UserSamAccountName = $UserObject.SamAccountName
          ExecManagerName    = $IteratorUserObject.Name          
          SamAccountName     = $IteratorUserObject.SamAccountName
        }
        $obj = New-Object -TypeName psobject -Property $prop
        Write-Output $obj
      }
    }

  }
  
  end {}
}