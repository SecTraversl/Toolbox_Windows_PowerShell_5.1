<#
.SYNOPSIS
  Short description
.DESCRIPTION
.EXAMPLE
  PS C:\> $RpcPrograms = Get-RpcProgramsOnLocalComputer
  PS C:\> $RpcPrograms | Select-Object * -ExcludeProperty UUID | Format-Table

  Description         Port  ProcessName   PID ProcessOwner               ParentName   PPID CreationDate         Path                            Commandline
  -----------         ----  -----------   --- ------------               ----------   ---- ------------         ----                            -----------
                      49664 lsass.exe     968 NT AUTHORITY\SYSTEM        wininit.exe   860 3/20/2021 7:02:49 AM C:\Windows\system32\lsass.exe   C:\Window...
  KeyIso              49664 lsass.exe     968 NT AUTHORITY\SYSTEM        wininit.exe   860 3/20/2021 7:02:49 AM C:\Windows\system32\lsass.exe   C:\Window...
  Ngc Pop Key Service 49664 lsass.exe     968 NT AUTHORITY\SYSTEM        wininit.exe   860 3/20/2021 7:02:49 AM C:\Windows\system32\lsass.exe   C:\Window...
  RemoteAccessCheck   49664 lsass.exe     968 NT AUTHORITY\SYSTEM        wininit.exe   860 3/20/2021 7:02:49 AM C:\Windows\system32\lsass.exe   C:\Window...
                      49665 wininit.exe   860 NT AUTHORITY\SYSTEM                      580 3/20/2021 7:02:49 AM
  Event log TCPIP     49666 svchost.exe  1724 NT AUTHORITY\LOCAL SERVICE services.exe  936 3/20/2021 7:02:50 AM C:\Windows\System32\svchost.exe C:\Window...
                      49667 svchost.exe  1640 NT AUTHORITY\SYSTEM        services.exe  936 3/20/2021 7:02:50 AM C:\Windows\system32\svchost.exe C:\Window...
                      49668 spoolsv.exe  4276 NT AUTHORITY\SYSTEM        services.exe  936 3/20/2021 7:02:52 AM C:\Windows\System32\spoolsv.exe C:\Window...
  RemoteAccessCheck   49669 lsass.exe     968 NT AUTHORITY\SYSTEM        wininit.exe   860 3/20/2021 7:02:49 AM C:\Windows\system32\lsass.exe   C:\Window...
                      49670 services.exe  936 NT AUTHORITY\SYSTEM        wininit.exe   860 3/20/2021 7:02:49 AM



  Here we run the function and store the output in the variable "$RpcPrograms".  We then display the objects using the "Format-Table" cmdlet and by selecting all Properties except the "UUID" (Universal Unique Identifer).  

.INPUTS
.OUTPUTS
.NOTES
  Name:  Get-RpcProgramsOnLocalComputer.ps1
  Author:  Travis Logue
  Version History:  1.0 | 2021-03-22 | Initial Version
  Dependencies: 
  Notes:
  - Original article that led me to create this tool:  https://devblogs.microsoft.com/scripting/testing-rpc-ports-with-powershell-and-yes-its-as-much-fun-as-it-sounds/
  
  - Information about "Finding RPC EndPoints":  https://docs.microsoft.com/en-us/windows/win32/rpc/finding-endpoints

  - Good info on WMI / CIM cmdlets with the "-Filter" parameter:  
      https://stackoverflow.com/questions/28205132/powershell-filter-not-accepting-two-conditions
        * $remoteuserlist = Get-WmiObject Win32_UserAccount -filter {LocalAccount = "True" and Name != "Guest"} –computername $PC -verbose
        * $remoteuserlist = Get-WmiObject -query "SELECT * FROM Win32_UserAccount WHERE LocalAccount = 'True' and Name != 'Guest'" –computername $PC -verbose
      https://social.technet.microsoft.com/Forums/ie/en-US/b17d29d6-fb5f-4e77-aecd-88dea79b8cf5/filter-on-multiple-values?forum=ITCG
        * Get-CimInstance Win32_UserAccount -Filter "Name='Administrator' AND Domain = <DomainName>"
      https://www.reddit.com/r/PowerShell/comments/d00xr5/can_someone_explain_to_me_how_filter_works/
        * Get-CimInstance -ClassName SoftwareLicensingProduct -Filter "PartialProductKey IS NOT NULL"
        * Get-CimInstance -Query "SELECT * FROM SoftwareLicensingProduct WHERE PartialProduct IS NOT NULL"
      https://docs.microsoft.com/en-us/windows/win32/wmisdk/wql-sql-for-wmi?redirectedfrom=MSDN
        * SELECT * FROM meta_class WHERE NOT __class < "Win32" AND NOT __this ISA "Win32_Account"
      https://docs.microsoft.com/en-us/windows/win32/wmisdk/wql-operators
        Operator	Description
        =	Equal to
        <	Less than
        >	Greater than
        <=	Less than or equal to
        >=	Greater than or equal to
        != or <>	Not equal to

  - Interesting points brought up here for trying find UUID/GUID:  https://stackoverflow.com/questions/29205144/find-object-real-name-by-guid
  - More info on UUIDs:  https://docs.microsoft.com/en-us/windows/win32/rpc/generating-interface-uuids



  .
