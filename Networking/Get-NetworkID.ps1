<#
.SYNOPSIS
  The "Get-NetworkID" function takes a given IP Address along with its Subnet Mask and returns the Network ID of that network.

.DESCRIPTION
.EXAMPLE
  PS C:\> netid '10.80.7.56' '255.255.255.0'

  IPAddress  NetMask       NetworkID
  ---------  -------       ---------
  10.80.7.56 255.255.255.0 10.80.7.0


  PS C:\> Get-NetworkID -IPAddress '10.80.7.56' -NetMask '255.255.255.0'

  IPAddress  NetMask       NetworkID
  ---------  -------       ---------
  10.80.7.56 255.255.255.0 10.80.7.0



  Here we first invoke the function by ussing its built-in alias "netid", along with taking advantage of the positional parameters of "-IPAddress" and "-NetMask".  In the second example we use the more verbose and explicit syntax by invoking the function with the full name of "Get-NetworkID" and using the parameter names with their respective arguments.

.INPUTS
.OUTPUTS
.NOTES
  Name:  Get-NetworkID.ps1
  Author:  Travis Logue
  Version History:  1.0 | 2021-02-24 | Initial Version
  Dependencies:  
  Notes:
  - This is where we discovered the strategy of leveraging {[version]$_.IPAddress} in order to sort and compare IP Addresses natively in PowerShell:  https://www.madwithpowershell.com/2016/03/sorting-ip-addresses-in-powershell-part.html
  - This was helpful in describing the [ipaddress] type accelerator and the use thereof:  https://www.itprotoday.com/powershell/working-ipv4-addresses-powershell
  - This was where I originally found the reference for the article above (the "itprotoday.com" article); this along with that article above is a good reference for using the [IPAddress] Type Accelerator, and for using the "Bitwise AND" operator to convert IPv4 strings into 32 bit number IPv4 Objects:  https://stackoverflow.com/questions/51296568/powershell-convert-ip-address-to-subnet

  .
#>
function Get-NetworkID {
  [CmdletBinding()]
  [Alias('netid')]
  param (
    [Parameter(Mandatory=$true)]
    [string]
    $IPAddress,
    [Parameter(Mandatory=$true)]
    [string]
    $NetMask
  )
  
  begin {}
  
  process {

    $ip = [ipaddress]$IPAddress
    $mask = [ipaddress]$NetMask
    $netid =  [ipaddress]($ip.Address -band $mask.Address)

    $prop = [ordered]@{
      IPAddress = $IPAddress
      NetMask = $NetMask
      NetworkID = $netid
    }
    $obj = New-Object -TypeName psobject -Property $prop
    Write-Output $obj


    <#  ##### BASIC TEST CODE #####
    $ip = [ipaddress]'10.80.7.56'
    $netmask = [ipaddress]'255.255.255.0'
    $netid =  [ipaddress]($ip.Address -band $netmask.Address)
    #> 
  }
  
  end {}
}




