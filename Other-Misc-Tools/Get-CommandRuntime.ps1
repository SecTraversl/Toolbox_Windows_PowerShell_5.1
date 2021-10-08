<#
.SYNOPSIS
    Shows how long a previous command took to complete.  Default is to reference the last command that was run, but this can be modified with the "-Previous" parameter.
.DESCRIPTION
.EXAMPLE
    PS C:\> <example usage>
    Explanation of what the example does
.INPUTS
.OUTPUTS
.NOTES
    General notes
#>
function Get-CommandRuntime {
    [CmdletBinding()]
    param (
        [Parameter(
            HelpMessage = "How far back in your command history")]
        [int]$Previous = "1"
    )
    
    (Get-History)[ - $Previous].EndExecutionTime - (Get-History)[ - $Previous].StartExecutionTime
}