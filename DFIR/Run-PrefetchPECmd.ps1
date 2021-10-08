

function Run-PrefetchPECmd {
  [CmdletBinding()]
  param (
    [Parameter(HelpMessage='Reference the full path to PECmd.exe', Mandatory=$true)]
    [string]
    $PECmd_Path,
    [Parameter(HelpMessage='Reference the location for the output files to be deposited. DEFAULT is current directory')]
    [string]
    $OutputPath = "$((Get-Location).Path)"
  )
  
  begin {}
  
  process {
    $Output = & "$PECmd_Path" -d "C:\Windows\Prefetch\" --csv "$OutputPath" -q
  }
  
  end {
    $Outfile = $Output[-2] -replace "CSV output will be saved to "

    Set-Variable -Name PECmd_Outfile -Value $($Outfile.trim("'")) -Scope Global
    Write-Host ""
    Write-Host "Global Variable named 'PECmd_Outfile' has been created, containing the 'Full Path' and 'Filename' of the .CSV with the parsed Prefetch output" -ForegroundColor Green -BackgroundColor Black
    Write-Host ""
    Set-Variable -Name PECmd_OutputOfCommand -Value $Output -Scope Global
    Write-Host ""
    Write-Host "Global Variable named 'PECmd_OutputOfCommand' has been created" -ForegroundColor Green -BackgroundColor Black
    Write-Host "`n"
  }
}