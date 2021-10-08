
function uptime {
  (Get-Date) - (Get-CimInstance -ClassName Win32_OperatingSystem).LastBootUpTime
}