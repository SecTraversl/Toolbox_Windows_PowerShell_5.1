
function Nslookup-All {
    [CmdletBinding()]
    param (
    [parameter(Position=0,Mandatory,HelpMessage="Enter an IPv4 Address or a Domain name.",
    ValueFromPipeline,ValueFromPipelineByPropertyName)]
    [Alias("Address","Domain")]
    [string]$Lookup,

    [string]$Server = '1.1.1.1'

    )
    
    if ( $LookUp -match "^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$" ) {

        cmd /c " nslookup -d $Lookup $Server "

    } else {

        cmd /c " nslookup  -d $Lookup. $Server "

    }
}