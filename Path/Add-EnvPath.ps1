<#
.SYNOPSIS
  Updates the "PATH" Environment Variable.  Allows "PATH" to be changed for simply the current PowerShell Session, or allows for changes to the User Variable of "Path" for a user-specific persistent change.  Finally, allows for a change to the System Variable of "Path" for a machine-global change.  The $Prepend switch parameter allows the $Path to 'prepended' or placed first in the "Path" Environment Variable.

.DESCRIPTION
.EXAMPLE
  PS C:\> $env:path -split ';'
  C:\Program Files (x86)\Common Files\Oracle\Java\javapath
  C:\Program Files\AdoptOpenJDK\jre-8.0.232.09-hotspot\bin
  C:\Windows\system32
  C:\Windows
  C:\Windows\System32\Wbem
  C:\Windows\System32\WindowsPowerShell\v1.0\
  C:\Windows\System32\OpenSSH\
  C:\Users\mark.johnson\AppData\Local\Microsoft\WindowsApps
  C:\Users\mark.johnson\AppData\Local\Programs\Microsoft VS Code\bin
  C:\Users\mark.johnson\Documents\Temp\InPath\

  PS C:\> $TsharkParentDirectory = "C:\Program Files\Wireshark\"
  PS C:\> Add-EnvPath -Path $TsharkParentDirectory
  
  PS C:\> $env:path -split ';'
  C:\Program Files (x86)\Common Files\Oracle\Java\javapath
  C:\Program Files\AdoptOpenJDK\jre-8.0.232.09-hotspot\bin
  C:\Windows\system32
  C:\Windows
  C:\Windows\System32\Wbem
  C:\Windows\System32\WindowsPowerShell\v1.0\
  C:\Windows\System32\OpenSSH\
  C:\Users\mark.johnson\AppData\Local\Microsoft\WindowsApps
  C:\Users\mark.johnson\AppData\Local\Programs\Microsoft VS Code\bin
  C:\Users\mark.johnson\Documents\Temp\InPath\
  C:\Program Files\Wireshark\

  PS C:\> tshark -help
  TShark (Wireshark) 3.4.2 (v3.4.2-0-ga889cf1b1bf9)
  Dump and analyze network traffic.
  See https://www.wireshark.org for more information.

  Usage: tshark [options] ...



  Here we display the Environment Variable of %PATH% before and after running the function.  We specify the parent directory of the tool we want to run, which in this case is "tshark.exe".  After running the function we are able to run "tshark.exe" from our present directory, and we do so by displaying the "help" for the executable.

.EXAMPLE
  PS C:\> $env:path -split ';'
  C:\Program Files (x86)\Common Files\Oracle\Java\javapath
  C:\Program Files\AdoptOpenJDK\jre-8.0.232.09-hotspot\bin
  C:\Windows\system32
  C:\Windows
  C:\Windows\System32\Wbem
  C:\Windows\System32\WindowsPowerShell\v1.0\
  C:\Windows\System32\OpenSSH\
  C:\Users\mark.johnson\AppData\Local\Microsoft\WindowsApps
  C:\Users\mark.johnson\AppData\Local\Programs\Microsoft VS Code\bin
  C:\Users\mark.johnson\Documents\Temp\InPath\

  PS C:\> $TsharkParentDirectory = "C:\Program Files\Wireshark\"
  PS C:\>
  PS C:\> Add-EnvPath -Path $TsharkParentDirectory  -Persistence UserVariablePath
  PS C:\>

  ####################################################
  ##### AFTER STARTING A NEW POWERSHELL TERMINAL #####
  ####################################################

  Loading personal and system profiles took 5311ms.
  PS C:\>
  PS C:\> $env:Path -split ';'
  C:\Program Files (x86)\Common Files\Oracle\Java\javapath
  C:\Program Files\AdoptOpenJDK\jre-8.0.232.09-hotspot\bin
  C:\Windows\system32
  C:\Windows
  C:\Windows\System32\Wbem
  C:\Windows\System32\WindowsPowerShell\v1.0\
  C:\Windows\System32\OpenSSH\
  C:\Users\mark.johnson\AppData\Local\Microsoft\WindowsApps
  C:\Users\mark.johnson\AppData\Local\Programs\Microsoft VS Code\bin
  C:\Users\mark.johnson\Documents\Temp\InPath\
  C:\Program Files\Wireshark\

  PS C:\> tshark.exe -help
  TShark (Wireshark) 3.4.2 (v3.4.2-0-ga889cf1b1bf9)
  Dump and analyze network traffic.
  See https://www.wireshark.org for more information.

  Usage: tshark [options] ...



  Here we leverage the "-Persistence" parameter in the function and specify 'UserVariablePath'.  This particular parameter has 3 preset options - 'SessionOnly','UserVariablePath', and 'SystemVariablePath'; the default for the function is 'SessionOnly' but in this example we overrode the default.  By specifying "-Persistence UserVariablePath" a permanent change is made to the %PATH% environment variable for the particular user, such that the next time a terminal is opened the specified directory will be in %PATH%.

.INPUTS
.OUTPUTS
.NOTES
  Name: Add-EnvPath
  Author: Travis Logue
  Version History: 1.0 | 2020-12-21 | Initial Version
  Dependencies:
  Notes:
    - This was helpful in determining the syntax and approach for the code below (Also shows use of the "setx" tool and interesting uses for calling the [Environment] class and related classes): https://stackoverflow.com/questions/714877/setting-windows-powershell-environment-variables


  .
#>
function Add-EnvPath {
  [CmdletBinding()]
  param (
    [Parameter(HelpMessage='Reference the Path you want to add to "PATH" Environment Variable')]
    [string]
    $Path,
    [Parameter(HelpMessage='If you want the given $Path to be Prepended (or placed first) in the "Path" Env Var, use this Switch Parameter. NOTE - This will make the give $Path the first search location for files and binaries.')]
    [switch]
    $Prepend,
    [Parameter(HelpMessage='This parameter has a ValidateSetAttribute where you can specify one of three options. "SessionOnly" updates the "Path" Env Var for the present PowerShell session.  "UserVariablePath" creates a permanent change that is user-specific.  "SystemVariablePath" creates a permanent change that is machine-global.')]
    [ValidateSet('SessionOnly','UserVariablePath','SystemVariablePath')]
    [string]
    $Persistence = 'SessionOnly'
  )
  
  begin {}
  
  process {

    $UserVarPathValue = [Environment]::GetEnvironmentVariable('Path','User')
    $SystemVarPathValue = [Environment]::GetEnvironmentVariable('Path','Machine')

    switch ($Persistence) {

      'SessionOnly' { if ($Prepend) { $env:Path = "$Path;$env:Path" } else { $env:Path += ";$Path" } }
      'UserVariablePath' { 
        if ($Prepend) {  
          $NewPath = $Path + ';' + $UserVarPathValue
          [Environment]::SetEnvironmentVariable('Path',$NewPath,'User')
        }
        else {
          $NewPath = $UserVarPathValue + ';' + $Path
          [Environment]::SetEnvironmentVariable('Path',$NewPath,'User')
        }
       }
      'SystemVariablePath' { 
        if ($Prepend) {  
          $NewPath = $Path + ';' + $SystemVarPathValue
          [Environment]::SetEnvironmentVariable('Path',$NewPath,'Machine')
        }
        else {
          $NewPath = $SystemVarPathValue + ';' + $Path
          [Environment]::SetEnvironmentVariable('Path',$NewPath,'Machine')
        }
       }

      }

    }  
  
  end {}
}