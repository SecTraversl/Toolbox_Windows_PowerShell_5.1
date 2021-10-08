

function Destroy-History {
  [CmdletBinding()]
  param ()
  
  begin {}
  
  process {
    Clear-History
    [Microsoft.PowerShell.PSConsoleReadLine]::ClearHistory()
    rm (Get-PSReadLineOption).HistorySavePath
  }
  
  end {}
}