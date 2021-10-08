function Get-TCPConnectionProcesses {

Get-NetTCPConnection | 

Select local*,remote*,state,
@{Name="Process";Expression={(Get-Process -Id $_.OwningProcess).ProcessName}},
@{Name="PID";Expression={(Get-Process -Id $_.OwningProcess).Id}},
@{Name="PIDCommandLine";Expression={(Get-CimInstance Win32_Process | ? processid -eq $_.OwningProcess).Commandline}},
@{Name="ParentProcess";Expression={(Get-Process -Id (Get-CimInstance Win32_Process | ? processid -eq $_.OwningProcess).ParentProcessId).ProcessName}},  
@{Name="PPID";Expression={(Get-CimInstance Win32_Process | ? processid -eq $_.OwningProcess).ParentProcessId}},
@{Name="PPIDCommandLine";Expression={(gcim Win32_Process | ? processid -eq ((gcim Win32_Process | ? ProcessId -eq $_.OwningProcess).ParentProcessId)).CommandLine}} 

}