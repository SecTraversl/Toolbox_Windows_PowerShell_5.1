<#
.SYNOPSIS
  The "Ping-MachineGun" function pings each computer twice (two pings are used to compensate for an initial ARP timeout) and creates a list of unique hosts with a "Pingable" Boolean property indicating whether or not the host was reachable at least once. For ~500 computers, results are often returned within 60 seconds or less.
  
.DESCRIPTION
.EXAMPLE
  PS C:\> $WindowsWorkstations = Search-ADComputerPlus -OSFilter WindowsWorkstation
  PS C:\> $WindowsWorkstations | measure
  Count    : 508

  PS C:\> $PingResults = Ping-MachineGun -ComputerName ($WindowsWorkstations.dnshostname)

  A Quota Violation occurred with the set given to the '-ComputerName' Parameter.  Breaking the array into two sections and trying again.

  PS C:\> Get-CommandRuntime
  Days              : 0
  Hours             : 0
  Minutes           : 0
  Seconds           : 54

  PS C:\> $PingResults | measure
  Count    : 508

  PS C:\> $PingResults | select -f 10

  DNSHostName                       IPV4Address   Pingable
  -----------                       -----------   --------
  RBRURMONSTERC-T.corp.Roxboard.com 10.46.32.68       True
  RBHQTCOWEN-L.corp.Roxboard.com    10.46.36.13       True
  RBHQLHOLLMAN-L.corp.Roxboard.com  10.224.25.126     True
  RBHQDCARDER2-D.corp.Roxboard.com  10.34.29.238      True
  RBHQPTIU-L.corp.Roxboard.com      10.46.36.52       True
  RBHQNTWIT-L.corp.Roxboard.com     10.46.36.24       True
  RBHQRQUITS-D.corp.Roxboard.com    10.34.21.227      True
  RBHQCHOO-L.corp.Roxboard.com      10.46.36.81       True
  RBHQMHartman1-L.corp.Roxboard.com 10.46.36.108      True
  RBHQSTRUITS1-L.corp.Roxboard.com  10.46.36.66       True



  Here we are taking 508 computer names that we retrieved from Active Directory and pinging them with the "Ping-MachineGun" function.  WMI/CIM can only handle so many objects at a time and raises a "Quota Violation" Error, which the "Ping-MachineGun" automatically catches.  The function then splits the set of Computer Names into two sections by calling the "Split-ArrayInHalf" function (which embedded within this tool), and pings each of those sections independently.  The final result returns all of the Computer Names, their respective IPv4 Address (as applicable), and a "True" or "False" for the 'Pingable' property.

