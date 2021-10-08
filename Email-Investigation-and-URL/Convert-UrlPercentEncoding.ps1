
#################################
# RESEARCH / RESOURCES
<#
This was where I retrieved the ASCII to URL Percent Encoded Character Mapping
 - https://www.w3schools.com/tags/ref_urlencode.asp

I also used these in my validation phase:
 - https://developer.mozilla.org/en-US/docs/Glossary/percent-encoding#:~:text=Percent%2Dencoding%20is%20a%20mechanism,value%20of%20the%20replace%20character.

 - https://www.url-encode-decode.com/

#>


#################################
#  GOTCHAs
<#
There was some significant manipulation done automatically by Excel when I tried to copy the the table from the URL above ("ASCII to URL Percent Encoded Character Mapping")
 - Specifically, Excel transposed the "%" sign so that it was no longer in the front (e.g. "%40") but instead showed in the cell as being at the end (e.g. "40%")
 - Naturally, this significantly impacted the end result
 - I was able to overcome this... but I had to do 1) Copy the Table from the webpage  2) Manipulate that content in PowerShell  3) and Copy that manipulated content with "Set-Clipboard" in order to paste in the results into this function
 - While manipulating the content with PowerShell worked for the majority of Table, I still had to do a little manual tweaking with certain rows by comparing what the Table from the webpage actually had
 - The PowerShell logic I used to accomplish this is in the next section
#>

#################################
# MANIPULATING THE INFO WITH POWERSHELL
<#
1. Go the URL above, copy the "ASCII Encoding Reference" Table into the Clipboard
2. PowerShell:

$z = gcb
$TryAgain = $z | ConvertFrom-Csv -Delimiter "`t"
$TryAgain | Export-Csv -NoTypeInformation '.\Web and HTTP stuff\CorrectMapping.csv'

$Mapping = $TryAgain

$WindowsAscii = $Mapping.Character
$PercentEncoding = $Mapping.'From Windows-1252'

$Index = 0

$Final = @()
while ($Index -le ($WindowsAscii).Length) {
  $Content = "'$($PercentEncoding[$Index])' { '$($WindowsAscii[$Index])' }"
  $Final += $Content
  $Index += 1
}

$Final | scb


3. Paste the contents within a "Switch Statement Table", e.g.:

  switch ($x) {
  condition {  }
  Default {}
  }

4. Make changes to entries such as "'" and '"' and anything else, by comparing the output to the "ASCII Encoding Reference"

#>



#################################
# THIS WAS WHAT I USED INITIALLY TO BUILD THE CODE, BUT HAD TO STOP USING THIS 'IMPORT-CSV' BECAUSE THE CHARACTER MAPPING WAS MESSED UP (this is what I mentioned above; nevertheless the rest of the code basically stayed the same)

<#
$String = 'https%3A%2F%2scrubbed-this-entry.web.app%2F%3Femail%3Djohn.doe%40coinstar.com'
$AsciiToUrlEncoding = ipcsv '.\Web and HTTP stuff\CorrectMapping.csv'


$IndexCheck = 0

while ($IndexCheck -notlike -1) {
  $Index = $String.IndexOfAny('%')
  $PercentEncodedChars = $String[$Index..($Index + 2)] -join ''

  $BeginningOfString = $String[0..($Index-1)] -join ''

  $AsciiCharacter = ($AsciiToUrlEncoding | ? {$_.'From Windows-1252' -like $PercentEncodedChars}).Character

  $EndOfString = $String[($Index+3)..($String.Length)] -join ''

  $String = $BeginningOfString + $AsciiCharacter + $EndOfString

  $IndexCheck = $String.IndexOfAny('%')
}
#>

#########################

function Convert-UrlPercentEncoding {
  [CmdletBinding()]
  param (
    [Parameter(HelpMessage='Reference the String to be converted')]
    [string]
    $String
  )
  
  begin {
    
  }
  
  process {
    $IndexCheck = 0

    while ($IndexCheck -ne -1) {
      $Index = $String.IndexOf('%')
      if ($Index -ne -1) {
        $PercentEncodedChars = $String[$Index..($Index + 2)] -join ''

        $BeginningOfString = $String[0..($Index-1)] -join ''

        $AsciiCharacter = switch ($PercentEncodedChars) {
          '%20' { ' ' }
          '%21' { '!' }
          '%22' { '"' }
          '%24' { '$' }
          '%25' { '%' }
          '%26' { '&' }
          '%27' { "'" }
          '%28' { '(' }
          '%29' { ')' }
          '%2A' { '*' }
          '%2B' { '+' }
          '%2C' { ',' }
          '%2D' { '-' }
          '%2E' { '.' }
          '%2F' { '/' }
          '%30' { '0' }
          '%31' { '1' }
          '%32' { '2' }
          '%33' { '3' }
          '%34' { '4' }
          '%35' { '5' }
          '%36' { '6' }
          '%37' { '7' }
          '%38' { '8' }
          '%39' { '9' }
          '%3A' { ':' }
          '%3B' { ';' }
          '%3C' { '<' }
          '%3D' { '=' }
          '%3E' { '>' }
          '%3F' { '?' }
          '%40' { '@' }
          '%41' { 'A' }
          '%42' { 'B' }
          '%43' { 'C' }
          '%44' { 'D' }
          '%45' { 'E' }
          '%46' { 'F' }
          '%47' { 'G' }
          '%48' { 'H' }
          '%49' { 'I' }
          '%4A' { 'J' }
          '%4B' { 'K' }
          '%4C' { 'L' }
          '%4D' { 'M' }
          '%4E' { 'N' }
          '%4F' { 'O' }
          '%50' { 'P' }
          '%51' { 'Q' }
          '%52' { 'R' }
          '%53' { 'S' }
          '%54' { 'T' }
          '%55' { 'U' }
          '%56' { 'V' }
          '%57' { 'W' }
          '%58' { 'X' }
          '%59' { 'Y' }
          '%5A' { 'Z' }
          '%5B' { '[' }
          '%5C' { '\' }
          '%5D' { ']' }
          '%5E' { '^' }
          '%5F' { '_' }
          '%60' { '`' }
          '%61' { 'a' }
          '%62' { 'b' }
          '%63' { 'c' }
          '%64' { 'd' }
          '%65' { 'e' }
          '%66' { 'f' }
          '%67' { 'g' }
          '%68' { 'h' }
          '%69' { 'i' }
          '%6A' { 'j' }
          '%6B' { 'k' }
          '%6C' { 'l' }
          '%6D' { 'm' }
          '%6E' { 'n' }
          '%6F' { 'o' }
          '%70' { 'p' }
          '%71' { 'q' }
          '%72' { 'r' }
          '%73' { 's' }
          '%74' { 't' }
          '%75' { 'u' }
          '%76' { 'v' }
          '%77' { 'w' }
          '%78' { 'x' }
          '%79' { 'y' }
          '%7A' { 'z' }
          '%7B' { '{' }
          '%7C' { '|' }
          '%7D' { '}' }
          '%7E' { '~' }
          '%7F' { '' }
          '%80' { '`' }
        }

        $EndOfString = $String[($Index+3)..($String.Length)] -join ''

        $String = $BeginningOfString + $AsciiCharacter + $EndOfString
      }
      

      $IndexCheck = $String.IndexOf('%')
    }
  }
  
  end {
    Write-Output $String
  }
}






