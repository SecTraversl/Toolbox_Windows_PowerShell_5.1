<#
.SYNOPSIS
  The "Get-TextFromRtfFile" function takes a given .rtf file and returns the plain text found within it.
  
.DESCRIPTION
.EXAMPLE
  PS C:\> TextFromRtf 'fax_summary.rtf'

  GAC    Version        Location
  ---    -------        --------
  True   v4.0.30319     C:\WINDOWS\Microsoft.Net\assembly\GAC_MSIL\System.Windows.Forms\v4.0_4.0.0...
  FOSS Buying Group
  Accounting Summary Report
  (Pickups)
  End. Balance
  Total Vouchers
  Beg. Balance
  Unit Number
  07/25/2017 - 07/31/2017
  Boccas Market
  37200408
  1,423.63
  0.00
  2,625.58
  5,201.95
  4,423.63
  2,201.95
  0.00
  1,625.58
  Division Totals
  1,625.58
  Period Totals
  3,201.95
  5,423.63
  0.00



  Here we call the "Get-TextFromRtfFile" function by callings its built-in alias 'TextFromRtf'.  We reference the particular .rtf file we are interested in, and in return we get the plain text found in the document.

.INPUTS
.OUTPUTS
.NOTES
  Name: Get-TextFromRtfFile.ps1
  Author: Travis Logue
  Version History: 1.2 | 2021-09-10 | Added Out-Null when loading the Assembly
  Dependencies:
  Notes:
  - This provided me with a way of accessing the "RichTextBox" Assembly:   
    https://stackoverflow.com/questions/3113491/how-to-display-an-rtf-file-in-a-powershell-richtextbox

  - This was where I got the majority of the body of the code below:  
    https://www.reddit.com/r/PowerShell/comments/2h7p3k/convert_rtf_to_txt_without_ms_word/
    https://github.com/Asnivor/PowerShell-Misc-Functions/blob/master/translate-rtf-to-txt.ps1

  - This was a supplemental reference:  
    https://blog.kmsigma.com/2014/10/01/converting-rtf-to-txt-via-powershell/

    
  .
#>
function Get-TextFromRtfFile {
  [CmdletBinding()]
  [Alias('TextFromRtf')]
  param (
    [Parameter(Mandatory = $true)]
    [string]
    $RtfFilePath
  )
  
  begin {}
  
  process {
    
    try {

      [Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") | Out-Null

      $FileObject = Get-ChildItem $RtfFilePath
      $FullPath = $FileObject.FullName
  
      # $DestinationFileName = $FullPath -replace ".rtf", ".txt"
  
      $RichTextBoxObject = New-Object System.Windows.Forms.RichTextBox
      $RtfText = [System.IO.File]::ReadAllText($FullPath)
  
      $RichTextBoxObject.Rtf = $RtfText
  
      $PlainText = $RichTextBoxObject.Text
  
      Write-Output $PlainText
      
    }
    catch {
      Write-Host $_.Exception
      Break
    }   

  }
  
  end {}
}