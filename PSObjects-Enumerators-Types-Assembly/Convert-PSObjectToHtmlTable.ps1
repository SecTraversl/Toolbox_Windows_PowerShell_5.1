<#
.SYNOPSIS
  Short description
.DESCRIPTION
.EXAMPLE
  PS C:\> <example usage>
  Explanation of what the example does
.INPUTS
.OUTPUTS
.NOTES
  Name:  Convert-PSObjectToHtmlTable.ps1
  Author:  Travis Logue
  Version History:  1.0 | 2021-03-04 | Initial Version
  Dependencies:
  Notes:
    - This was where I found the initial code used as the base for the function below: https://www.powershellbros.com/create-your-own-html-report-email/


  .
#>
function Convert-PSObjectToHtmlTable {
  [CmdletBinding()]
  param (
    [Parameter(Mandatory=$true, HelpMessage='Reference the PSObject from which to create a HTML Table')]
    [psobject]
    $PSObject,
    [Parameter(HelpMessage='Reference the Title name for the HTML Table')]
    [string]
    $Title
  )
  
  begin {}
  
  process {

    # Creating head style
$Head = @"
  
<style>
  body {
    font-family: "Arial";
    font-size: 8pt;
    color: #4C607B;
    }
  th, td { 
    border: 1px solid #e57300;
    border-collapse: collapse;
    padding: 5px;
    }
  th {
    font-size: 1.2em;
    text-align: left;
    background-color: #003366;
    color: #ffffff;
    }
  td {
    color: #000000;
    }
  .even { background-color: #ffffff; }
  .odd { background-color: #bfbfbf; }
</style>
  
"@

    [string]$HtmlBody = $PSObject | ConvertTo-Html -Head $Head -Body "<font color=`"Black`"><h4>$Title</h4></font>" 

    Write-Output $HtmlBody

  }
  
  end {}
}