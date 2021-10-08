<#
.SYNOPSIS
  The "Find-LoggedOnUsersWithWmic" function searches for running instances of "explorer.exe" for one or many computers in order to determine what users are currently logged in to the GUI. 
  
.DESCRIPTION
.EXAMPLE
  PS C:\> Find-LoggedOnUsersWithWmic

  ComputerName     : LocLaptop-PC1
  ProcessName      : explorer.exe
  PID              : 3556
  PPID             : 3288
  ProcessOwner     : Jannus.Fugal
  FoundExplorerExe : True
  CommandLine      : C:\Windows\Explorer.EXE


  PS C:\> LoggedOnUsers

  ComputerName     : LocLaptop-PC1
  ProcessName      : explorer.exe
  PID              : 3556
  PPID             : 3288
  ProcessOwner     : Jannus.Fugal
  FoundExplorerExe : True
  CommandLine      : C:\Windows\Explorer.EXE


  
  Here we demonstrate the long and short way to run this function.  'LoggedOnUsers' is the built-in alias for "Find-LoggedOnUsersWithWmic" and we show here how we can use it to get the same results as we did when running the function using the full name (the first example).  If no other Computer Names are referenced, the function defaults to showing the information for the local host.


.EXAMPLE
  PS C:\> $loggedOnUsers = Find-LoggedOnUsersWithWmic -ComputerName 'RemDesktopPC','somejumpbox','RemJumpbox01',(HOSTNAME.EXE)

  No Instance(s) Available.

  PS C:\> $loggedOnUsers | Format-Table

  ComputerName  ProcessName  PID  PPID ProcessOwner   FoundExplorerExe CommandLine
  ------------  -----------  ---  ---- ------------   ---------------- -----------
  RemDesktopPC  explorer.exe 8984 8928 Jannus.Fugal               True C:\WINDOWS\Explorer.EXE
  somejumpbox   explorer.exe 4408 5728 a-Cyan.Foss                True C:\Windows\Explorer.EXE
  somejumpbox   explorer.exe 352  4156 a-Jannus.Fugal             True C:\Windows\Explorer.EXE
  RemJumpbox01                                                   False
  LocLaptop-PC1 explorer.exe 3556 3288 Jannus.Fugal               True C:\Windows\Explorer.EXE



  Here we run the function by referencing 4 different hosts using the "-ComputerName" parameter.  We received a Standard Error (StdErr) message for one of the hosts (the RemJumpbox01 computer) stating that there were no instances of the "explorer.exe" on the host, which means that no one is logged on via the GUI on that machine.  We also see that on one of the computers (somejumpbox), two users are currently logged in.

.INPUTS
.OUTPUTS
.NOTES
  Name:  Find-LoggedOnUsersWithWmic.ps1
  Author:  Travis Logue
  Version History:  1.0 | 2021-03-17 | Initial Version
  Dependencies:
  Notes:
  - This was helpful in redirecting Std Error from an invoked executable (wmic process ... 2>$null): https://stackoverflow.com/questions/35940593/suppressing-powershell-errors-when-calling-external-executables
  - This was helpful for the "call GetOwner" wmic syntax:  https://stackoverflow.com/questions/14660118/there-is-no-column-for-user-name-in-the-wmic-process-output

  .
#>
function Find-LoggedOnUsersWithWmic {
  [CmdletBinding()]
  [Alias('LoggedOnUsers')]
  param (
    [Parameter(HelpMessage='Reference the computer(s) to query.')]
    [string[]]
    $ComputerName
  )
  
  begin {}
  
  process {
    
    $wmic = 'wmic.exe'
    [array]$param = @()
    
 
    if ($null -like $ComputerName) {
      $ComputerName = HOSTNAME.EXE
    }    

    $AllResults = foreach ($Computer in $ComputerName) {

      # WMIC requirement: If the hostname has a "-" or a "/" then wrap the hostname in double quotes
      $param = "/node:`"$($Computer)`"",'process','where','name="explorer.exe"','get','name,','processid,','parentprocessid,','commandline','/format:list'        
      $Results = & $wmic $param <# 2>$null # decided to keep the StdErr output #> | Where-Object {$_} 

      if ($null -like $Results) {

        $prop = [ordered]@{
  
          ComputerName = $Computer
          ProcessName = $null
          PID = $null
          PPID = $null
          ProcessOwner = $null
          FoundExplorerExe = $false
          CommandLine = $null
  
        }

        $obj = New-Object -TypeName psobject -Property $prop
        Write-Output $obj
        
      }
      else {

        $WmicResultsFull = $Results + "END OF THE LINE"   

        for ($i = 0; $i -lt $WmicResultsFull.Count; $i++) {
          if ($WmicResultsFull[$i] -like "CommandLine=*") {
            $counter = 0
            $ObjectArray = @()
            do {
              $ObjectArray += $WmicResultsFull[$i + $counter]
              $counter += 1
            } until ($WmicResultsFull[$i + $counter] -like "CommandLine=*" -or $WmicResultsFull[$i+ $counter] -like "END OF THE LINE") 
  
            foreach ($e in $ObjectArray) {
              switch -regex ($e) {
                '^Commandline=' { $CommandLine_Value = (($e -split "=",2).trim())[1] }
                '^Name=' { $Name_Value = (($e -split "=",2).trim())[1] }
                '^ParentProcessId=' { $ParentProcessId_Value = (($e -split "=",2).trim())[1] }
                '^ProcessId=' { $ProcessId_Value = (($e -split "=",2).trim())[1] }
              }
            }  
                
            $GetProcOwnerParam = "/node:`"$($Computer)`"",'process','where',"processid=`"$($ProcessId_Value)`"",'call','getowner'
            $ProcOwnerResults = & $wmic $GetProcOwnerParam
            $ProcessOwner = ($ProcOwnerResults | ? {$_ -like "*User = *"}) -replace '.*User = "' -replace '";$'
        
            $prop = [ordered]@{  
              ComputerName = $Computer
              ProcessName = $Name_Value
              PID = $ProcessId_Value
              PPID = $ParentProcessId_Value
              ProcessOwner = $ProcessOwner
              FoundExplorerExe = $true
              CommandLine = $CommandLine_Value      
            }
  
            $obj = New-Object -TypeName psobject -Property $prop
            Write-Output $obj
          }
        }
        
      }      

    }

    Write-Output $AllResults

  }
  

  end {}
}