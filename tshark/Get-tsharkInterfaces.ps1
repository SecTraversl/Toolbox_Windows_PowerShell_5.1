<#
.SYNOPSIS
  The "Get-tsharkInterfaces" function displays the interface reference number for network adapters on the computer as seen by tshark.exe.  These can then be referenced with the "-i" parameter when using tshark.exe in order to capture traffic on that interface.
  
.DESCRIPTION
.EXAMPLE
  PS C:\> *tshar*int <tab>
  PS C:\> Get-tsharkInterfaces

  PS C:\> tsharkInterfaces

  IntRef IntName                      IPAddress
  ------ -------                      ---------
  1      Local Area Connection* 13    10.30.40.4
  3      Bluetooth Network Connection {fe80::9934:b6b0:88c1:3700%14, 169.254.55.0}
  6      Ethernet 6                   10.80.7.56
  8      Local Area Connection        {fe80::c89:a3d5:7b67:b520%20, 169.254.181.32}
  9      Ethernet 4                   169.254.103.89



  Here we are demonstrating fast ways to invoke this function.  Simply typing "*tshar*int" and then pressing the Tab key should result in the full function name. Additionally, using the function's built-in alias of "tsharkInterfaces" or "tsharkI <tab>" also allows for quick invocation of this tool.

.EXAMPLE
  PS C:\> Get-tsharkInterfaces

  IntRef IntName                      IPAddress
  ------ -------                      ---------
  5      vEthernet (Hyper-V_External) 10.44.39.235
  6      vEthernet (Default Switch)   {fe80::606b:3423:2dfc:d3ee%39, 192.168.175.129}
  7      vEthernet (Hyper-V_Internal) 169.254.174.132
  9      Ethernet 2                   169.254.199.212
  10     Ethernet 3                   169.254.124.131

  PS C:\> tshark.exe -i 5 -f "port 80" -Y http
  Capturing on 'vEthernet (Hyper-V_External)'
     4   0.075930 10.44.29.235 => 3.81.243.131 HTTP 200 GET /fpoll?id=KeZ6hcAXRE4fWZzK1SX6wA&b=79d9bc6f HTTP/1.1
     6   0.151315 3.81.243.131 => 10.44.29.235 HTTP 227 HTTP/1.1 200 OK
    13 106.523826 10.44.29.235 => 172.217.1.142 HTTP 490 GET / HTTP/1.1
    15 106.580005 172.217.1.142 => 10.44.29.235 HTTP 582 HTTP/1.1 301 Moved Permanently  (text/html)
    20 119.088718 10.44.29.235 => 3.81.243.131 HTTP 200 GET /fpoll?id=KeZ6hcAXRE4fWZzK1SX6wA&b=2be71730 HTTP/1.1
    22 119.163963 3.81.243.131 => 10.44.29.235 HTTP 227 HTTP/1.1 200 OK
  


  Here we are using the function to display the network interfaces on the computer that have IP Addresses as well as displaying the "Interface Reference" ('IntRef') according to tshark.exe.  Then we start capturing traffic on that interface using the "-i 5" syntax and specify a capture filter of "port 80" and a display filter of "http".

.INPUTS
.OUTPUTS
.NOTES
  Name: Get-tsharkInterfaces
  Author: Travis Logue
  Version History:  1.2 | 2020-02-24 | Added built-in alias for function
  Dependencies:  tshark.exe parent directory needs to be in $env:Path
  Notes:
  - Also, using "dumpcap -D -M" shows the interfaces and the numeric reference as seen by tshark:  https://osqa-ask.wireshark.org/questions/31171/capture-on-all-interfaces-in-tshark

  .
#>
function Get-tsharkInterfaces {
  [CmdletBinding()]
  [Alias('tsharkInterfaces')]
  param ()
  
  begin {}
  
  process {
    $tsharkListOfInterfaces = tshark.exe -D

    $NetIPAddress = Get-NetIPAddress | Select-Object IPAddress,InterfaceAlias

    foreach ($Interface in $tsharkListOfInterfaces) {
      
      $IntRef,$DeviceIdentifier,$IntName  = $Interface -split "\s",3
      $IntRef = $IntRef.trimend('.')
      $IntName = $IntName -replace "^\(" -replace "\)$"
      
      if ($IntName -in $NetIPAddress.InterfaceAlias) {
        $IPAddress = ($NetIPAddress | Where-Object {$_.InterfaceAlias -like $IntName}).IPAddress

        $prop = [ordered]@{
          IntRef = $IntRef
          IntName = $IntName
          IPAddress = $IPAddress
        }
        $obj = New-Object -TypeName psobject -Property $prop
        Write-Output $obj
      }

    }  

  }
  
  end {}
}


