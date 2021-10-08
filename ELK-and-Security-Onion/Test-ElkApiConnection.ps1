function Test-ElkApiConnection {
  [CmdletBinding()]
  param (
    [Parameter()]
    [pscredential]
    $PSCredential
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

    Invoke-RestMethod -Headers @{'Content-type' = 'application/json' }  -Method get -Uri 'https://10.20.73.101:9200/_cat/indices?v' -Credential $creds

  }
  
  end {}
}