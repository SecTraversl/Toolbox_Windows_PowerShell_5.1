<#
.SYNOPSIS
  The "Get-WmicNetLoginAccount" function is a WMIC command wrapper for getting a list of User Account information for accounts that have had a network login event to the system we are querying.  Information for local user accounts and domain user accounts is retrieved in this output.

.DESCRIPTION
.EXAMPLE
  PS C:\> $NetLoginAccounts = Get-WmicNetLoginAccount
  PS C:\> $NetLoginAccounts | sort fullname -Descending | select -f 1


  ComputerName       : LocLaptop-PC1
  Name               : CORP\mark.johnson
  FullName           : mark.johnson
  UserId             : 57276
  PrimaryGroupId     : 513
  NumberOfLogons     : 3807
  LastLogon          : 20201214112133.000000-480
  BadPasswordCount   : 0
  PasswordAge        : 00000010222429.000000:000
  PasswordExpires    : 20210303171936.000000-480
  HomeDirectoryDrive : H:
  HomeDirectory      : \\huffmin\users$\mark.johnson
  LogonHours         : Sunday: No Limit -- Monday: No Limit -- Tuesday: No Limit -- Wednesday: No Limit -- Thursday: No Limit -- Friday: No Limit --
                      Saturday: No Limit
  Description        : Network login profile settings for mark.johnson on CORP
  MaximumStorage     : 4294967295
  Privileges         : 1
  AuthorizationFlags : 0
  UserType           : Normal Account
  Flags              : 545
  UnitsPerWeek       : 168
  LogonServer        : \\*
  LastLogoff         : **************.******+***
  CountryCode        : 0
  AccountExpires     :



  Here we run the function without additional parameters which, by default, queries the local machine.  The output contains information about user accounts that have logged onto the system, including User Account Name, SID Suffix (UserID property), LastLogon, BadPasswordCount and more.  

.EXAMPLE
  PS C:\> $list
  LocLaptop-PC1
  RemDesktopPC.corp.Roxboard.com
  PS C:\>
  PS C:\> $NetLoginAccounts = Get-WmicNetLoginAccount -ComputerName $list
  PS C:\> $NetLoginAccounts | sort PrimaryGroupId -Descending | ft

  ComputerName                   Name                         FullName     UserId PrimaryGroupId NumberOfLogons LastLogon                 BadPasswordCount
  ------------                   ----                         --------     ------ -------------- -------------- ---------                 ----------------
  RemDesktopPC.corp.Roxboard.com RemDesktopPC\Administrator                500    513            12             20180509160737.000000-420 0
  LocLaptop-PC1                  LocLaptop-PC1\Administrator               500    513            10             20200225082441.000000-480 0
  RemDesktopPC.corp.Roxboard.com LocLaptop-PC1\MYusehr                     1004   513            1              20201118145359.000000-480 0
  RemDesktopPC.corp.Roxboard.com RemDesktopPC\MYusehr         MYusehr      1005   513            6              20200731122348.000000-420 0
  RemDesktopPC.corp.Roxboard.com LocLaptop-PC1\Administrator               500    513            10             20200225082441.000000-480 0
  LocLaptop-PC1                  LocLaptop-PC1\MYusehr                     1004   513            1              20201118145359.000000-480 0
  RemDesktopPC.corp.Roxboard.com CORP\mark.johnson            mark.johnson 57276  513            3807           20201214112133.000000-480 0
  LocLaptop-PC1                  CORP\mark.johnson            mark.johnson 57276  513            3807           20201214112133.000000-480 0
  RemDesktopPC.corp.Roxboard.com NT AUTHORITY\LOCAL SERVICE
  RemDesktopPC.corp.Roxboard.com CORP\mark.johnson
  RemDesktopPC.corp.Roxboard.com NT AUTHORITY\NETWORK SERVICE
  LocLaptop-PC1                  NT AUTHORITY\SYSTEM
  RemDesktopPC.corp.Roxboard.com CORP\t-scanvuln
  RemDesktopPC.corp.Roxboard.com CORP\a-mark.johnson
  RemDesktopPC.corp.Roxboard.com NT AUTHORITY\SYSTEM



  Here we have an array of computer names that we reference using the "-ComputerName" parameter in the function.  We store the results of the query to both computers in the variable "$NetLoginAccounts", sort the output based on the "PrimaryGroupId" property, and use the "Format-Table" cmdlet (or "ft") to display the results as a table.

.INPUTS
.OUTPUTS
.NOTES
  Name: Get-WmicNetLoginAccount
  Author: Travis Logue
  Version History: 1.0 | 2020-12-21 | Initial Version
  Dependencies:
  Notes:


  .
