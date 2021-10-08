

function Get-StringHash {
    [CmdletBinding()]
    param (
        [string]$String,

        [ValidateSet("MD5", "RIPEMD160", "SHA1", "SHA256", "SHA384", "SHA512")]
        [string]$HashName = "MD5"
    )
    
    $StringBuilder = New-Object System.Text.StringBuilder 
    [System.Security.Cryptography.HashAlgorithm]::Create($HashName).ComputeHash([System.Text.Encoding]::UTF8.GetBytes($String)) | % { 
        [Void]$StringBuilder.Append($_.ToString("x2")) 
    } 
    $StringBuilder.ToString()
   
}


##########################################################
# This is where I found this function: 
#       https://gallery.technet.microsoft.com/scriptcenter/Get-StringHash-aa843f71
#
# AWESOME RECOMMENDATION:  THE [ValidateSet] Attribute
# mentioned by one of the comments here:
#       https://gallery.technet.microsoft.com/scriptcenter/Get-StringHash-aa843f71/view/Discussions#content
#  
# And further researched here (I used the example here as the template):
#       https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_functions_advanced_parameters?view=powershell-6



##############################################################
#  ORIGINAL function, before I augmented it ;)  

#http://jongurgul.com/blog/get-stringhash-get-filehash/ 


<#

Function Get-StringHash([String] $String,$HashName = "MD5") 
{ 
$StringBuilder = New-Object System.Text.StringBuilder 
[System.Security.Cryptography.HashAlgorithm]::Create($HashName).ComputeHash([System.Text.Encoding]::UTF8.GetBytes($String))|%{ 
[Void]$StringBuilder.Append($_.ToString("x2")) 
} 
$StringBuilder.ToString() 
}

#>