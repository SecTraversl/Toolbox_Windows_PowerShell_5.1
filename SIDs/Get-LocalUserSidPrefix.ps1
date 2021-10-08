function Get-LocalUserSidPrefix {
  [CmdletBinding()]
  [Alias('LocalUserPrefix')]
  param (
    [Parameter(HelpMessage='This Switch Parameter is used to display all of the Local Users, their Enabled status, their SID, and the user SID prefix for the local computer')]
    [switch]
    $DisplayLocalUsers
  )
  
  begin {}
  
  process {
    
    if ($DisplayLocalUsers) {
      Get-LocalUser | % {  
        $prop = [ordered]@{
          Name = $_.Name
          Enabled = $_.Enabled
          SID = $_.SID
          UserSIDPrefix = $_.SID -replace "-\d+$"
        }
        $obj = New-Object -TypeName psobject -Property $prop
        Write-Output $obj      
      }
    }
    else {
      Get-LocalUser | % { $_.SID -replace "-\d+$" } | Sort-Object -Unique
    }

  }
  
  end {}
}

<#
Get-LocalUser | Select-Object Name,Enabled,SID,LastLogon,PasswordLastSet,PasswordChangeableDate,PasswordExpires,PasswordRequired,UserMayChangePassword,Description,PrincipalSource,ObjectClass,FullName,AccountExpires
#>