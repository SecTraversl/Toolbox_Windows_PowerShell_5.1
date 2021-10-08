<#
.SYNOPSIS
  The "Test-PSScriptRoot" function demonstrates how the Automatic Variable "$PSScriptRoot" behaves.

.DESCRIPTION
.EXAMPLE
  PS Temp> Get-Variable | ? Name -eq PSScriptRoot

  Name                           Value
  ----                           -----
  PSScriptRoot                   C:\Users\Jannus.Fugal\Documents\WindowsPowerShell


  PS Temp> $PSScriptRoot

  PS Temp>
  PS Temp>
  PS Temp> $PROFILE
  C:\Users\Jannus.Fugal\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1
  PS Temp>
  PS Temp>
  PS Temp> cd .\ps1_files\PSScriptRoot\
  PS PSScriptRoot> ls


      Directory: C:\Users\Jannus.Fugal\Documents\Temp\ps1_files\PSScriptRoot


  Mode                 LastWriteTime         Length Name
  ----                 -------------         ------ ----
  -a----         9/16/2021   6:30 AM            303 Test-PSScriptRoot.ps1


  PS PSScriptRoot> .\Test-PSScriptRoot.ps1
  PS PSScriptRoot>
  PS PSScriptRoot> . .\Test-PSScriptRoot.ps1
  PS PSScriptRoot>
  PS PSScriptRoot> Test-PSScriptRoot

  The following is the value of the '$PSScriptRoot' variable:
  C:\Users\Jannus.Fugal\Documents\Temp\ps1_files\PSScriptRoot

  PS PSScriptRoot> $PSScriptRoot

  PS PSScriptRoot>



  Here we first have a demo of what information we can get about the $PSScriptRoot variable within a PowerShell terminal.  While 'Get-Variable' indicates that there is a value for the $PSScriptRoot variable, there isn't a string that is returned when we call the $PSScriptRoot variable (and that the "Script Root" that 'Get-Variable' is referring to is actually the $profile script).  We then run our "Test-PSScriptRoot" function and see that the value returned by the $PSScriptRoot variable in our script is the parent folder path for the 'Test-PSScriptRoot.ps1' file.  Thus we have a good example of what an "Automatic Variable" is and how it works - $PSScriptRoot doesn't store a permanent value, but instead contains a context-specific value.

.INPUTS
.OUTPUTS
.NOTES
  Name:  Test-PSScriptRoot.ps1
  Author:  Travis Logue
  Version History:  1.1 | 2021-09-16 | Initial Version
  Dependencies:  
  Notes:
  - This is where I found a good succinct description for what was going on with $PSScriptRoot:  https://riptutorial.com/powershell/example/27231/-psscriptroot
    - Here is what the author shared:
        Get-ChildItem -Path $PSScriptRoot
        This example retrieves the list of child items (directories and files) from the folder where the script file resides.

        The $PSScriptRoot automatic variable is $null if used from outside a PowerShell code file. If used inside a PowerShell script, it automatically defined the fully-qualified filesystem path to the directory that contains the script file.

        In Windows PowerShell 2.0, this variable is valid only in script modules (.psm1). Beginning in Windows PowerShell 3.0, it is valid in all scripts.


  . 
#>
function Test-PSScriptRoot {
  [CmdletBinding()]
  param ()
  
  begin {}
  
  process {
    
    Write-Host "`nThe following is the value of the '`$PSScriptRoot' variable:" -BackgroundColor Black -ForegroundColor Yellow
    Write-Output $PSScriptRoot
    Write-Host ""

  }
  
  end {}
}