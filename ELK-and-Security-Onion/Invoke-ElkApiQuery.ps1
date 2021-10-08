<#
.SYNOPSIS
  The "Invoke-ElkApiQuery" function takes a given JSON query string and retrieves the data from that query using the Elasticsearch API.  Instead of memorizing the JSON query syntax, you can retrieve the properly formatted JSON query string directly from Kibana.  Simply create a query that retrieves the desired data in "Discover", then Hide the Chart, click on "Request", and select the JSON text starting with "query": { ... }.  Copy that "query" block and reference it as an argument for the "-JsonQueryString" parameter.

.DESCRIPTION
.EXAMPLE
  PS C:\> $QueryString_Sysmon = '
  >>   "query": {
  >>     "bool": {
  >>       "must": [
  >>         {
  >>           "query_string": {
  >>             "query": "log_name:*sysmon*",
  >>             "analyze_wildcard": true,
  >>             "default_field": "*"
  >>           }
  >>         },
  >>         {
  >>           "range": {
  >>             "@timestamp": {
  >>               "gte": 1629156159503,
  >>               "lte": 1629242559503,
  >>               "format": "epoch_millis"
  >>             }
  >>           }
  >>         }
  >>       ],
  >>       "filter": [],
  >>       "should": [],
  >>       "must_not": []
  >>     }
  >>   }'
  PS C:\>
  PS C:\> $cred = Get-Credential

  cmdlet Get-Credential at command pipeline position 1
  Supply values for the following parameters:
  Credential

  PS C:\> $SysmonLogs = ElkQuery -JsonQueryString $QueryString_Sysmon -PSCredential $cred
  PS C:\>
  PS C:\> $SysmonLogs.hits.hits | measure
  Count    : 50

  PS C:\> $SysmonLogs.hits.hits | select -First 1

  _index  : fordawinlog-2021.08.12
  _type   : doc
  _id     : OIzUN3sB8gEdn0Qv4QGF
  _score  : 7.9051437
  _source : @{log_name=System; host=fordawin01; @version=1; @timestamp=2021-08-12T00:47:51.214Z; event_id=7045; event_data=;
            source_name=Service Control Manager; thread_id=2504; provider_guid={555908d1-a6d7-4695-8e1e-26931d2012f4};
            keywords=System.Object[]; level=Information; message=A service was installed in the system.

            Service Name:  System Update
            Service File Name:  "C:\Program Files (x86)\Lenovo\System Update\SUService.exe"
            Service Type:  user mode service
            Service Start Type:  demand start
            Service Account:  LocalSystem; process_id=744; beat=; computer_name=RBHQDHEIPP1-L.subd.MyDomain.com; record_number=130453;
            tags=System.Object[]; user=; type=fordawinlog}



  Here we retrieve the proper JSON query syntax from Kibana > Discover > Request, and put that query into a single string within the variable "$QueryString_Sysmon".  We then put our credentials for accessing Elasticsearch into the variable "$cred" using the Get-Credential cmdlet.  Then we run the "Invoke-ElkApiQuery" function using its alias of 'ElkQuery' and by supplying the necessary arguments to the "-JsonQueryString" and "-PSCredential" parameters.  Finally, we see that the default for the function is to retrieve 50 log entries from Elasticsearch, and we view the first log entry that was returned.

.INPUTS
.OUTPUTS
.NOTES
  Name: Invoke-ElkApiQuery.ps1
  Author: Travis Logue
  Version History: 1.3 | 2021-09-01 | Added the switch parameter "-HitsReturnedOnly"
  Dependencies:
  Notes:
  - Learned how to increase the default "size" of returned objects via this post: https://discuss.elastic.co/t/get-query-is-showing-only-10-results-while-searching-for-a-particular-data/88187
    - Specifically:
        If you change your query to GET exchangemails/email/_search?_source=sender&size=50 then you'll get 50 records.

        /exchangemails/email/_search?_source=sender&from=50&size=50 will then get the next "page" of results.

  - Got the idea of proper syntax to select a particular index in the query via this post: https://www.elastic.co/guide/en/elasticsearch/reference/current/mapping-index-field.html
    - Specifically:
        GET index_1,index_2/_search
        {
          "query": {
        ...
    - Adapted to:
        GET wineventlog-*/_search
        {
          "query": {
        ...


  .
#>

function Invoke-ElkApiQuery {
  [CmdletBinding()]
  [Alias('ElkQuery')]
  param (
    [Parameter(Mandatory)]
    [string]
    $JsonQueryString,
    [Parameter()]
    [pscredential]
    $PSCredential,
    [Parameter()]
    [ValidateSet(<#Redacted... Here we defined hardcoded options for often-used Indices#>)]
    [string]
    $Index,
    [Parameter(HelpMessage = 'Specify the number of results to return.  Default is 50.')]
    [int]
    $Size = 50,
    [Parameter(HelpMessage = 'Returns the actual logs as the primary object.  Removes the need to use ".hits.hits._source" in order to get to the logs.')]
    [switch]
    $HitsReturnedOnly,
    [Parameter()]
    [string]
    $ElkServerSocket # = "192.168.10.10:8300" # Input default value
  )
  
  begin {}
  
  process {
    if ($PSCredential) {
      $creds = $PSCredential
    }
    else {
      $creds = Get-Credential
    }

    # This was a temporary workaround for overcoming the error:
    #  -  Invoke-RestMethod : The underlying connection was closed: Could not establish trust relationship for the SSL/TLS secure channel.
    # https://stackoverflow.com/questions/11696944/powershell-v3-invoke-webrequest-https-error
    add-type @"
    using System.Net;
    using System.Security.Cryptography.X509Certificates;
    public class TrustAllCertsPolicy : ICertificatePolicy {
        public bool CheckValidationResult(
            ServicePoint srvPoint, X509Certificate certificate,
            WebRequest request, int certificateProblem) {
            return true;
        }
    }
"@
    [System.Net.ServicePointManager]::CertificatePolicy = New-Object TrustAllCertsPolicy


    if ($JsonQueryString.Trim().StartsWith('{')) {
      $Body = $JsonQueryString
    }
    else {
      $Body = '{' + $JsonQueryString + '}'
    }

    if ($Index) {
      switch ($Index) {
        <#
        Redacted...
        Here we defined various Indexes to use with our Validate Set Attribute ("Index" parameter) above and what they map to
        #>
      }

      $Results = Invoke-RestMethod -Credential $creds  -Headers @{'Content-type' = 'application/json' }  -Method Post -Uri "https://$($ElkServerSocket)/$($IndexToUse)/_search?size=$Size" -Body $Body
    }
    else {
      $Results = Invoke-RestMethod -Credential $creds  -Headers @{'Content-type' = 'application/json' }  -Method Post -Uri "https://$($ElkServerSocket)/_search?size=$Size" -Body $Body
    }

    if ($HitsReturnedOnly) {
      $Results = $Results.hits.hits._source
      Write-Output $Results
    }
    else {
      Write-Output $Results
    }

    
  }
  
  end {}
}