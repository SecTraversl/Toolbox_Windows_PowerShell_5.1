<#
.SYNOPSIS
  The "Test-NetworkContainsIPAddress" function takes a given IP Address and Network in order to determine if the address resides within the network.

.DESCRIPTION
.EXAMPLE
  PS C:\> ipcalc 40.107.220.52/12

  Address   : 40.107.220.52
  Netmask   : 255.240.0.0
  Wildcard  : 0.15.255.255
  Network   : 40.96.0.0/12
  Broadcast : 40.111.255.255
  HostMin   : 40.96.0.1
  HostMax   : 40.111.255.254
  Hosts/Net : 1048574

  PS C:\> Test-NetworkContainsIPAddress -IPAddress 40.107.220.52 -Network 40.96.0.0/12  -Verbose
  VERBOSE: 00101000011000000000000000000000
  VERBOSE: 11111111111100000000000000000000
  VERBOSE: The given IP Address (40.107.220.52) is within the given Network (40.96.0.0/12):
  True

  PS C:\> Test-NetworkContainsIPAddress -IPAddress 40.107.220.52 -Network 40.96.0.0 -NetMask 255.240.0.0 -Verbose
  VERBOSE: The given IP Address (40.107.220.52) is within the given Network (40.96.0.0 mask 255.240.0.0):
  True

  PS C:\> Test-NetworkContainsIPAddress -IPAddress 40.107.220.52 -Network 40.96.0.0 -NetMask 255.240.0.0
  True

  PS C:\> IPinNetwork 40.107.220.52 40.96.0.0/12
  True

  PS C:\> Test-NetworkContainsIPAddress -IPAddress 40.112.0.1 -Network 40.96.0.0/12
  False



  Here we first run the function "Invoke-IPCalcUtility" using its alias of 'ipcalc' to show pertinent information about the network of "40.96.0.0/12".  We then show the use of the "Test-NetworkContainsIPAddress" function using various paramaters and arguments, to include the use of 'IPinNetwork' the built-in alias for "Test-NetworkContainsIPAddress".


.INPUTS
.OUTPUTS
.NOTES
  Name:  Test-NetworkContainsIPAddress.ps1
  Author:  Travis Logue
  Version History:  2.0 | 2021-04-02 | Various changes, including name change
  Dependencies:  Invoke-IPCalcUtility.ps1
  Notes:
  - This is where we discovered the strategy of leveraging {[version]$_.IPAddress} in order to sort and compare IP Addresses natively in PowerShell:  https://www.madwithpowershell.com/2016/03/sorting-ip-addresses-in-powershell-part.html
  - This was helpful in describing the [ipaddress] type accelerator and the use thereof:  https://www.itprotoday.com/powershell/working-ipv4-addresses-powershell
  - This was where I originally found the reference for the article above (the "itprotoday.com" article); this along with that article above is a good reference for using the [IPAddress] Type Accelerator, and for using the "Bitwise AND" operator to convert IPv4 strings into 32 bit number IPv4 Objects:  https://stackoverflow.com/questions/51296568/powershell-convert-ip-address-to-subnet

  .
#>
function Test-NetworkContainsIPAddress {
  [CmdletBinding()]
  [Alias('IPinNetwork')]
  param (
    [Parameter()]
    [string]
    $IPAddress,
    [Parameter()]
    [string]
    $Network,
    [Parameter()]
    [string]
    $NetMask
  )
  
  begin {}
  
  process {

    
    if ($Network.Contains('/')) {
      $IPCalcResults = Invoke-IPCalcUtility -IPAddress $Network
    }
    else {
      Write-Host "`nNo '-NetMask' given... trying... Invoke-IPCalcUtility -IPAddress $Network -NetMask 255.255.255.255`n" -BackgroundColor black -ForegroundColor Yellow
      $IPCalcResults = Invoke-IPCalcUtility -IPAddress $Network -NetMask 255.255.255.255
    }
    
    #$IPCalcResults = Invoke-IPCalcUtility -IPAddress $Network

    # HAD TO CHANGE THIS...
    #$IsIPAddressWithinNetwork = ([version]$IPAddress -ge [version]$IPCalcResults.HostMin) -and ([version]$IPAddress -le $IPCalcResults.HostMax)

    # ... TO THIS ( sometimes an IP Address shows up that is Network ID or the Broadcast )
    $IsIPAddressWithinNetwork = ([version]$IPAddress -ge [version]$IPCalcResults.Address) -and ([version]$IPAddress -le $IPCalcResults.Broadcast)

    if ($NetMask) {
      Write-Verbose "The given IP Address ($IPAddress) is within the given Network ($Network mask $NetMask):"
      #Write-Output $IsIPAddressWithinNetwork
      $prop = [ordered]@{
        Network = $IPCalcResults.Address
        NetMask = $IPCalcResults.Netmask
        IPAddress = $IPAddress
        IsIpInNetwork = $IsIPAddressWithinNetwork
      }
      $obj = New-Object -TypeName psobject -Property $prop
      Write-Output $obj
    }
    else {
      Write-Verbose "The given IP Address ($IPAddress) is within the given Network ($Network):"
      #Write-Output $IsIPAddressWithinNetwork
      $prop = [ordered]@{
        IPAddress = $IPAddress
        IsIpInNetwork = $IsIPAddressWithinNetwork
        Network = $IPCalcResults.Network
        NetworkID = $IPCalcResults.Address
        NetMask = $IPCalcResults.Netmask
      }
      $obj = New-Object -TypeName psobject -Property $prop
      Write-Output $obj
    }
    

  }
  
  end {}
}