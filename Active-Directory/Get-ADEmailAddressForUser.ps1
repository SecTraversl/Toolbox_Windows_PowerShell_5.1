<#
.SYNOPSIS
  The "Get-ADEmailAddressForUser" function takes the SamAccountName of Active Directory users and determines what the corresponding E-mail address is for that user by evaluating the "Mail" property of the User Object in Active Directory.

.DESCRIPTION
.EXAMPLE
  PS C:\> Get-ADEmailAddressForUser -SamAccountName 'Jannus.Fugal'

  Name         SamAccountName Mail
  ----         -------------- ----
  Jannus Fugal Jannus.Fugal   Jannus.Fugal@Roxboard.com


  PS C:\> ADEmailAddressForUser 'Jannus.Fugal'

  Name         SamAccountName Mail
  ----         -------------- ----
  Jannus Fugal Jannus.Fugal   Jannus.Fugal@Roxboard.com



  Here we demonstrate the verbose and the fast way to run this function.  'ADEmailAddressForUser' is the built-in alias for "Get-ADEmailAddressForUser" and we show here how we can use it to get the same results as we did when running the function using the full name (the first example) along with an explicit reference to the "-SamAccountName" parameter.

.EXAMPLE
  PS C:\> Invoke-ADUserNameChecker -Name 'Jannus Fugal'

  Name         AccountFound SamAccountName                 Mail
  ----         ------------ --------------                 ----
  Jannus Fugal         True {a-Jannus.Fugal, Jannus.Fugal} {$null, Jannus.Fugal@Roxboard.com}


  PS C:\> ADNameChecker 'Jannus Fugal'

  Name         AccountFound SamAccountName                 Mail
  ----         ------------ --------------                 ----
  Jannus Fugal         True {a-Jannus.Fugal, Jannus.Fugal} {$null, Jannus.Fugal@Roxboard.com}


  PS C:\> ADNameChecker 'Jannus Fugal' | ADEmailAddressForUser

  Name         SamAccountName Mail
  ----         -------------- ----
  Jannus Fugal a-Jannus.Fugal
  Jannus Fugal Jannus.Fugal   Jannus.Fugal@Roxboard.com



  Here we demonstrate the use of a chain of functions and how they can be used together.  We first demonstrate the use of "Invoke-ADUserNameChecker" and its built-in alias 'ADNameChecker' in order to retrieve the SamAccountName for a specic user's Name.  From there, we are able to pipe that object to 'ADEmailAddressForUser' (the built-in alias for "Get-ADEmailAddressForUser") in order to gain additional information about the user.

.INPUTS
.OUTPUTS
.NOTES
  Name:  Get-ADEmailAddressForUser.ps1
  Author:  Travis Logue
  Version History:  1.1 | 2021-03-08 | Initial Version
  Dependencies:  Active Directory Module
  Notes:


  . 
#>
function Get-ADEmailAddressForUser {
  [CmdletBinding()]
  [Alias('ADEmailAddressForUser')]
  param (
    [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
    [string[]]
    $SamAccountName
  )
  
  begin {}
  
  process {
    
    foreach ($SamAccount in $SamAccountName) {

      $UserObject = Get-ADUser -Identity $SamAccount -Properties Mail

      $prop = [ordered]@{
        Name           = $UserObject.name
        SamAccountName = $UserObject.SamAccountName
        Mail           = $UserObject.Mail
      }

      $obj = New-Object -TypeName psobject -Property $prop
      Write-Output $obj

    }

  }
  
  end {}
}