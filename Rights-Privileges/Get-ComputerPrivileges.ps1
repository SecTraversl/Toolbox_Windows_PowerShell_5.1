<#
.SYNOPSIS
  The "Get-ComputerPrivileges" function uses the output from the "SecEdit.exe" tool in order to retrieve Privileges that exist on a computer and the NTAccounts/SIDs that possess them.
  
.DESCRIPTION
.EXAMPLE
  PS C:\> get*priv <tab>
  PS C:\> Get-ComputerPrivileges

  

  Here we are demonstrating a fast way to invoke this function.  Simply typing "get*priv" and then pressing the Tab key should result in the full function name.

.EXAMPLE
  PS C:\> $Privileges = Get-ComputerPrivileges

  Now running...:  'secedit /export /areas USER_RIGHTS /cfg SecEdit_UserRights_TempFile.txt'


  Now running...:  'Remove-Item SecEdit_UserRights_TempFile.txt'


  PS C:\> $Privileges | ? privilege -eq 'SeImpersonatePrivilege'

  Privilege              NTAccount                    SID
  ---------              ---------                    ---
  SeImpersonatePrivilege NT AUTHORITY\LOCAL SERVICE   S-1-5-19
  SeImpersonatePrivilege NT AUTHORITY\NETWORK SERVICE S-1-5-20
  SeImpersonatePrivilege BUILTIN\Administrators       S-1-5-32-544
  SeImpersonatePrivilege NT AUTHORITY\SERVICE         S-1-5-6



  Here we run the function without any additional parameters.  By default, the function will run the 'secedit' command and create a temporary file pertaining to Rights and Privileges on the computer.  Once the function is complete, the temporary file is removed automatically. We captured the output of the function in the variable "$Privileges" and then specifically output all objects where the privilege was equal to 'SeImpersonatePrivilege' using the "Where-Object" alias "?".

.EXAMPLE
  PS C:\> Get-ComputerPrivileges -ListMaleficentSevenTable | ft -Wrap

  MaleficentPrivilege      Description
  -------------------      -----------
  SeImpersonatePrivilege   Impersonation is one of the most used privileges in Windows. It allows for a user, program, or thread to
                          impersonate a client or specified account. Programs, threads, or services use this privilege to perform
                          tasks that require different permissions. A "user sends requests and commands over the network to the
                          server; the service uses the Security Access Table (SAT) representing the user to act on behalf of the
                          user" (Fossen, Securing Windows with PowerShell and the Critical Security Controls, 2016). Tools like
                          Incognito use this privilege to impersonate users.  ("Maleficent Seven", in Notes section)
  SeDebugPrivilege         This privilege is not needed by a developer in order to debug their program, because users by default can
                          debug their own application.  This privilege gives the ability to attach to any program and read. Tools
                          such as Mimikatz (Metcalf, 2016), or reflective DLL injection (Graham, 2016) use this privilege. By
                          default, only the local Administrators group has the Debug Programs privilege (Fossen, Securing Windows
                          with PowerShell and the Critical Security Controls, 2016).  ("Maleficent Seven", in Notes section)
  SeTcbPrivilege           The SeTcbPrivilege privilege allows a user or process to act as part of the operating system. If a user or
                          process has this privilege, it can request any other privilege and can even create a token that does not
                          have an identity. Microsoft describes a token (specifically, a SAT) as: "an object that describes the
                          security context of a process or thread. The information in a token includes the identity and privileges of
                          the user account associated with the process or thread" (Microsoft, 2017). A user with this privilege is
                          like a user with a golden ticket (Warren, 2017). The user can create tickets that can mimic other users.
                          ("Maleficent Seven", in Notes section)
  SeCreateTokenPrivilege   Windows creates a Security Access Token (SAT) for a user when they logon to the system. As resource
                          requests occur from the user, the SAT is referenced in order to validate that access is allowed. With the
                          SeCreateTokenPrivilege, a user is able to grant themselves access to the local administrators group.
                          ("Maleficent Seven", in Notes section)
  SeLoadDriverPrivilege    Users will be able to load and unload device drivers at will with the SeLoadDriverPrivilege. The
                          SeLoadDriverPrivilege could be used to load a malicious driver into the operating system. Device drivers
                          run at kernel level allowing them to circumvent any operating restrictions. Under some conditions, this
                          privilege, with some registry tricks, would allow for an unsigned driver to be loaded.  ("Maleficent
                          Seven", in Notes section)
  SeRestorePrivilege       The SeRestorePrivilege (which is used to restore files) can be assigned to other groups or users outside of
                          the Backup Operators group. With this privilege, a user can bypass current permissions in order to restore
                          a file or directory. The SeRestorePrivilege is the equivalent of giving a user "Traverse folder / Execute
                          file and Write" permissions on all files and directories; thereby allowing for a bypass of "NTFS
                          permissions and replace any file".  Consequently, this allows for files to be "backdoored" (Fossen,
                          Securing Windows with PowerShell and the Critical Security Controls, 2016).  ("Maleficent Seven", in Notes
                          section)
  SeTakeOwnershipPrivilege A user or process with the SeOwnershipPrivilege can take ownership of any Active Directory object. Objects
                          in the domain such as files, folders, registry keys, services, processes, and threads can be changed. Even
                          if access is denied via current permissions, this privilege allows for ownership of the file/folder to be
                          taken, and thereafter permissions can be changed in order to gain access.  ("Maleficent Seven", in Notes
                          section)



  Here we run the function using the "-ListMaleficentSevenTable", which returns a list of 7 Privileges that can and are used for malicious purposes along with why they are important.

