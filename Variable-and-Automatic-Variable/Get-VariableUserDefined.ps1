<#
.SYNOPSIS
  The "Get-VariableUserDefined" function displays any variables that were created by the user during the present PowerShell session, as well as any variables created by the $PROFILE script when the PowerShell session was started.

.DESCRIPTION
.EXAMPLE
  PS C:\> $blah = 'blahblahblahs'
  PS C:\>
  PS C:\> Get-VariableUserDefined

  Name                           Value
  ----                           -----
  blah                           blahblahblahs
  ChocolateyProfile              \helpers\chocolateyProfile.psm1



  Here we first created a variable called $blah and set a value to it.  We then ran the function and then we see the variable we just created, as well as a defined variable in the user's profile script.

.INPUTS
.OUTPUTS
.NOTES
  Name: Get-VariableUserDefined.ps1
  Author: Travis Logue
  Version History: 2.0 | 2021-02-02 | Changed the way the code was structured and added descriptive comments
  Dependencies:
  Notes:
  - This was helpful in giving me the code bits to create the function below.  I changed the formatting and the function name but the core of the code was from here (retrieved on 2020-04-17): https://stackoverflow.com/questions/18419136/how-do-you-list-only-user-created-variables-in-powershell
  - I also did some experimentation with "[psobject].Assembly.GetType('System.Management.Automation.SpecialVariables').GetFields('NonPublic,Static')" and those notes can be found in the document: "Notes - EXAMPLE - PSObject - using PSobject.Assembly.GetType to search certain GetFields and find default system variables.txt"
  

  .
#>
function Get-VariableUserDefined {
  [CmdletBinding()]
  param ()
  
  begin {}
  
  process {
    # This top block references a whole listing of Variables that exist by default and removes them from the final output
    Get-Variable | Where-Object {
      (
        ([psobject].Assembly.GetType('System.Management.Automation.SpecialVariables').GetFields('NonPublic,Static') | Where-Object FieldType -eq ([string]) | 
        ForEach-Object GetValue $null) -notcontains $_.Name
      )  `
      -and `
      @("FormatEnumerationLimit","MaximumAliasCount","MaximumDriveCount","MaximumErrorCount","MaximumFunctionCount","MaximumVariableCount","PGHome","PGSE","PGUICulture","PGVersionTable","PROFILE","PSSessionOption") -notcontains $_.Name
    }
    # This bottom block is used to specifically remove the Variables with a name in the [array] @().  These were the Variables that were left over from the top block code.
  }
  
  end {}
}