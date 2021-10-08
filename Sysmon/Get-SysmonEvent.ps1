<#
.SYNOPSIS
  The "Get-SysmonEvent" function allows for a variety of Sysmon Event Log queries to be made in a simple fashion with succinct syntax.  "-ListEventIdTable" is handy to get a quick listing of EventID to Description mapping.  The "-LogSelector" parameter contains a ValidateSetAttribute, allowing you to tab through the different options.  The "-Session" parameter allows you to query a remote machine's Sysmon Event Logs over an existing PSSession.
  
.DESCRIPTION
.EXAMPLE
  PS C:\> <example usage>
  Explanation of what the example does
.INPUTS
.OUTPUTS
.NOTES
  Name: Get-SysmonEvent.ps1
  Author: Travis Logue
  Version History: 1.0 | 2020-10-21 | Initial Version
  Dependencies:
  Notes:
  - This was helpful in creating the correct syntax for leveraging the code over a PSSession / Invoke Command.  Specifically... we needed to use the "$using:" syntax everywhere that we were referencing a local variable, such as any argument values passed to the function itself:  https://adamtheautomator.com/invoke-command-remote/


  .
#>
function Get-SysmonEvent {
  [CmdletBinding()]
  param (
    [Parameter(HelpMessage='Specify how many days prior of logs to retrieve.')]
    [int]
    $DaysPrior,
    [Parameter(HelpMessage='Specify how many hours prior of logs to retrieve.')]
    [int]
    $HoursPrior,
    [Parameter()]
    [int32[]]
    $EventId,
    [Parameter(HelpMessage='Switch Parameter used to display the mapping of Sysmon Event IDs to their human readable description')]
    [switch]
    $ListEventIdTable,
    [Parameter()]
    [ValidateSet('ProcessCreate', 'FileCreateTime', 'NetworkConnect', 'SysmonStateChange', 'ProcessTerminate', 'DriverLoad', 'ImageLoad', 'CreateRemoteThread', 'RawAccessRead', 'ProcessAccess', 'FileCreate', 'RegistryObjAddDelete', 'RegistryValueSet', 'RegistryObjRenamed', 'FileCreateStreamHash', 'SysmonConfigChange', 'PipeCreated', 'PipeConnected', 'WmiEventFilterActivity', 'WmiEventConsumerActivity', 'WmiEventConsumerToFilterActivity', 'DnsQuery', 'FileDelete', 'Error')]
    [string]
    $LogSelector,
    [Parameter(HelpMessage='Reference the PSSession to run the command on. Using the $Session Parameter allows us to query Sysmon Event Logs on remote machines over an existing PSSession')]
    [System.Management.Automation.Runspaces.PSSession]
    $Session
  )
  
  begin {}
  
  process {
    # THIS FIRST CODE BLOCK IS USED WHEN A "PSSESSION" IS REFERENCED BY USING THE $Session PARAMETER
    if ($Session) {
      Invoke-Command -Session $Session -ScriptBlock {
        $hashtable = @{}

        # Timeframe selection
        if ($using:DaysPrior) {
          $hashtable.Add( 'StartTime', (Get-Date).AddDays(-$using:DaysPrior) )
          $hashtable.Add( 'EndTime', (Get-Date) ) 
        }
        elseif ($using:HoursPrior) {
          $hashtable.Add( 'StartTime', (Get-Date).AddHours(-$using:HoursPrior) )
          $hashtable.Add( 'EndTime', (Get-Date) ) 
        }
    
        # Events selection ($EventId or $LogSelector) or print out the EventId-to-HumanReadable mapping ($ListEventIdTable)
        if ($using:LogSelector) {
          switch ($using:LogSelector) {
            'ProcessCreate' { $hashtable.Add( 'ID', 1) }
            'FileCreateTime' { $hashtable.Add( 'ID', 2) }
            'NetworkConnect' { $hashtable.Add( 'ID', 3) }
            'SysmonStateChange' { $hashtable.Add( 'ID', 4) }
            'ProcessTerminate' { $hashtable.Add( 'ID', 5) }
            'DriverLoad' { $hashtable.Add( 'ID', 6) }
            'ImageLoad' { $hashtable.Add( 'ID', 7) }
            'CreateRemoteThread' { $hashtable.Add( 'ID', 8) }
            'RawAccessRead' { $hashtable.Add( 'ID', 9) }
            'ProcessAccess' { $hashtable.Add( 'ID', 10) }
            'FileCreate' { $hashtable.Add( 'ID', 11) }
            'RegistryObjAddDelete' { $hashtable.Add( 'ID', 12) }
            'RegistryValueSet' { $hashtable.Add( 'ID', 13) }
            'RegistryObjRenamed' { $hashtable.Add( 'ID', 14) }
            'FileCreateStreamHash' { $hashtable.Add( 'ID', 15) }
            'SysmonConfigChange' { $hashtable.Add( 'ID', 16) }
            'PipeCreated' { $hashtable.Add( 'ID', 17) }
            'PipeConnected' { $hashtable.Add( 'ID', 18) }
            'WmiEventFilterActivity' { $hashtable.Add( 'ID', 19) }
            'WmiEventConsumerActivity' { $hashtable.Add( 'ID', 20) }
            'WmiEventConsumerToFilterActivity' { $hashtable.Add( 'ID', 21) }
            'DnsQuery' { $hashtable.Add( 'ID', 22) }
            'FileDelete' { $hashtable.Add( 'ID', 23) }
            'Error' { $hashtable.Add( 'ID', 255) }  
          }
        }
        elseif ($using:EventId) {
          $hashtable.Add( 'ID', $using:EventId )
        }
    
    
        if ($ListEventIdTable) {
    
          $SysmonDictionary = [ordered]@{}
          $Nums = @(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 255)
          $Description = @('ProcessCreate', 'FileCreateTime', 'NetworkConnect', 'SysmonStateChange', 'ProcessTerminate', 'DriverLoad', 'ImageLoad', 'CreateRemoteThread', 'RawAccessRead', 'ProcessAccess', 'FileCreate', 'RegistryObjAddDelete', 'RegistryValueSet', 'RegistryObjRenamed', 'FileCreateStreamHash', 'SysmonConfigChange', 'PipeCreated', 'PipeConnected', 'WmiEventFilterActivity', 'WmiEventConsumerActivity', 'WmiEventConsumerToFilterActivity', 'DnsQuery', 'FileDelete', 'Error')
    
          0..23 | % {
            $SysmonDictionary[$Description[$_]] = $Nums[$_]
          }
          Write-Output $SysmonDictionary
        }
        else {
          if ($null -notlike $hashtable) {
            $hashtable.Add('logname','Microsoft-Windows-Sysmon/Operational')
            Get-WinEvent -FilterHashtable $hashtable
          }
          else {
            Get-WinEvent -FilterHashtable @{logname='*Sysmon*'}
          }
        }
      }
      
    } 
    # THE CODE BLOCK BELOW IS USED WHEN BY DEFAULT WHEN A "PSSESSION" WAS *NOT* REFERENCED ABOVE BY USING THE $Session PARAMETER
    else {
      $hashtable = @{}

      # Timeframe selection
      if ($DaysPrior) {
        $hashtable.Add( 'StartTime', (Get-Date).AddDays(-$DaysPrior) )
        $hashtable.Add( 'EndTime', (Get-Date) ) 
      }
      elseif ($HoursPrior) {
        $hashtable.Add( 'StartTime', (Get-Date).AddHours(-$HoursPrior) )
        $hashtable.Add( 'EndTime', (Get-Date) ) 
      }
  
      # Events selection ($EventId or $LogSelector) or print out the EventId-to-HumanReadable mapping ($ListEventIdTable)
      if ($LogSelector) {
        switch ($LogSelector) {
          'ProcessCreate' { $hashtable.Add( 'ID', 1) }
          'FileCreateTime' { $hashtable.Add( 'ID', 2) }
          'NetworkConnect' { $hashtable.Add( 'ID', 3) }
          'SysmonStateChange' { $hashtable.Add( 'ID', 4) }
          'ProcessTerminate' { $hashtable.Add( 'ID', 5) }
          'DriverLoad' { $hashtable.Add( 'ID', 6) }
          'ImageLoad' { $hashtable.Add( 'ID', 7) }
          'CreateRemoteThread' { $hashtable.Add( 'ID', 8) }
          'RawAccessRead' { $hashtable.Add( 'ID', 9) }
          'ProcessAccess' { $hashtable.Add( 'ID', 10) }
          'FileCreate' { $hashtable.Add( 'ID', 11) }
          'RegistryObjAddDelete' { $hashtable.Add( 'ID', 12) }
          'RegistryValueSet' { $hashtable.Add( 'ID', 13) }
          'RegistryObjRenamed' { $hashtable.Add( 'ID', 14) }
          'FileCreateStreamHash' { $hashtable.Add( 'ID', 15) }
          'SysmonConfigChange' { $hashtable.Add( 'ID', 16) }
          'PipeCreated' { $hashtable.Add( 'ID', 17) }
          'PipeConnected' { $hashtable.Add( 'ID', 18) }
          'WmiEventFilterActivity' { $hashtable.Add( 'ID', 19) }
          'WmiEventConsumerActivity' { $hashtable.Add( 'ID', 20) }
          'WmiEventConsumerToFilterActivity' { $hashtable.Add( 'ID', 21) }
          'DnsQuery' { $hashtable.Add( 'ID', 22) }
          'FileDelete' { $hashtable.Add( 'ID', 23) }
          'Error' { $hashtable.Add( 'ID', 255) }  
        }
      }
      elseif ($EventId) {
        $hashtable.Add( 'ID', $EventId )
      }
  
  
      if ($ListEventIdTable) {
  
        $SysmonDictionary = [ordered]@{}
        $Nums = @(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 255)
        $Description = @('ProcessCreate', 'FileCreateTime', 'NetworkConnect', 'SysmonStateChange', 'ProcessTerminate', 'DriverLoad', 'ImageLoad', 'CreateRemoteThread', 'RawAccessRead', 'ProcessAccess', 'FileCreate', 'RegistryObjAddDelete', 'RegistryValueSet', 'RegistryObjRenamed', 'FileCreateStreamHash', 'SysmonConfigChange', 'PipeCreated', 'PipeConnected', 'WmiEventFilterActivity', 'WmiEventConsumerActivity', 'WmiEventConsumerToFilterActivity', 'DnsQuery', 'FileDelete', 'Error')
  
        0..23 | % {
          $SysmonDictionary[$Description[$_]] = $Nums[$_]
        }
        Write-Output $SysmonDictionary
      }
      else {
        if ($null -notlike $hashtable) {
          $hashtable.Add('logname','Microsoft-Windows-Sysmon/Operational')
          Get-WinEvent -FilterHashtable $hashtable
        }
        else {
          Get-WinEvent -FilterHashtable @{logname='*Sysmon*'}
        }
      }
    }
        

  }
  
  end {}
}