#>
function Get-WmicNetLoginAccount {
  [CmdletBinding()]
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
      $param = "/node:`"$($Computer)`"",'netlogin','list','full'     
      $Results = & $wmic $param | Where-Object {$_}
      $WmicNetLoginListFull = $Results + "END OF THE LINE"    
      
      for ($i = 0; $i -lt $WmicNetLoginListFull.Count; $i++) {
        if ($WmicNetLoginListFull[$i] -like "AccountExpires=*") {
          $counter = 0
          $ObjectArray = @()
          do {
            $ObjectArray += $WmicNetLoginListFull[$i + $counter]
            $counter += 1
          } until ($WmicNetLoginListFull[$i+1 + $counter] -like "AccountExpires=*" -or $WmicNetLoginListFull[$i+ $counter] -like "END OF THE LINE") 
    
          foreach ($e in $ObjectArray) {
            switch -regex ($e) {
              '^AccountExpires=' { $AccountExpires_Value = (($e -split "=",2).trim())[1] }
              '^AuthorizationFlags=' { $AuthorizationFlags_Value = (($e -split "=",2).trim())[1] }
              '^BadPasswordCount=' { $BadPasswordCount_Value = (($e -split "=",2).trim())[1] }
              '^Comment=' { $Comment_Value = (($e -split "=",2).trim())[1] }
              '^CountryCode=' { $CountryCode_Value = (($e -split "=",2).trim())[1] }
              '^Description=' { $Description_Value = (($e -split "=",2).trim())[1] }
              '^Flags=' { $Flags_Value = (($e -split "=",2).trim())[1] }
              '^FullName=' { $FullName_Value = (($e -split "=",2).trim())[1] }
              '^HomeDirectory=' { $HomeDirectory_Value = (($e -split "=",2).trim())[1] }
              '^HomeDirectoryDrive=' { $HomeDirectoryDrive_Value = (($e -split "=",2).trim())[1] }
              '^LastLogoff=' { $LastLogoff_Value = (($e -split "=",2).trim())[1] }
              '^LastLogon=' { $LastLogon_Value = (($e -split "=",2).trim())[1] }
              '^LogonHours=' { $LogonHours_Value = (($e -split "=",2).trim())[1] }
              '^LogonServer=' { $LogonServer_Value = (($e -split "=",2).trim())[1] }
              '^MaximumStorage=' { $MaximumStorage_Value = (($e -split "=",2).trim())[1] }
              '^Name=' { $Name_Value = (($e -split "=",2).trim())[1] }
              '^NumberOfLogons=' { $NumberOfLogons_Value = (($e -split "=",2).trim())[1] }
              '^Parameters=' { $Parameters_Value = (($e -split "=",2).trim())[1] }
              '^PasswordAge=' { $PasswordAge_Value = (($e -split "=",2).trim())[1] }
              '^PasswordExpires=' { $PasswordExpires_Value = (($e -split "=",2).trim())[1] }
              '^PrimaryGroupId=' { $PrimaryGroupId_Value = (($e -split "=",2).trim())[1] }
              '^Privileges=' { $Privileges_Value = (($e -split "=",2).trim())[1] }
              '^Profile=' { $Profile_Value = (($e -split "=",2).trim())[1] }
              '^ScriptPath=' { $ScriptPath_Value = (($e -split "=",2).trim())[1] }
              '^SettingID=' { $SettingID_Value = (($e -split "=",2).trim())[1] }
              '^UnitsPerWeek=' { $UnitsPerWeek_Value = (($e -split "=",2).trim())[1] }
              '^UserComment=' { $UserComment_Value = (($e -split "=",2).trim())[1] }
              '^UserId=' { $UserId_Value = (($e -split "=",2).trim())[1] }
              '^UserType=' { $UserType_Value = (($e -split "=",2).trim())[1] }
              '^Workstations=' { $Workstations_Value = (($e -split "=",2).trim())[1] }
            }
          }

          $prop = @{
            ComputerName = $Computer
            AccountExpires = $AccountExpires_Value
            AuthorizationFlags = $AuthorizationFlags_Value
            BadPasswordCount = $BadPasswordCount_Value
            Comment = $Comment_Value
            CountryCode = $CountryCode_Value
            Description = $Description_Value
            Flags = $Flags_Value
            FullName = $FullName_Value
            HomeDirectory = $HomeDirectory_Value
            HomeDirectoryDrive = $HomeDirectoryDrive_Value
            LastLogoff = $LastLogoff_Value
            LastLogon = $LastLogon_Value
            LogonHours = $LogonHours_Value
            LogonServer = $LogonServer_Value
            MaximumStorage = $MaximumStorage_Value
            Name = $Name_Value
            NumberOfLogons = $NumberOfLogons_Value
            Parameters = $Parameters_Value
            PasswordAge = $PasswordAge_Value
            PasswordExpires = $PasswordExpires_Value
            PrimaryGroupId = $PrimaryGroupId_Value
            Privileges = $Privileges_Value
            Profile = $Profile_Value
            ScriptPath = $ScriptPath_Value
            SettingID = $SettingID_Value
            UnitsPerWeek = $UnitsPerWeek_Value
            UserComment = $UserComment_Value
            UserId = $UserId_Value
            UserType = $UserType_Value
            Workstations = $Workstations_Value
          }
    
          $obj = New-Object -TypeName psobject -Property $prop
          Write-Output $obj
        }
      }
    }

    #Write-Output $AllResults

    $SpecificSelectionOrder = $AllResults | Select-Object ComputerName,Name,FullName,UserId,PrimaryGroupId,NumberOfLogons,LastLogon,BadPasswordCount,PasswordAge,PasswordExpires,HomeDirectoryDrive,HomeDirectory,LogonHours,Description,MaximumStorage,Privileges,AuthorizationFlags,UserType,Flags,UnitsPerWeek,LogonServer,LastLogoff,CountryCode,AccountExpires,Comment,Parameters,Profile,ScriptPath,SettingID,UserComment,Workstations

    Write-Output $SpecificSelectionOrder


  }
  
  end {}
}