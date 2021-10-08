<#
.SYNOPSIS
  The "Get-ADManager" function takes the SamAccountName of Active Directory users and determines who the corresponding Manager is by evaluating the "Manager" property of the User Object in Active Directory.  

.DESCRIPTION
.EXAMPLE
  PS C:\> Get-ADManager -SamAccountName 'Cyan.Foss' | ft

  UserName  UserSamAccountName ManagerName  SamAccountName ManagerMail
  --------  ------------------ -----------  -------------- -----------
  Cyan Foss Cyan.Foss          Mark Dunkirk Mark.Dunkirk   Mark.Dunkirk@MyDomain.com


  PS C:\> ADManager 'Cyan.Foss' | ft

  UserName  UserSamAccountName ManagerName  SamAccountName ManagerMail
  --------  ------------------ -----------  -------------- -----------
  Cyan Foss Cyan.Foss          Mark Dunkirk Mark.Dunkirk   Mark.Dunkirk@MyDomain.com



  Here we demonstrate the verbose and the fast way to run this function.  'ADManager' is the built-in alias for "Get-ADManager" and we show here how we can use it to get the same results as we did when running the function using the full name (the first example) along with an explicit reference to the "-SamAccountName" parameter.

.EXAMPLE
  PS C:\> Invoke-ADUserNameChecker -Name 'Tom Storkin'

  Name        AccountFound SamAccountName Mail
  ----        ------------ -------------- ----
  Tom Storkin         True Tom.Storkin    Tom.Storkin@Roxboard.com


  PS C:\> ADNameChecker 'Tom Storkin'

  Name        AccountFound SamAccountName Mail
  ----        ------------ -------------- ----
  Tom Storkin         True Tom.Storkin    Tom.Storkin@Roxboard.com


  PS C:\> ADNameChecker -Name 'Tom Storkin' | Get-ADManager | ft

  UserName    UserSamAccountName ManagerName  SamAccountName ManagerMail
  --------    ------------------ -----------  -------------- -----------
  Tom Storkin Tom.Storkin        Bilheel Peck Bilheel.Peck   Bilheel.Peck@MyDomain.com



  Here we demonstrate the use of a chain of functions and how they can be used together.  We first demonstrate the use of "Invoke-ADUserNameChecker" and its built-in alias 'ADNameChecker' in order to retrieve the SamAccountName for a specic user's Name.  From there, we are able to pipe that object to "Get-ADManager" in order to gain additional information about the user.

.INPUTS
.OUTPUTS
.NOTES
  Name:  Get-ADManager.ps1
  Author:  Travis Logue
  Version History:  1.2 | 2021-09-24 | Added 'ManagerMail' Property
  Dependencies:  Active Directory Module
  Notes:


  .  
#>
function Get-ADManager {
  [CmdletBinding()]
  [Alias('ADManager')]
  param (
    [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
    [string[]]
    $SamAccountName
  )
  
  begin {}
  
  process {

    foreach ($SamAccount in $SamAccountName) {

      $UserObject = Get-ADUser -Filter { SamAccountName -eq $SamAccount } -Properties Manager

      if ($null -like $UserObject) {
        Write-Host "`nA User Object with that SamAccountName was not found in Active Directory.`n" -BackgroundColor Black -ForegroundColor Yellow
      }
      else {
        $IteratorUserObject = $UserObject

        do {
          $IteratorUserObject = Get-ADUser -Filter { DistinguishedName -eq $IteratorUserObject.Manager } -Properties Manager, DirectReports, Mail
        } until ($UserObject.DistinguishedName -in $IteratorUserObject.DirectReports)

        $prop = [ordered]@{
          UserName           = $UserObject.Name
          UserSamAccountName = $UserObject.SamAccountName
          ManagerName        = $IteratorUserObject.Name
          SamAccountName     = $IteratorUserObject.SamAccountName
          ManagerMail        = $IteratorUserObject.Mail
        }
  
        $obj = New-Object -TypeName psobject -Property $prop
        Write-Output $obj
      }


    }

  }
  
  end {}
}