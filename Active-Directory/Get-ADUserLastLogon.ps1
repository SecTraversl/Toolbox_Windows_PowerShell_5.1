<#
.SYNOPSIS
  The "Get-ADUserLastLogon" function takes a given SamAccountName of an AD User and returns the 'LastLogon' property associated with that user.
  
.DESCRIPTION
.EXAMPLE
  PS C:\> LastLogonForADUser -SamAccountName Jannus.Fugal, Cyan.Foss

  DomainController              LastLogon            DC Status SamAccountName
  ----------------              ---------            --------- --------------
  ANWPORCBC03.subd.MyDomain.com 9/23/2021 3:18:26 PM Reachable Jannus.Fugal
  ANWPORCBC04.subd.MyDomain.com 9/22/2021 7:17:13 AM Reachable Jannus.Fugal
  RADPORCDC01.subd.MyDomain.com 12/31/1600 4:00:0... Reachable Jannus.Fugal
  ANWPORCBC03.subd.MyDomain.com 9/23/2021 9:06:20 AM Reachable Cyan.Foss
  ANWPORCBC04.subd.MyDomain.com 9/22/2021 1:37:42 PM Reachable Cyan.Foss
  RADPORCDC01.subd.MyDomain.com 9/8/2021 9:32:36 AM  Reachable Cyan.Foss



  Here we run the function by calling its built-in alias of "LastLogonForADUser" and by supplying two SamAccountNames to the "-SamAccountName" parameter.  In return we receive the 'LastLogon" timestamps for the users as seen by the 3 Domain Controllers in the domain (the default domain that is queried is the one found in the variable $env:USERDOMAIN, but this can be overidden by explicitly specifying a domain name while using the "-DomainName" parameter).

.EXAMPLE
  PS C:\> Get-ADUserLastLogon -SamAccountName Jannus.Fugal, Cyan.Foss -MostRecentLogonOnly

  DomainController              LastLogon            DC Status SamAccountName
  ----------------              ---------            --------- --------------
  ANWPORCBC03.subd.MyDomain.com 9/23/2021 9:06:20 AM Reachable Cyan.Foss
  ANWPORCBC03.subd.MyDomain.com 9/23/2021 3:18:26 PM Reachable Jannus.Fugal



  Here we run the function as we did in the first example, but this time with adding the "-MostRecentLogonOnly" switch parameter.  In return, we get only the entries for each SamAccountName that have the most recent datetime stamp.

.INPUTS
.OUTPUTS
.NOTES
  Name:  Get-ADUserLastLogon.ps1
  Author:  Travis Logue
  Version History:  1.4 | 2021-09-23 | Updated Version
  Dependencies:  ActiveDirectory module
  Notes:
  - I got this format from Don Jones, derived from "Don Jones Toolmaking Part 1 3":  https://www.youtube.com/watch?v=KprrLkjPq_c

  - Here is the reference from where we retrieved the idea of using [datetime]::FromFileTime() to convert the timestamp:  https://docs.microsoft.com/en-us/archive/blogs/poshchap/one-liner-get-a-list-of-ad-users-password-expiry-dates
    - Old way using w32tm.exe -ntte:  
        ♣ Temp> w32tm.exe -ntte 132665259961917071
        153547 18:06:36.1917071 - 5/26/2021 11:06:36 AM

    - New way using [datetime]::FromFileTime()
        √ Temp> [datetime]::FromFileTime(132665259961917071)

        Wednesday, May 26, 2021 11:06:36 AM
  
  - Here is the reference we used for retrieving the "most recent" date time for each SamAccountName:  https://stackoverflow.com/questions/35023850/finding-the-largest-time-in-an-array

  - It appears that the Last Logon value from the Primary Domain Controller has had the most recent logon timestamp (and the most correct timestamp) 


  .
#>
function Get-ADUserLastLogon {
  [CmdletBinding()]
  [Alias('LastLogonForADUser')]
  param (
    [Parameter(Mandatory, HelpMessage = "Enter the SamAccountName for the User")]
    [string[]]
    $SamAccountName,
    [Parameter(HelpMessage = "Enter the name of the Domain")]
    [string]
    $DomainName = "$env:USERDOMAIN",
    [Parameter()]
    [switch]
    $MostRecentLogonOnly
  )
  
  begin {
    # Defines a helper function used later in the tool
    
    function Get-DomainControllers {
      [CmdletBinding()]
      param (
        [Parameter(HelpMessage = "Enter the name of the Domain")]
        [string]
        $DomainName = "$env:USERDOMAIN"
      )            
              
      $DCList = nltest.exe /dclist:$DomainName
      $Results = (( $DCList | Select-String -Pattern "\[DS\]" ) -replace "\[.*", "").Trim()
      Write-Output $Results             
      
    }

  }
  
  process {
    # Main code for the function

    $ListOfDomainControllers = Get-DomainControllers -DomainName $DomainName

    $Results = foreach ($Account in $SamAccountName) {
      
      foreach ($DC in $ListOfDomainControllers) {
      
        try {
          $LastLogon = Get-ADuser -Filter "SamAccountName -like '$Account'" -Properties LastLogon -Server $DC
          # $TimeConvertedLastLogon = w32tm.exe /ntte $LastLogon.lastlogon
          $TimeConvertedLastLogon = [datetime]::FromFileTime($LastLogon.lastlogon)
  
          $prop = @{
            'DC Status'      = 'Reachable'
            DomainController = $DC
            SamAccountName   = $Account
            LastLogon        = $TimeConvertedLastLogon
          }
        }
        catch {
          $prop = @{
            'DC Status'      = 'Not Reachable'
            DomainController = $DC
            SamAccountName   = $null
            LastLogon        = $null
          }
        }
        finally {        
          $obj = New-Object -TypeName psobject -Property $prop
          Write-Output $obj
        }
  
      }

    }

    if ($MostRecentLogonOnly) {      
      $UniqueSamAccountNames = $Results.SamAccountName | Sort-Object -Unique

      foreach ($Name in $UniqueSamAccountNames) {
        $LogonEntries = $Results | Where-Object SamAccountName -eq $Name
        $MostRecent = ($LogonEntries | Sort-Object LastLogon)[-1]
        Write-Output $MostRecent
      }
    }
    else {
      Write-Output $Results
    }
    
  }
  
  end {}
}