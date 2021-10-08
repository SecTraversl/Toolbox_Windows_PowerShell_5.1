<#
.SYNOPSIS
  The "Get-ADAccountsWithDifferentEnabledValues" function identifies a user with multiple accounts in the domain where one of those accounts is disabled and the other is enabled (possibly revealing accounts that could be removed from Active Directory).

.DESCRIPTION
.EXAMPLE
  PS C:\> ADAccountsDifferentEnabledValues

  FirstAccount    FirstAccountEnabled SecondAccount   SecondAccountEnabled
  ------------    ------------------- -------------   --------------------
  v-dagendesh.wao               False a-dagendesh.wao                 True



  Here we run the "Get-ADAccountsWithDifferentEnabledValues" function by calling its alias 'ADAccountsDifferentEnabledValues'.  The tool returns information about a user that has one account disabled and another enabled, possibly making this a candidate for account removal.

.INPUTS
.OUTPUTS
.NOTES
  Name:  Get-ADAccountsWithDifferentEnabledValues.ps1
  Author:  Travis Logue
  Version History:  1.2 | 2021-08-31 | Updated aesthetics
  Dependencies:  ActiveDirectory module
  Notes:


  .
#>
function Get-ADAccountsWithDifferentEnabledValues {
  [CmdletBinding()]
  [Alias('ADAccountsDifferentEnabledValues')]
  param (
    [Parameter(HelpMessage = 'For Future Use. To be used to specify which domain to do the search.')]
    [string[]]
    $Server
  )
  
  begin {
    $AllUsersInPrimaryDomain = Get-ADUser -Filter "Name -like '*'"

    $Name_Seed = $AllUsersInPrimaryDomain | 
    Select-Object @{n = "Name_Seed"; e = { $_.SamAccountName -replace "^\w-", "" } }, Enabled, SamAccountName | 
    Sort-Object Name_Seed, Enabled
  }
  
  process {
    $Grouping = $Name_Seed | Group-Object name_seed | Sort-Object Count -Descending     
    $Group_2orMore = $Grouping | Where-Object { $_.count -gt 1 }
  }
  
  end {
    foreach ($Group in $Group_2orMore) {
      $FirstElement = $Group.Group[0]
      $SecondElement = $Group.Group[1]
    
      if ($FirstElement.Enabled -ne $SecondElement.Enabled) {
        $prop = [ordered]@{
          FirstAccount         = $FirstElement.SamAccountName
          FirstAccountEnabled  = $FirstElement.Enabled
          SecondAccount        = $SecondElement.SamAccountName
          SecondAccountEnabled = $SecondElement.Enabled
        }
        $obj = New-Object -TypeName psobject -Property $prop
        Write-Output $obj
      }
    } 
  }
}