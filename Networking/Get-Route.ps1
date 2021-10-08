

<#
.SYNOPSIS
  This function allows the use of the wildcard "*" character in conjunction with a partial network id in order to query the route table and find out information concerning the next hop, the egress Interface IP address, and other details.
.DESCRIPTION
.EXAMPLE
  PS C:\> get-route "0.0.0.0*"                                                                                                          

  DestinationPrefix : 0.0.0.0/0
  NextHop           : 10.80.8.1
  EgressIntIP       : 10.80.8.56
  EgressIntMask     : 24
  EgressNetOrigin   : Dhcp
  ifIndex           : 23
  RouteMetric       : 0
  ifMetric          : 35
  InterfaceAlias    : Ethernet 6



  This shows information about the interface / network our computer uses for its default route.

.EXAMPLE
  PS C:\> get-route "10.34*"                                                                                                            

  DestinationPrefix : 10.34.0.0/16
  NextHop           : 0.0.0.0
  EgressIntIP       : 10.20.40.5
  EgressIntMask     : 32
  EgressNetOrigin   : Manual
  ifIndex           : 10
  RouteMetric       : 1
  ifMetric          :
  InterfaceAlias    : Local Area Connection* 13



  Using the wildcard character matches anything in the routing table that begins with '10.34'.

.INPUTS
.OUTPUTS
.NOTES
  - It seems like "Get-NetRoute" isn't able to handle "-PipelineVariable".  I kept getting the following error, prior to adding " | ? {$_} -PipelineVariable original "  :

      Get-NetRoute : Cannot retrieve the dynamic parameters for the cmdlet. Object reference not set to an instance of an object.
      At line:12 char:5
      +     Get-NetRoute -DestinationPrefix $DestinationPrefix -PipelineVaria ...
      +     ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
          + CategoryInfo          : InvalidArgument: (:) [Get-NetRoute], ParameterBindingException
          + FullyQualifiedErrorId : GetDynamicParametersException,Get-NetRoute

  - However, once I added " | ? {$_} -PipelineVariable original " I was able to use the -PipelineVariable
  - Also, of important note, if using Select-Object, I had to use the @{n= ; e=} syntax to reference the -PipelineVariable
#>

function Get-Route {
  [CmdletBinding()]
  param (
    [Parameter()]
    [string]
    $DestinationPrefix
  )
  
  begin {}
  
  process {
    Get-NetRoute -DestinationPrefix $DestinationPrefix | ? {$_} -PipelineVariable original | Get-NetIPAddress | 
    Select-object `
    @{n='DestinationPrefix';e={$original.DestinationPrefix}}, 
    @{n='NextHop';e={$original.NextHop}}, 
    @{n='EgressIntIP';e={$_.IPAddress}}, 
    @{n='EgressIntMask'; e={$_.PrefixLength}},
    @{n='EgressNetOrigin'; e={$_.PrefixOrigin}},
    @{n='ifIndex';e={$original.InterfaceIndex}}, 
    @{n='RouteMetric';e={$original.RouteMetric}}, 
    @{n='ifMetric';e={$original.InterfaceMetric}}, 
    @{n='InterfaceAlias';e={$original.InterfaceAlias}}   
  } 

  end {}
}