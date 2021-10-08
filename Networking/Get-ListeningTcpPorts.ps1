

function Get-ListeningTcpPorts {
  [CmdletBinding()]
  param ()
  
  begin {}
  
  process {
    $netstat = 'netstat -nao' | cmd.exe

    $headers = $netstat[7].trim() -split "\s{2,}"
    
    $obj_netstat = ($netstat | Select-String 'tcp' | Out-String -Stream).trim() -replace "\s{2,}","," | ConvertFrom-Csv -Header $headers

    $obj_netstat | Where-Object state -like 'LISTENING' | 
    Select-Object Proto,@{n='LPort';e={($_.'Local Address' -replace ".*:")}},state,PID | 
    Sort-Object LPort -Unique
  }
  
  end {}
}