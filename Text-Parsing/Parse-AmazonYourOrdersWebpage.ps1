<#
.SYNOPSIS
  This is a parser that converts the raw text on the "Your Orders" page within your Amazon account into meaningful objects.
.DESCRIPTION
.EXAMPLE
  PS C:\> <example usage>
  Explanation of what the example does
.INPUTS
.OUTPUTS
.NOTES
  General notes


  .
#>
function Parse-AmazonYourOrdersWebpage {
  [CmdletBinding()]
  param (
    [Parameter(HelpMessage = 'From the "Your Orders" webpage, highlight from the top item starting at the "ORDER PLACED" text all the way down to the bottom item at the "Archive Order" text. Then copy that highlighted text.  Then submit that text to this "-RawText" parameter')]
    [psobject]
    $RawText
  )
  
  begin {}
  
  process {
    $subset = $RawText + "END OF THE LINE"

    for ($i = 0; $i -lt $subset.Count; $i++) {
      if ($subset[$i] -like "ORDER PLACED") {
        $counter = 0
        $content = @()
        $ItemsInOrder = [System.Collections.ArrayList]@()
        do {
          $content += $subset[$i + $counter]
          $counter += 1
          if ($null -like ($subset[$i + $counter])) {
            $ItemsInOrder += ($subset[$i + 1 + $counter])
          }
          #Write-Output $counter
        } until ($subset[$i + 1 + $counter] -like "END OF THE LINE" -or $subset[$i + 1 + $counter] -like "ORDER PLACED") 
        #Write-Output $content
        $prop = [ordered]@{
          Date        = ([datetime]($content[1])).ToShortDateString()
          Place       = 'Amazon'
          OrderTotal  = $content[3]
          OrderNumber = $content[6]
          #ItemsInOrder = 
          Tender      = 'Your Credit Card'
          Notes       = ($ItemsInOrder) -join "`n`n"
        }
        $obj = New-Object -TypeName psobject -Property $prop
        Write-Output $obj
      }
    }
  }
  
  end {}
}