.EXAMPLE
  PS C:\> Get-ComputerPrivileges -MaleficentSeven

  Privilege                NTAccount                    SID
  ---------                ---------                    ---
  SeDebugPrivilege         BUILTIN\Administrators       S-1-5-32-544
  SeLoadDriverPrivilege    BUILTIN\Administrators       S-1-5-32-544
  SeRestorePrivilege       BUILTIN\Administrators       S-1-5-32-544
  SeRestorePrivilege       BUILTIN\Backup Operators     S-1-5-32-551
  SeTakeOwnershipPrivilege BUILTIN\Administrators       S-1-5-32-544
  SeImpersonatePrivilege   NT AUTHORITY\LOCAL SERVICE   S-1-5-19
  SeImpersonatePrivilege   NT AUTHORITY\NETWORK SERVICE S-1-5-20
  SeImpersonatePrivilege   BUILTIN\Administrators       S-1-5-32-544
  SeImpersonatePrivilege   NT AUTHORITY\SERVICE         S-1-5-6



  Here we run the function by referencing the "-MaleficentSeven" switch parameter, which returns only the objects where the privilege is in the list of the "Maleficent Seven Privileges".

.EXAMPLE
  PS C:\> Get-ComputerPrivileges -GroupByPrivilege | ? privilege -eq 'SeUndockPrivilege'

  Now running...:  'secedit /export /areas USER_RIGHTS /cfg SecEdit_UserRights_TempFile.txt'

  The task has completed successfully. See log %windir%\security\logs\scesrv.log for detail info.


  Now running...:  'Remove-Item SecEdit_UserRights_TempFile.txt'

  Privilege         NTAccount                               SID
  ---------         ---------                               ---
  SeUndockPrivilege {BUILTIN\Administrators, BUILTIN\Users} {S-1-5-32-544, S-1-5-32-545}




  Here we run the function with the "-GroupByPrivilege" switch parameter.  This shows all of the NTAccounts and SIDs that have the given privilege all in one object.

