<#
.SYNOPSIS
  The "Get-WmicHotfixPatchesList" function is a WMIC command wrapper for getting a list of patches installed on a computer.  The results are similar to those of the "Get-HotFix" cmdlet.

.DESCRIPTION
.EXAMPLE
  PS C:\> $Hotfixes = Get-WmicHotfixPatchesList
  PS C:\> $Hotfixes | ft



  Here we run the function without additional parameters which, by default, queries the local machine.  Installation Date and HotFixID are key components of the output.

.EXAMPLE
  PS C:\> $list
  LocLaptop-PC1
  RemDesktopPC.corp.Roxboard.com
  PS C:\>
  PS C:\> $Hotfixes = Get-WmicHotfixPatchesList -ComputerName $list
  PS C:\>
  PS C:\> 



  Here we have an array of computer names that we reference using the "-ComputerName" parameter in the function.  We store the results of the query to both computer in the variable "$Hotfixes" and use the "Format-Table" cmdlet (or "ft") to display the results as a table.  In this example, we sorted by the highest numbered HotFixId and selected the top 10.

.INPUTS
.OUTPUTS
.NOTES
#>
function Test-Wmic {
  [CmdletBinding()]
  param (
    [Parameter(HelpMessage = 'Reference the computer(s) to query.')]
    [string[]]
    $ComputerName
  )
  
  begin {}
  
  process {

    $wmic = 'wmic.exe'
    [array]$param = @()

    # WMIC requirement: If the hostname has a "-" or a "/" then wrap the hostname in double quotes    
    if ($null -like $ComputerName) {
      $ComputerName = HOSTNAME.EXE
    }    

    foreach ($Computer in $ComputerName) {

      # WMIC requirement: If the hostname has a "-" or a "/" then wrap the hostname in double quotes
      $param = "/node:`"$($Computer)`"", 'computersystem', 'get', 'name', '/format:list'
      
      try {
        $Results = & $wmic $param
      }
      catch {
        Write-Output "Ran into an issue: $($PSItem.ToString())`n`nThis was the exception thrown: $($PSItem.Exception)"
      }
      $Filtered = $Results | Where-Object { $_ }
      $ComputerName_Value = (($Filtered -split "=", 2).trim())[1]
      
      $prop = @{
        ComputerName      = $Computer
        WmicReturnedValue = $ComputerName_Value
      }

      $obj = New-Object -TypeName psobject -Property $prop
      Write-Output $obj       
      
    }

  }
  
  end {}
}

