<#
.SYNOPSIS
  The "Get-ComputerRights" function uses the output from the "SecEdit.exe" tool in order to retrieve Rights that exist on a computer and the NTAccounts/SIDs that possess them.
  
.DESCRIPTION
.EXAMPLE
  PS C:\> get*right <tab>
  PS C:\> Get-ComputerRights

  

  Here we are demonstrating a fast way to invoke this function.  Simply typing "get*right" and then pressing the Tab key should result in the full function name.

.EXAMPLE
  PS C:\> $Rights = Get-ComputerRights

  Now running...:  'secedit /export /areas USER_RIGHTS /cfg SecEdit_UserRights_TempFile.txt'

   The task has completed successfully. See log %windir%\security\logs\scesrv.log for detail info.

  Now running...:  'Remove-Item SecEdit_UserRights_TempFile.txt'

  PS C:\> $Rights

  Right                         NTAccount                     SID
  -----                         ---------                     ---
  SeNetworkLogonRight           Everyone                      S-1-1-0
  SeNetworkLogonRight           BUILTIN\Administrators        S-1-5-32-544
  SeNetworkLogonRight           BUILTIN\Users                 S-1-5-32-545
  SeNetworkLogonRight           BUILTIN\Backup Operators      S-1-5-32-551
  SeBatchLogonRight             BUILTIN\Administrators        S-1-5-32-544
  SeBatchLogonRight             BUILTIN\Backup Operators      S-1-5-32-551
  SeBatchLogonRight             BUILTIN\Performance Log Users S-1-5-32-559
  SeServiceLogonRight           NT SERVICE\ALL SERVICES       S-1-5-80-0
  SeInteractiveLogonRight       LocLaptop-PC1\WhoIsThisUser   S-1-5-21-1393510119-3594158528-2260630175-501
  SeInteractiveLogonRight       BUILTIN\Administrators        S-1-5-32-544
  SeInteractiveLogonRight       BUILTIN\Users                 S-1-5-32-545
  SeInteractiveLogonRight       BUILTIN\Backup Operators      S-1-5-32-551
  SeDenyNetworkLogonRight       LocLaptop-PC1\WhoIsThisUser   S-1-5-21-1393510119-3594158528-2260630175-501
  SeDenyInteractiveLogonRight   LocLaptop-PC1\WhoIsThisUser   S-1-5-21-1393510119-3594158528-2260630175-501
  SeRemoteInteractiveLogonRight BUILTIN\Administrators        S-1-5-32-544
  SeRemoteInteractiveLogonRight BUILTIN\Remote Desktop Users  S-1-5-32-555



  Here we run the function without any additional parameters.  By default, the function will run the 'secedit' command and create a temporary file pertaining to Rights and Privileges on the computer.  Once the function is complete, the temporary file is removed automatically.

.EXAMPLE
  PS C:\> $RightsGrouped = Get-ComputerRights -GroupByRight

  Now running...:  'secedit /export /areas USER_RIGHTS /cfg SecEdit_UserRights_TempFile.txt'

  The task has completed successfully. See log %windir%\security\logs\scesrv.log for detail info.

  Now running...:  'Remove-Item SecEdit_UserRights_TempFile.txt'

  PS C:\> $RightsGrouped | fl


  Right     : SeNetworkLogonRight
  NTAccount : {Everyone, BUILTIN\Administrators, BUILTIN\Users, BUILTIN\Backup Operators}
  SID       : {S-1-1-0, S-1-5-32-544, S-1-5-32-545, S-1-5-32-551}

  Right     : SeBatchLogonRight
  NTAccount : {BUILTIN\Administrators, BUILTIN\Backup Operators, BUILTIN\Performance Log Users}
  SID       : {S-1-5-32-544, S-1-5-32-551, S-1-5-32-559}

  Right     : SeServiceLogonRight
  NTAccount : {NT SERVICE\ALL SERVICES}
  SID       : {S-1-5-80-0}

  Right     : SeInteractiveLogonRight
  NTAccount : {LocLaptop-PC1\WhoIsThisUser, BUILTIN\Administrators, BUILTIN\Users, BUILTIN\Backup Operators}
  SID       : {S-1-5-21-1393510119-3594158528-2260630175-501, S-1-5-32-544, S-1-5-32-545, S-1-5-32-551}

  Right     : SeDenyNetworkLogonRight
  NTAccount : {LocLaptop-PC1\WhoIsThisUser}
  SID       : {S-1-5-21-1393510119-3594158528-2260630175-501}

  Right     : SeDenyInteractiveLogonRight
  NTAccount : {LocLaptop-PC1\WhoIsThisUser}
  SID       : {S-1-5-21-1393510119-3594158528-2260630175-501}

  Right     : SeRemoteInteractiveLogonRight
  NTAccount : {BUILTIN\Administrators, BUILTIN\Remote Desktop Users}
  SID       : {S-1-5-32-544, S-1-5-32-555}



  Here we run the function with the "-GroupByRight" switch parameter.  This shows all of the NTAccounts and SIDs that have the given Right all in one object.