.EXAMPLE
  PS C:\> PingMachineGun -NetworkPingSweepWithNmap 10.80.3.0/24

  Starting Nmap 7.91 ( https://nmap.org ) at 2021-03-16 07:53 Pacific Daylight Time
  Nmap scan report - host is up - 10.80.3.1
  Nmap scan report - host is up - superkwl-pc.boggle.local (10.80.3.103)
  Nmap scan report - host is up - LocLaptop-PC1.boggle.local (10.80.3.37)
  Nmap done: 256 IP addresses (3 hosts up) scanned in 2.66 seconds



  Here we use use nmap.exe to do the ping sweep by referencing a network with CIDR notation.  The ping sweep for the /24 network is finished in 3 seconds and we see that there are 3 hosts that responded to ping in the network.

.INPUTS
.OUTPUTS
.NOTES
  Name: Ping-MachineGun
  Author: Travis Logue
  Version History: 2.0 | 2020-03-16 | Embedded 'Split-ArrayInHalf.ps1'
  Dependencies: nmap.exe (if using the "-NetworkPingSweepWithNmap" parameter)
  Notes:
  - This was helpful in determining good syntax to use with the "-AsJob" Parameter with Net-Connection, specifically adding the delay and piping to Receive-Job -Wait :  https://stackoverflow.com/questions/47397924/test-connection-with-asjob-and-delay
  - This was helpful in figuring out a good way to "Catch" the Error... : https://adamtheautomator.com/powershell-try-catch/
  - This was helpful for the simplified syntax of an Nmap ping sweep: https://medium.com/@minimalist.ascent/host-discovery-with-nmap-a3759e3d214f

  .
#>
function Ping-MachineGun {
  [CmdletBinding()]
  [Alias('PingMachineGun')]
  param (
    [Parameter()]
    [string[]]
    $ComputerName,
    [Parameter(HelpMessage = 'Reference the network with CIDR Notation, e.g. "192.168.0.1/24" ')]
    [string]
    $NetworkPingSweepWithNmap
  )
  
  begin {}
  
  process {

    if ($NetworkPingSweepWithNmap) {

      Write-Host ""
      #Reference the network with CIDR Notation, e.g. "192.168.0.1/24" 
      $NmapResults = nmap -sn $NetworkPingSweepWithNmap | Select-String 'Nmap'
      $NmapResults -replace "Nmap scan report for", "Nmap scan report - host is up -"
      Write-Host ""

    }
    elseif ($ComputerName) {
      
      $EndPoint = $ComputerName
      
      function Split-ArrayInHalf {
        [CmdletBinding()]
        param (
          [Parameter(Mandatory = $true, HelpMessage = 'Reference the Array you want to split in half.')]
          [array]
          $Array,
          [Parameter(Mandatory = $true, HelpMessage = 'This parameter contains a ValidateSet adAttribute.  Choose whether to return the "LowerSet" or the "UpperSet" of the Array.')]
          [ValidateSet("LowerSet", "UpperSet")]
          [string]
          $ReturnSet
        )
        
        $TotalLength = $Array.Count
        $HalfwayNumber = $Array.Count / 2
        $LowerSet = $Array[0..($HalfwayNumber - 1)]
        $UpperSet = $Array[($HalfwayNumber)..($TotalLength)]
      
        switch ($ReturnSet) {
          "LowerSet" { Write-Output $LowerSet }
          "UpperSet" { Write-Output $UpperSet }
        }  
      
      }
      
  
      try {
        Test-Connection -Count 2 -Delay 5 -ComputerName $EndPoint -AsJob  | Receive-Job -Wait -ErrorAction Stop
      }
      catch [System.Management.ManagementException] {      
        if ($PSItem.Exception.Message -like "*Quota violation*") {
          write-host "`nA Quota Violation occurred with the set given to the '-ComputerName' Parameter.  Breaking the array into two sections and trying again.`n" -BackgroundColor Black -ForegroundColor Yellow
  
          $Responses = Test-Connection -Count 2 -Delay 5 -ComputerName (Split-ArrayInHalf -Array $EndPoint -ReturnSet LowerSet) -AsJob | Receive-Job -Wait
          $Responses += Test-Connection -Count 2 -Delay 5 -ComputerName (Split-ArrayInHalf -Array $EndPoint -ReturnSet UpperSet) -AsJob | Receive-Job -Wait
        }     
      }
  
      # Here we are selecting specific properties that we want, as well as customizing the name of two of the properties
      $Formatted = $Responses | Select-Object `
      @{Name = 'DNSHostName'; Expression = { $_.Address } },
      IPV4Address,
      @{Name = 'Pingable'; Expression = { if ($_.StatusCode -eq 0) { $true } else { $false } } }
  
      # We did two 'pings' in the code above, this command below returns the computers that replied at least once
      $Pingable = $Formatted | Where-Object { $_.Pingable -eq $true } | Sort-Object DNSHostName -Unique 
  
      # This command returns the computers that did not reply at least once
      $NotPingable = $Formatted | Where-Object { $_.DNSHostName -notin ($Pingable.DNSHostName) } | Sort-Object DNSHostName -Unique    
  
      Write-Output $Pingable
      Write-Output $NotPingable


    }



  }
  
  end {}
}