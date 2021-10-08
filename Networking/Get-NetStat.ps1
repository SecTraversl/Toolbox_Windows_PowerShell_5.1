
# 2020-02-03  - I grabbed this code from:
# https://isc.sans.edu/forums/diary/Netstat+Local+and+Remote+new+and+improved+now+with+more+PowerShell/25058/


function Get-NetStat {
  [CmdletBinding()]
  param (
    
  )
  
  begin {
    $Processes = @{ }

    # first check if we're running elevated or not, so we don't error out on the Get-Process command
    # note that account info is only retrieved if we are elevated

    if ((New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
      # Elevated - get account info per process
      Get-Process -IncludeUserName | ForEach-Object {
        $Processes[$_.Id] = $_
      }
    }
    else {
      # Not Elevated - don't collect per-process account info
      Get-Process | ForEach-Object {
        $Processes[$_.Id] = $_
      }
    }
  }
  
  process {
    # Query Listening TCP Ports and Connections
    $Ports = Get-NetTCPConnection |
    Select-Object LocalAddress,
    RemoteAddress,
    @{Name = "Proto"; Expression = { "TCP" } },
    LocalPort, RemotePort, State,
    @{Name = "PID"; Expression = { $_.OwningProcess } },
    @{Name = "UserName"; Expression = { $Processes[[int]$_.OwningProcess].UserName } },
    @{Name = "ProcessName"; Expression = { $Processes[[int]$_.OwningProcess].ProcessName } },
    @{Name = "Path"; Expression = { $Processes[[int]$_.OwningProcess].Path } } |
    Sort-Object -Property LocalPort, UserName

    # Query Listening UDP Ports (No Connections in UDP)
    $UDPPorts += Get-NetUDPEndpoint |
    Select-Object LocalAddress, RemoteAddress,
    @{Name = "Proto"; Expression = { "UDP" } },
    LocalPort, RemotePort, State,
    @{Name = "PID"; Expression = { $_.OwningProcess } },
    @{Name = "UserName"; Expression = { $Processes[[int]$_.OwningProcess].UserName } },
    @{Name = "ProcessName"; Expression = { $Processes[[int]$_.OwningProcess].ProcessName } },
    @{Name = "Path"; Expression = { $Processes[[int]$_.OwningProcess].Path } } |
    Sort-Object -Property LocalPort, UserName
  }
  
  end {
    foreach ($P in $UDPPorts) {
      if ( $P.LocalAddress -eq "0.0.0.0") { $P.State = "Listen" } 
    }
  
    $Ports += $UDPPorts
  
    $Ports
  }
}



 

