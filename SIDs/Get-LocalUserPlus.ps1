
function Get-LocalUserPlus {
  [CmdletBinding()]
  [Alias('LocalUserPlus','glup','LocalUserSid')]
  param ()
  
  begin {}
  
  process {
    Get-LocalUser | Select-Object Name,Enabled,SID,LastLogon,PasswordLastSet,PasswordChangeableDate,PasswordExpires,PasswordRequired,UserMayChangePassword,Description,PrincipalSource,ObjectClass,FullName,AccountExpires
  }
  
  end {}
}