#>
function Get-RpcProgramsOnLocalComputer {
  [CmdletBinding()]
  param (
    [Parameter()]
    [string]
    $ComputerName = 'localhost'
  )
  
  begin {}
  
  process {


    $PortQryResults = PortQry.exe -n $ComputerName -e 135

    $FilteredResults = $PortQryResults | Select-String "ip_tcp" -Context 1,0 | Out-String -Stream | ? {$_}

    $ObjectForm = for ($i = 0; $i -lt $FilteredResults.Count; $i += 2) {
      
      $prop = [ordered]@{
        UUID = $FilteredResults[$i] -replace ".*UUID: "
        Port = $FilteredResults[$i+1] -replace ".*\[" -replace "\]"
      }

      $obj = New-Object -TypeName psobject -Property $prop
      Write-Output $obj

    }

    $SortedUnique = $ObjectForm | Sort-Object Port,UUID -Unique


    $UUIDsWithDescriptionsAndPIDs = foreach ($item in $SortedUnique) {
      if ($item.UUID.Length -gt 37) {

        $ProcID = (Get-NetTCPConnection -LocalPort $item.Port).OwningProcess | Sort-Object -Unique

        $prop = [ordered]@{
          UUID = $item.UUID[0..35] -join ''
          Description = $item.UUID[37..($item.UUID.Length - 1)] -join ''      
          Port = $item.Port
          ProcID = $ProcID  
        }
        
        $obj = New-Object -TypeName psobject -Property $prop
        Write-Output $obj
        
      }
      else {

        $ProcID = (Get-NetTCPConnection -LocalPort $item.Port).OwningProcess | Sort-Object -Unique

        $prop = [ordered]@{
          UUID = $item.UUID.Trim()
          Description = $null
          Port = $item.Port
          ProcID = $ProcID          
        }
        $obj = New-Object -TypeName psobject -Property $prop
        Write-Output $obj
        
      }

    }


    $UpdatedSortUniqueWithDescriptionsAndPIDs = $UUIDsWithDescriptionsAndPIDs | Sort-Object Port,Description -Unique

    $UniquePIDs = $UpdatedSortUniqueWithDescriptionsAndPIDs.ProcID | Sort-Object -Unique

    $Procs = $UniquePIDs | % { Get-CimInstance -ClassName Win32_Process -Filter "ProcessID = $_" }

    $ProcessInfo = foreach ($proc in $procs) {

      try {
        $GetOwner = $proc | Invoke-CimMethod -MethodName GetOwner
      }
      catch [Microsoft.Management.Infrastructure.CimException] {
        # The comments below act as documentation.  This catch block is here to stop the "Owner not found" error from appearing when this function is run.  It is normal for some system processes to not have a parent process or owner, and I didn't want to see errors related to those situations. What I discovered was that simply having this catch block here with "catch [Microsoft.Management.Infrastructure.CimException]" was enough for the errors to stop being displayed to Standard Output in the terminal.

        #if ($PSItem.Exception.Message -like "*No instance found with given property values.*") {
        #  Write-Host "Ignoring the Error for 'Owner not found'" -BackgroundColor Black -ForegroundColor Yellow
        #}
      }
      catch [Microsoft.Management.Infrastructure.CimCmdlets.InvokeCimMethodCommand] {
        # Also, though I did have success with the Catch above... I also found this $Error[0] to be occurring...
      }      

      $joiner_FindingParentProcessName = $procs | Where-Object {$_.ProcessID -eq $proc.ParentProcessID}
      $prop = [ordered]@{
        ComputerName = $HostName
        ProcessName = $proc.ProcessName
        PID = $proc.ProcessID
        ProcessOwner = if ($GetOwner.User) { "$($GetOwner.Domain)\$($GetOwner.User)" } else { $null }
        ParentName = $joiner_FindingParentProcessName.ProcessName
        PPID = $proc.ParentProcessID
        CreationDate = $proc.CreationDate
        Path = $proc.Path
        CommandLine = $proc.CommandLine
      }

      $obj = New-Object -TypeName psobject -Property $prop
      Write-Output $obj
    }  



    $PutItAllTogether = foreach ($RpcProgram in $UpdatedSortUniqueWithDescriptionsAndPIDs) {
      $joinerForRpcProgram = $ProcessInfo | ? PID -eq $RpcProgram.ProcID

      $prop = [ordered]@{

        UUID = $RpcProgram.UUID
        Description = $RpcProgram.Description
        Port = $RpcProgram.Port
        ProcessName = $joinerForRpcProgram.ProcessName
        PID = $joinerForRpcProgram.PID
        ProcessOwner = $joinerForRpcProgram.ProcessOwner
        ParentName = $joinerForRpcProgram.ParentName
        PPID = $joinerForRpcProgram.PPID
        CreationDate = $joinerForRpcProgram.CreationDate
        Path = $joinerForRpcProgram.Path
        Commandline = $joinerForRpcProgram.Commandline

      }

      $obj = New-Object -TypeName psobject -Property $prop
      Write-Output $obj
    }


    Write-Output $PutItAllTogether

  }
  
  end {}
}