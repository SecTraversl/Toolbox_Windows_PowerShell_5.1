<#
.SYNOPSIS
  The "Get-CurrentUserPrivileges" function is a wrapper for "whoami.exe /priv" and displays the privileges of the current user.
  
.DESCRIPTION
.EXAMPLE
  PS C:\> Get-CurrentUserPrivileges

  Username          PrivilegeName                             State    Description
  --------          -------------                             -----    -----------
  corp\mark.johnson SeLockMemoryPrivilege                     Disabled Lock pages in memory
  corp\mark.johnson SeIncreaseQuotaPrivilege                  Disabled Adjust memory quotas for a process
  corp\mark.johnson SeSecurityPrivilege                       Disabled Manage auditing and security log
  corp\mark.johnson SeTakeOwnershipPrivilege                  Disabled Take ownership of files or other objects
  corp\mark.johnson SeLoadDriverPrivilege                     Disabled Load and unload device drivers
  corp\mark.johnson SeSystemProfilePrivilege                  Disabled Profile system performance
  corp\mark.johnson SeSystemtimePrivilege                     Disabled Change the system time
  corp\mark.johnson SeProfileSingleProcessPrivilege           Disabled Profile single process
  corp\mark.johnson SeIncreaseBasePriorityPrivilege           Disabled Increase scheduling priority
  corp\mark.johnson SeCreatePagefilePrivilege                 Disabled Create a pagefile
  corp\mark.johnson SeBackupPrivilege                         Disabled Back up files and directories
  corp\mark.johnson SeRestorePrivilege                        Disabled Restore files and directories
  corp\mark.johnson SeShutdownPrivilege                       Disabled Shut down the system
  corp\mark.johnson SeDebugPrivilege                          Enabled  Debug programs
  corp\mark.johnson SeSystemEnvironmentPrivilege              Disabled Modify firmware environment values
  corp\mark.johnson SeChangeNotifyPrivilege                   Enabled  Bypass traverse checking
  corp\mark.johnson SeRemoteShutdownPrivilege                 Disabled Force shutdown from a remote system
  corp\mark.johnson SeUndockPrivilege                         Disabled Remove computer from docking station
  corp\mark.johnson SeManageVolumePrivilege                   Disabled Perform volume maintenance tasks
  corp\mark.johnson SeImpersonatePrivilege                    Enabled  Impersonate a client after authentication
  corp\mark.johnson SeCreateGlobalPrivilege                   Enabled  Create global objects
  corp\mark.johnson SeIncreaseWorkingSetPrivilege             Disabled Increase a process working set
  corp\mark.johnson SeTimeZonePrivilege                       Disabled Change the time zone
  corp\mark.johnson SeCreateSymbolicLinkPrivilege             Disabled Create symbolic links
  corp\mark.johnson SeDelegateSessionUserImpersonatePrivilege Disabled Obtain an impersonation token for another user in the same session



  Here we run the function, which displays all of the Privileges associated with the currently logged on user and whether each Privilege is Enabled/Disabled.

.INPUTS
.OUTPUTS
.NOTES
  Name: Get-CurrentUserPrivileges.ps1
  Author: Travis Logue
  Version History: 1.0 | 2021-01-29 | Initial Version
  Dependencies: 
  Notes:
  - This was a helpful reference for the syntax used below: https://stackoverflow.com/questions/11607389/how-to-view-user-privileges-using-windows-cmd

  .
#>
function Get-CurrentUserPrivileges {
  [CmdletBinding()]
  [Alias('Get-WhoamiPrivileges','CurrentUserPrivileges')]
  param (
    
  )
  
  begin {}
  
  process {

    $CurrentUser = whoami.exe
    $WhoAmIprivs = whoami.exe /priv | Select-Object -Skip 4

    $pattern = '^(?<PrivilegeName>\w+)\s+(?<Description>.*)\s(?<State>\w+)\s{0,1}$'

    foreach ($Line in $WhoAmIprivs) {
      if ($Line -match $pattern) {
        $obj = New-Object -TypeName psobject -Property $Matches
        $obj | Add-Member -NotePropertyName Username -NotePropertyValue $CurrentUser
        Write-Output $obj | Select-Object Username,PrivilegeName,State,Description
      }
    }

  }
  
  end {}
}

