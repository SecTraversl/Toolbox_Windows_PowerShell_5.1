
<#
Here we are leveraging pieces of code from "Get-HtmlTableFromWebRequest.ps1" to parse the CIRCL.LU MISP threat intel table on github

We wanted a way to do something of a for loop over this table, so that we can access the *.json files that are posted here

#>

$url = 'https://www.circl.lu/doc/misp/feed-osint/'

$tables = @($req.ParsedHtml.getElementsByTagName("TABLE"))

# $tables | measure
# $tables[0]
$table = $tables[0]

$rows = @($table.Rows)

## Go through all of the rows in the table
$myResults = foreach ($row in $rows) {

  $cells = @($row.Cells)   

  ## If we've found a table header, remember its titles
  if ($cells[0].tagName -eq "TH") {

    $TableHeaders = @($cells | % { ("" + $_.InnerText).Trim() })
    continue
  }

  ## If we haven't found any table headers, make up names "P1", "P2", etc.
  if (-not $TableHeaders) {

    $TableHeaders = @(1..($cells.Count + 2) | % { "P$_" })

  }

  ## Now go through the cells in the the row. For each, try to find the
  ## title that represents that column and create a hashtable mapping those
  ## titles to content

  $resultObject = [Ordered] @{}

  for ($counter = 0; $counter -lt $cells.Count; $counter++) {

    $title = $TableHeaders[$counter]
    if (-not $title) { continue }  
    $resultObject[$title] = ("" + $cells[$counter].InnerText).Trim()

    # 2021-02-10 - TL - I added this in order to get the Hyperlink as a property
    if ($cells[$counter].firstChild.tagName -eq 'a') {
      $resultObject['AnchorText'] = $cells[$counter].firstChild.innerText
      $resultObject['Hyperlink'] = $cells[$counter].firstChild.href
    }
  }

  ## And finally cast that hashtable to a PSCustomObject
  [PSCustomObject] $resultObject
}

Write-Output $myResults


<#
♦ Temp> $myResults | measure
Count    : 1420


♠ Temp> $myResults | select -f 10 | ft

P1 P2                                        AnchorText                                Hyperlink                                       P3               P4   P5
-- --                                        ----------                                ---------                                       --               --   --
   Parent Directory                          Parent Directory                          about:/doc/misp/                                                 -
   0b988513-9535-42f0-9ebc-5d6aec2e1c79.json 0b988513-9535-42f0-9ebc-5d6aec2e1c79.json about:0b988513-9535-42f0-9ebc-5d6aec2e1c79.json 2021-08-14 23:50 128K
   0f5d36d5-9eda-429f-8c72-bdfaa7b6a750.json 0f5d36d5-9eda-429f-8c72-bdfaa7b6a750.json about:0f5d36d5-9eda-429f-8c72-bdfaa7b6a750.json 2021-08-14 23:51 444K
   0fadc113-6e22-4524-96b1-7b8fc98fa64c.json 0fadc113-6e22-4524-96b1-7b8fc98fa64c.json about:0fadc113-6e22-4524-96b1-7b8fc98fa64c.json 2021-08-14 23:50 9.0K
   01e8868d-48ae-41aa-8516-ea5a303758b8.json 01e8868d-48ae-41aa-8516-ea5a303758b8.json about:01e8868d-48ae-41aa-8516-ea5a303758b8.json 2021-08-14 23:51 1.6M
   0165e5d7-51e6-4c2e-a382-1dd1e706f7bb.json 0165e5d7-51e6-4c2e-a382-1dd1e706f7bb.json about:0165e5d7-51e6-4c2e-a382-1dd1e706f7bb.json 2021-08-14 23:50 30K
   0733f160-8e52-4548-a4c8-19a1cfb41d0d.json 0733f160-8e52-4548-a4c8-19a1cfb41d0d.json about:0733f160-8e52-4548-a4c8-19a1cfb41d0d.json 2021-08-14 23:50 5.5K
   1c4e9e86-eff3-485f-aa1d-1bff68101b14.json 1c4e9e86-eff3-485f-aa1d-1bff68101b14.json about:1c4e9e86-eff3-485f-aa1d-1bff68101b14.json 2021-08-14 23:50 36K
   1edd5ee1-7c91-4233-840a-6c419d6afc62.json 1edd5ee1-7c91-4233-840a-6c419d6afc62.json about:1edd5ee1-7c91-4233-840a-6c419d6afc62.json 2021-08-14 23:50 58K
   2e29b34e-9558-46ba-96b2-211295ece344.json 2e29b34e-9558-46ba-96b2-211295ece344.json about:2e29b34e-9558-46ba-96b2-211295ece344.json 2021-08-14 23:50 294K

#

♥ Temp> $myResults[1]
P1         :
P2         : 0b988513-9535-42f0-9ebc-5d6aec2e1c79.json
AnchorText : 0b988513-9535-42f0-9ebc-5d6aec2e1c79.json
Hyperlink  : about:0b988513-9535-42f0-9ebc-5d6aec2e1c79.json
P3         : 2021-08-14 23:50
P4         : 128K
P5         :



#>