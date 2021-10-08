

<#
.SYNOPSIS
  Brings the specified GUI program to the forefront.
.DESCRIPTION
.EXAMPLE
  PS C:\> Restore-Gui2Forefront -ProcessName outlook
  This brings the program "Outlook.exe" to the forefront
.INPUTS
.OUTPUTS
.NOTES
  This was helpful in understanding how to create the one version of the code below: https://stackoverflow.com/questions/4993926/maximize-window-and-bring-it-in-front-with-powershell
  - I did find that "ShowWindowAsync" didn't work consistently... doing a "Start-Sleep 2" seemed to help, but the results weren't consistent and I had to run the code twice to get the desired effect
  - Nevertheless, the link above gave me the basis code and I did get some results...
  There was helpful comment in the link above mentioning the use of "SwitchToThisWindow", which I then started to explore

  This was helpful in supplying further discussion about "SwitchToThisWindow","SetForegroundWindow", and citing an interesting link from Lee Holmes regarding P/Invoke (https://www.leeholmes.com/blog/2006/07/25/more-pinvoke-in-powershell/); the link to that forum post is here: https://stackoverflow.com/questions/2556872/how-to-set-foreground-window-from-powershell-event-subscriber-action


#>
function Set-Gui2Forefront {
  [CmdletBinding()]
  param (
    [Parameter()]
    [string]
    $ProcessName
  )
  
  begin {}
  
  process {
    $sig = '[DllImport("user32.dll", SetLastError=true)] public static extern void SwitchToThisWindow(IntPtr hWnd, bool fAltTab);'
    #$sig = '[DllImport("user32.dll")] public static extern bool ShowWindowAsync(IntPtr hWnd, int nCmdShow);'
    Add-Type -MemberDefinition $sig -name NativeMethods -namespace Win32

    $Proc = Get-Process -Name $ProcessName | Where-Object {$_.MainWindowHandle -notlike 0}

    #[Win32.NativeMethods]::ShowWindowAsync($Proc.MainWindowHandle, 2)
    #Start-Sleep -Seconds 2

    [Win32.NativeMethods]::SwitchToThisWindow($Proc.MainWindowHandle, 4)

  }
  
  end {}
}