

function Run-JumpListJLECmd {
  [CmdletBinding()]
  param (
    [Parameter(HelpMessage='Reference the full path to JLECmd.exe', Mandatory=$true)]
    [string]
    $JLECmd_Path,
    [Parameter(HelpMessage='Reference the Username with the profile on the machine for which you want to see Jump List information',Mandatory=$true)]
    [string]
    $Username,
    [Parameter(HelpMessage='Reference the location for the output files to be deposited. DEFAULT is current directory')]
    [string]
    $OutputPath = "$((Get-Location).Path)"
  )
  
  begin {}
  
  process {
    $Output = & "$JLECmd_Path" -d "C:\Users\$Username\AppData\Roaming\Microsoft\Windows\Recent\AutomaticDestinations\" --csv "$OutputPath" -q
  }
  
  end {
    $Outfile = $Output[-1] -replace "AutomaticDestinations CSV output will be saved to "

    Set-Variable -Name JLECmd_Outfile -Value $($Outfile.trim("'")) -Scope Global
    Write-Host ""
    Write-Host "Global Variable named 'JLECmd_Outfile' has been created, containing the 'Full Path' and 'Filename' of the .CSV with the parsed Jump List output" -ForegroundColor Green -BackgroundColor Black
    Write-Host ""
    Set-Variable -Name JLECmd_OutputOfCommand -Value $Output -Scope Global
    Write-Host ""
    Write-Host "Global Variable named 'JLECmd_OutputOfCommand' has been created" -ForegroundColor Green -BackgroundColor Black
    Write-Host ""
    
  }
}