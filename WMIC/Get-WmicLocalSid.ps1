<#
.SYNOPSIS
  The "Get-WmicLocalSid" function is a WMIC command wrapper for getting a list of built-in SIDs and their corresponding human-readable names.

.DESCRIPTION
.EXAMPLE
  PS C:\> LocalSid | ft

  ComputerName  Name                          SID      Description                                 SIDType LocalAccount
  ------------  ----                          ---      -----------                                 ------- ------------
  LocLaptop-PC1 Everyone                      S-1-1-0  LocLaptop-PC1\Everyone                      5       TRUE
  LocLaptop-PC1 LOCAL                         S-1-2-0  LocLaptop-PC1\LOCAL                         5       TRUE
  LocLaptop-PC1 CREATOR OWNER                 S-1-3-0  LocLaptop-PC1\CREATOR OWNER                 5       TRUE
  LocLaptop-PC1 CREATOR GROUP                 S-1-3-1  LocLaptop-PC1\CREATOR GROUP                 5       TRUE
  LocLaptop-PC1 CREATOR OWNER SERVER          S-1-3-2  LocLaptop-PC1\CREATOR OWNER SERVER          5       TRUE
  LocLaptop-PC1 CREATOR GROUP SERVER          S-1-3-3  LocLaptop-PC1\CREATOR GROUP SERVER          5       TRUE
  LocLaptop-PC1 OWNER RIGHTS                  S-1-3-4  LocLaptop-PC1\OWNER RIGHTS                  5       TRUE
  LocLaptop-PC1 DIALUP                        S-1-5-1  LocLaptop-PC1\DIALUP                        5       TRUE
  LocLaptop-PC1 NETWORK                       S-1-5-2  LocLaptop-PC1\NETWORK                       5       TRUE
  LocLaptop-PC1 BATCH                         S-1-5-3  LocLaptop-PC1\BATCH                         5       TRUE
  LocLaptop-PC1 INTERACTIVE                   S-1-5-4  LocLaptop-PC1\INTERACTIVE                   5       TRUE
  LocLaptop-PC1 SERVICE                       S-1-5-6  LocLaptop-PC1\SERVICE                       5       TRUE
  LocLaptop-PC1 ANONYMOUS LOGON               S-1-5-7  LocLaptop-PC1\ANONYMOUS LOGON               5       TRUE
  LocLaptop-PC1 PROXY                         S-1-5-8  LocLaptop-PC1\PROXY                         5       TRUE
  LocLaptop-PC1 SYSTEM                        S-1-5-18 LocLaptop-PC1\SYSTEM                        5       TRUE
  LocLaptop-PC1 ENTERPRISE DOMAIN CONTROLLERS S-1-5-9  LocLaptop-PC1\ENTERPRISE DOMAIN CONTROLLERS 5       TRUE
  LocLaptop-PC1 SELF                          S-1-5-10 LocLaptop-PC1\SELF                          5       TRUE
  LocLaptop-PC1 Authenticated Users           S-1-5-11 LocLaptop-PC1\Authenticated Users           5       TRUE
  LocLaptop-PC1 RESTRICTED                    S-1-5-12 LocLaptop-PC1\RESTRICTED                    5       TRUE
  LocLaptop-PC1 TERMINAL SERVER USER          S-1-5-13 LocLaptop-PC1\TERMINAL SERVER USER          5       TRUE
  LocLaptop-PC1 REMOTE INTERACTIVE LOGON      S-1-5-14 LocLaptop-PC1\REMOTE INTERACTIVE LOGON      5       TRUE
  LocLaptop-PC1 IUSR                          S-1-5-17 LocLaptop-PC1\IUSR                          5       TRUE
  LocLaptop-PC1 LOCAL SERVICE                 S-1-5-19 LocLaptop-PC1\LOCAL SERVICE                 5       TRUE
  LocLaptop-PC1 NETWORK SERVICE               S-1-5-20 LocLaptop-PC1\NETWORK SERVICE               5       TRUE
  LocLaptop-PC1 BUILTIN                       S-1-5-32 LocLaptop-PC1\BUILTIN                       3       TRUE



  Here we run the function using its built-in alias of "localsid".  The output consists of local SIDs and their corresponding group or identity name.

.INPUTS
.OUTPUTS
.NOTES
  Name: Get-WmicLocalSid.ps1
  Author: Travis Logue
  Version History: 1.0 | 2021-01-15 | Initial Version
  Dependencies:
  Notes:


  .
#>
function Get-WmicLocalSid {
  [CmdletBinding()]
  [Alias('LocalSid')]
  param (
    [Parameter(HelpMessage='Reference the computer(s) to query.')]
    [string[]]
    $ComputerName
  )
  
  begin {}
  
  process {

    $wmic = 'wmic.exe'
    [array]$param = @()

    # WMIC requirement: If the hostname has a "-" or a "/" then wrap the hostname in double quotes    
    if ($null -like $ComputerName) {
      $ComputerName = HOSTNAME.EXE
    }    

    $AllResults = foreach ($Computer in $ComputerName) {

      # WMIC requirement: If the hostname has a "-" or a "/" then wrap the hostname in double quotes
      $param = "/node:`"$($Computer)`"",'sysaccount','list','full'     
      $Results = & $wmic $param #| Where-Object {$_}
      $WmicSysAccountListFull = $Results + "END OF THE LINE"    
      
      for ($i = 0; $i -lt $WmicSysAccountListFull.Count; $i++) {
        if ($WmicSysAccountListFull[$i] -like "Description=*") {
          $counter = 0
          $ObjectArray = @()
          do {
            $ObjectArray += $WmicSysAccountListFull[$i + $counter]
            $counter += 1
          } until ($WmicSysAccountListFull[$i+1 + $counter] -like "Description=*" -or $WmicSysAccountListFull[$i+ $counter] -like "END OF THE LINE") 
    
          foreach ($e in $ObjectArray) {
            switch -regex ($e) {
              '^Description=' { $Description_Value = (($e -split "=",2).trim())[1] }
              '^Domain=' { $Domain_Value = (($e -split "=",2).trim())[1] }
              '^InstallDate=' { $InstallDate_Value = (($e -split "=",2).trim())[1] }
              '^LocalAccount=' { $LocalAccount_Value = (($e -split "=",2).trim())[1] }
              '^Name=' { $Name_Value = (($e -split "=",2).trim())[1] }
              '^SID=' { $SID_Value = (($e -split "=",2).trim())[1] }
              '^SIDType=' { $SIDType_Value = (($e -split "=",2).trim())[1] }
              '^Status=' { $Status_Value = (($e -split "=",2).trim())[1] }
            }
          }

          $prop = @{
            ComputerName = $Computer
            Description = $Description_Value
            Domain = $Domain_Value
            InstallDate = $InstallDate_Value
            LocalAccount = $LocalAccount_Value
            Name = $Name_Value
            SID = $SID_Value
            SIDType = $SIDType_Value
            Status = $Status_Value
          }
    
          $obj = New-Object -TypeName psobject -Property $prop
          Write-Output $obj
        }
      }
    }

    #Write-Output $AllResults

    $SpecificSelectionOrder = $AllResults | Select-Object ComputerName,Name,SID,Description,SIDType,LocalAccount #,Domain,Status,InstallDate

    Write-Output $SpecificSelectionOrder


  }
  
  end {}
}