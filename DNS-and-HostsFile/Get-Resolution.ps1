

# Scratch Paper: 
#   nslookup s3.amazonaws.com. 1.1.1.1
#
#   Resolve-DnsName s3-1.amazonaws.com -DnsOnly -Server 1.1.1.1
#
#   ? {$_.psobject.BaseObject.Type -eq "A"}


function Get-Resolution {
    [CmdletBinding()]
    param (
        [string]$Lookup,
        [string]$Server = "1.1.1.1"
    )
    

    Begin {

        if ( $LookUp -match "^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$" ) {

            $Results = cmd /c " nslookup $Lookup $Server "

            $PTR_Record = $Results | select -Skip 2 | ? { $_ }

            $Name = ($PTR_Record | sls name ) -replace "Name:\s+", ""
            $IP = ($PTR_Record | sls address) -replace "Address:\s+", ""
            
        }

        else {
            $Results = Resolve-DnsName "$Lookup." -DnsOnly -Server $Server

            $A_Record = $Results | ? { $_.psobject.BaseObject.Type -eq "A" }

            $Name = $A_Record.Name
            $IP = $A_Record.IP4Address
        }

    } #begin
                   
     
    Process {
        

        Function Test-WhoIs {

            # Original code Found at: https://www.petri.com/powershell-problem-solver
            # Title: Identifying Website Visitor IP Addresses Using PowerShell
            # Posted on June 9, 2015 by Jeff Hicks in PowerShell
            # Modified for my purposes:  August 12, 2019    
     
            [cmdletbinding()]
            Param (
                [parameter(Position = 0, Mandatory, HelpMessage = "Enter an IPv4 Address.",
                    ValueFromPipeline, ValueFromPipelineByPropertyName)]
                [Alias("Address")]
                [ValidatePattern("^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$")]
                [string]$IP        
            )

     
            Write-Verbose "Starting $($MyInvocation.Mycommand)"  
            $baseURL = 'http://whois.arin.net/rest'
            #default is XML anyway
            $header = @{"Accept" = "application/xml" }
             
   
            $url = "$baseUrl/ip/$ip"
            $r = Invoke-Restmethod $url -Headers $header
     
            Write-verbose ($r.net | out-string)
        
            $propHash = [ordered]@{
                IP                     = $ip
                Name                   = $Name
                RegisteredOrganization = $r.net.orgRef.name
                City                   = (Invoke-RestMethod $r.net.orgRef.'#text').org.city
                StartAddress           = $r.net.startAddress
                EndAddress             = $r.net.endAddress
                NetBlocks              = $r.net.netBlocks.netBlock | foreach { "$($_.startaddress)/$($_.cidrLength)" }
                Updated                = $r.net.updateDate -as [datetime]   
            }

            [pscustomobject]$propHash                   
                      
            Write-Verbose "Ending $($MyInvocation.Mycommand)"
     
        } #end Get-WhoIs

        $WhoIsResults = Test-WhoIs $IP

        Write-Output $WhoIsResults

    }

    End {

        # The below was originally added to be "Appended" to the output object above...
        # ... but instead I just modified the Ordered Hashtable to reference the "$Name" variable
        # ... from the Parent Scope

        #$WhoIsResults | Add-Member -NotePropertyName Name -NotePropertyValue $Name
        #$WhoIsResults | select *

    }


}