.INPUTS
.OUTPUTS
.NOTES
  Name: Get-ComputerPrivileges.ps1
  Author: Travis Logue
  Version History: 3.0 | 2021-02-08 | Various code clean-up actions
  Dependencies:
  Notes:
  - This was helpful in presenting code such as "$sid.Translate([Security.Principal.NTAcccount])" and more: https://www.powershellbros.com/get-user-rights-assignment-security-policy-settings/
  - The information concerning the "Maleficent Seven" was derived from "The Effectiveness of Tools in Detecting the 'Maleficent Seven' Privileges in the Windows Environment" by Tobais McCurry, a white paper from SANS Reading room: https://www.sans.org/reading-room/whitepapers/threathunting/effectiveness-tools-detecting-maleficent-seven-privileges-windows-environment-38220

  .
#>
function Get-ComputerPrivileges {
  [CmdletBinding()]
  param (
    [Parameter(HelpMessage='This Switch Parameter returns the set of the "Maleficent Seven" privileges and a description of why they are important.')]
    [switch]
    $ListMaleficentSevenTable,
    [Parameter(HelpMessage='This Switch Parameter filters only on objects within the "Maleficent Seven" set of privileges.')]
    [switch]
    $MaleficentSeven,
    [Parameter(HelpMessage='This Switch Parameter is used to display the output for each privilege, all within one object per privilege.')]
    [switch]
    $GroupByPrivilege
  )
  
  begin {}
  
  process {

    if ($ListMaleficentSevenTable) {
      # Modeled after the embedded .csv table in Get-CountryCodesAndContinents.ps1

      $MaleficentSevenArray = [System.Collections.ArrayList]@(
        @('SeImpersonatePrivilege', 'Impersonation is one of the most used privileges in Windows. It allows for a user, program, or thread to impersonate a client or specified account. Programs, threads, or services use this privilege to perform tasks that require different permissions. A "user sends requests and commands over the network to the server; the service uses the Security Access Table (SAT) representing the user to act on behalf of the user" (Fossen, Securing Windows with PowerShell and the Critical Security Controls, 2016). Tools like Incognito use this privilege to impersonate users.  ("Maleficent Seven", in Notes section)'),
        @('SeDebugPrivilege', 'This privilege is not needed by a developer in order to debug their program, because users by default can debug their own application.  This privilege gives the ability to attach to any program and read. Tools such as Mimikatz (Metcalf, 2016), or reflective DLL injection (Graham, 2016) use this privilege. By default, only the local Administrators group has the Debug Programs privilege (Fossen, Securing Windows with PowerShell and the Critical Security Controls, 2016).  ("Maleficent Seven", in Notes section)'),
        @('SeTcbPrivilege', 'The SeTcbPrivilege privilege allows a user or process to act as part of the operating system. If a user or process has this privilege, it can request any other privilege and can even create a token that does not have an identity. Microsoft describes a token (specifically, a SAT) as: "an object that describes the security context of a process or thread. The information in a token includes the identity and privileges of the user account associated with the process or thread" (Microsoft, 2017). A user with this privilege is like a user with a golden ticket (Warren, 2017). The user can create tickets that can mimic other users.  ("Maleficent Seven", in Notes section)'),
        @('SeCreateTokenPrivilege', 'Windows creates a Security Access Token (SAT) for a user when they logon to the system. As resource requests occur from the user, the SAT is referenced in order to validate that access is allowed. With the SeCreateTokenPrivilege, a user is able to grant themselves access to the local administrators group.  ("Maleficent Seven", in Notes section)'),
        @('SeLoadDriverPrivilege', 'Users will be able to load and unload device drivers at will with the SeLoadDriverPrivilege. The SeLoadDriverPrivilege could be used to load a malicious driver into the operating system. Device drivers run at kernel level allowing them to circumvent any operating restrictions. Under some conditions, this privilege, with some registry tricks, would allow for an unsigned driver to be loaded.  ("Maleficent Seven", in Notes section)'),
        @('SeRestorePrivilege', 'The SeRestorePrivilege (which is used to restore files) can be assigned to other groups or users outside of the Backup Operators group. With this privilege, a user can bypass current permissions in order to restore a file or directory. The SeRestorePrivilege is the equivalent of giving a user "Traverse folder / Execute file and Write" permissions on all files and directories; thereby allowing for a bypass of "NTFS permissions and replace any file".  Consequently, this allows for files to be "backdoored" (Fossen, Securing Windows with PowerShell and the Critical Security Controls, 2016).  ("Maleficent Seven", in Notes section)'),
        @('SeTakeOwnershipPrivilege', 'A user or process with the SeOwnershipPrivilege can take ownership of any Active Directory object. Objects in the domain such as files, folders, registry keys, services, processes, and threads can be changed. Even if access is denied via current permissions, this privilege allows for ownership of the file/folder to be taken, and thereafter permissions can be changed in order to gain access.  ("Maleficent Seven", in Notes section)') 
      )

      $ObjectForm = foreach ($Line in $MaleficentSevenArray) {
        $prop = [ordered]@{
          MaleficentPrivilege = $Line[0]
          Description = $Line[1]
        }

        $obj = New-Object -TypeName psobject -Property $prop
        Write-Output $obj
      }

      Write-Output $ObjectForm
    } 
    else  {
      # Creating a temporary output file using the "secedit" command
      Write-Host "`nNow running...:  'secedit /export /areas USER_RIGHTS /cfg SecEdit_UserRights_TempFile.txt'`n" -BackgroundColor Black -ForegroundColor Yellow

      $ScreenOutputNoticesOfSecEdit = secedit /export /areas USER_RIGHTS /cfg SecEdit_UserRights_TempFile.txt 
      Write-Host $ScreenOutputNoticesOfSecEdit.TrimStart() 
      $SecEditOutputFile = Get-Content SecEdit_UserRights_TempFile.txt
      $DeleteFile = $true

    }

    $ComputerPrivileges = $SecEditOutputFile | Select-String privilege | Out-String -Stream | ? {$_} | Select-Object -Skip 1
    $ParsedOutput = foreach ($Line in $ComputerPrivileges) {
      $SIDs = @()
      $Privilege = $Line -replace "\s.*"
      ($Line -replace ".* = ") -split ',' | % { $SIDs += ($_.TrimStart('*'))}

      $NTAccountArray = @()

      foreach ($SID in $SIDs) {

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
        Privilege = $Privilege
        NTAccount = $NTAccountArray
        SID = $SIDs
      }

      $obj = New-Object -TypeName psobject -Property $prop
      Write-Output $obj
    }

    if ($GroupByPrivilege) {
      Write-Output $ParsedOutput
    }
    else {
      $NewObjectSet = @()

      foreach ($Object in $ParsedOutput) {

        if ($Object.NTAccount -gt 1) {
          for ($i = 0; $i -lt $Object.NTAccount.Count; $i++) {

            $prop = [ordered]@{
              Privilege = $Object.Privilege
              NTAccount = $Object.NTAccount[$i]
              SID = $Object.SID[$i]
            }

            $obj = New-Object -TypeName psobject -Property $prop
            $NewObjectSet += $obj
          }
        }
        else {
          $prop = [ordered]@{
            Privilege = $Object.Privilege
            NTAccount = $Object.NTAccount
            SID = $Object.SID
          }

          $obj = New-Object -TypeName psobject -Property $prop
          $NewObjectSet += $obj
        }

      }

      if ($MaleficentSeven) {
        $MaleficentSevenPrivileges = @('SeImpersonatePrivilege', 'SeDebugPrivilege', 'SeTcbPrivilege', 'SeCreateTokenPrivilege', 'SeLoadDriverPrivilege', 'SeRestorePrivilege', 'SeTakeOwnershipPrivilege')

        $NewObjectSet | ? privilege -in $MaleficentSevenPrivileges

      }
      else {
        Write-Output $NewObjectSet        
      }

    }


    if ($DeleteFile) {
      # Removing the temporary file we created using the "secedit" command
      Write-Host "`nNow running...:  'Remove-Item SecEdit_UserRights_TempFile.txt'`n" -BackgroundColor Black -ForegroundColor Yellow
      
      Remove-Item SecEdit_UserRights_TempFile.txt
    }


  }
  
  end {}
}