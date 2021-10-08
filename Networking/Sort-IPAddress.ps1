

<#
2019-12-08

Found this basics for this here: https://www.madwithpowershell.com/2016/03/sorting-ip-addresses-in-powershell-part.html
  
This is the shortened version of the syntax, using a Positional Parameter and an Alias:
  Sort { [version] $_ }

#> 


<#
function Sort-IPAddress {
  [cmdletbinding()]
  param (
    [parameter(ValueFromPipeline)][String[]]$Property
  )
  
  process {
    Sort-Object -Property { [version]$_ }
  }  
}
#>

function Sort-IPAddress {
  [CmdletBinding()]
  param (
    [parameter(ValueFromPipeline)][string[]]$Property
  ) 
  
  process {
    Sort-Object -Property { [version]$_ }
  }
  
  end {
    
  }
}



<#
function Sort-IPAddress {
  param (
    [parameter(ValueFromPipeline)][psobject[]]$Property
  )

  Sort-Object -Property { [system.version] $_ }
  
}
#>



# This was effective


#$dst | ? {$_ -notlike $null}  | Sort-Object -Unique -Property { [version]$_ }

#Set-alias -Name Not-Null -Value "? {$_ -notlike $null}"


#Set-Alias -Name Sort-IPAddress -Value "Sort-Object -Property { [version]$_ }"