.INPUTS
.OUTPUTS
.NOTES
  Name: Get-ComputerRights.ps1
  Author: Travis Logue
  Version History: 2.0 | 2021-02-08 | Code improvements and clean-up
  Dependencies:
  Notes:
  - This was helpful in presenting code such as "$sid.Translate([Security.Principal.NTAcccount])" and more: https://www.powershellbros.com/get-user-rights-assignment-security-policy-settings/


  .
#>
function Get-ComputerRights {
  [CmdletBinding()]
  param (
    [Parameter(HelpMessage='This Switch Parameter is used to display the output for each Right, all within one object per right.')]
    [switch]
    $GroupByRight
  )
  
  begin {}
  
  process {
    
    # Creating a temporary output file using the "secedit" command
    Write-Host "`nNow running...:  'secedit /export /areas USER_RIGHTS /cfg SecEdit_UserRights_TempFile.txt'`n" -BackgroundColor Black -ForegroundColor Yellow

    $ScreenOutputNoticesOfSecEdit = secedit /export /areas USER_RIGHTS /cfg SecEdit_UserRights_TempFile.txt 
    Write-Host $ScreenOutputNoticesOfSecEdit.TrimStart() 
    $SecEditOutputFile = Get-Content SecEdit_UserRights_TempFile.txt
    $DeleteFile = $true


    # We needed to do a separate lookup for the Guest account because the "secedit" output substitutes the name of the Guest account for the SID
    function Get-LocalGuestAccountSID {
      param ()
      $LocalPrefix = Get-LocalUser | % { $_.SID -replace "-\d+$" } | Sort-Object -Unique
      $LocalGuestAccountSID = $LocalPrefix + "-501"
      Write-Output $LocalGuestAccountSID      
    }

    $LocalGuestSID = Get-LocalGuestAccountSID
    $LocalGuestUserObject = Get-LocalUser -SID $LocalGuestSID


    # This removes the extra text, leaving only the output relevant to the "Rights"
    $ComputerRights = $SecEditOutputFile | Select-String right | Out-String -Stream | ? {$_} | Select-Object -Skip 1


    # For each line of text we separate out the "Right" from the "Users/Groups" that possess them
    $ParsedOutput = foreach ($Line in $ComputerRights) {
      $SIDs = @()
      $Right = $Line -replace "\s.*"
      ($Line -replace ".* = ") -split ',' | % { $SIDs += ($_.TrimStart('*'))}


      $NewSIDs = @()
      foreach ($SID in $SIDs) {
        if ($SID -eq $LocalGuestUserObject.Name) {
          $NewSIDs += $LocalGuestUserObject.SID
        }
        else {
          $NewSIDs += $SID
        }
      }

      $NTAccountArray = @()

      foreach ($SID in $NewSIDs) {

        try {
          $SIDObject = New-Object -TypeName System.Security.Principal.SecurityIdentifier($SID)  
          $NTAccountArray += ($SIDObject.Translate([Security.Principal.NTAccount])).Value
        }
        catch {
          $NTAccountArray += $null

          Write-Host "`nWe tried the command 'New-Object -TypeName System.Security.Principal.SecurityIdentifier(`$SID)' where `$SID has a value of: $SID`n" -ForegroundColor Yellow -BackgroundColor Black

          Write-Host "Ran into an issue: $($PSItem.ToString())`n`n" #This was the exception thrown: $($PSItem.Exception)          
        }       
         
      }

      $prop = [ordered]@{
        Right = $Right
        NTAccount = $NTAccountArray
        SID = $NewSIDs
      }

      $obj = New-Object -TypeName psobject -Property $prop
      Write-Output $obj
    }


    # Final output options
    if ($GroupByRight) {

      Write-Output $ParsedOutput

    }
    else {

      $NewObjectSet = @()

      foreach ($Object in $ParsedOutput) {

        if ($Object.NTAccount -gt 1) {
          for ($i = 0; $i -lt $Object.NTAccount.Count; $i++) {

            $prop = [ordered]@{
              Right = $Object.Right
              NTAccount = $Object.NTAccount[$i]
              SID = $Object.SID[$i]
            }

            $obj = New-Object -TypeName psobject -Property $prop
            $NewObjectSet += $obj
          }
        }
        else {
          $prop = [ordered]@{
            Right = $Object.Right
            NTAccount = $Object.NTAccount
            SID = $Object.SID
          }

          $obj = New-Object -TypeName psobject -Property $prop
          $NewObjectSet += $obj
        }

      }

      Write-Output $NewObjectSet       
      
    }


    if ($DeleteFile) {
      # Removing the temporary file we created using the "secedit" command
      Write-Host "`nNow running...:  'Remove-Item SecEdit_UserRights_TempFile.txt'`n" -BackgroundColor Black -ForegroundColor Yellow
      
      Remove-Item SecEdit_UserRights_TempFile.txt
    }


  }
  
  end {}
}