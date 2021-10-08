<#
.SYNOPSIS
  The "Convert-Rtf2Txt" function takes a give .rtf file and creates a .txt version of the file.
.DESCRIPTION
.EXAMPLE
  PS C:\> <example usage>
  Explanation of what the example does
.INPUTS
.OUTPUTS
.NOTES
  Name: Convert-Rtf2Txt.ps1
  Author: Travis Logue
  Version History: 1.1 | 2021-09-03 | Initial Version
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
function Convert-Rtf2Txt {
  [CmdletBinding()]
  param (
    [Parameter()]
    [string]
    $RtfFilePath
  )
  
  begin {}
  
  process {

    try {

      [Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")

      $FileObject = Get-ChildItem $RtfFilePath
      $FullPath = $FileObject.FullName
  
      $DestinationFileName = $FullPath -replace ".rtf", ".txt"
  
      $RichTextBoxObject = New-Object System.Windows.Forms.RichTextBox
      $RtfText = [System.IO.File]::ReadAllText($FullPath)
  
      $RichTextBoxObject.Rtf = $RtfText
  
      $PlainText = $RichTextBoxObject.Text
  
      [System.IO.File]::WriteAllText($DestinationFileName, $PlainText)
      
    }
    catch {
      Write-Host $_.Exception
      Break
    }   
    
  }
  
  end {}
}