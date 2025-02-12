# Load the Excel data using PowerShell
$file = 'C:\path\to\Redirection_list.xls' # Update file path
$excel = New-Object -ComObject Excel.Application
$workbook = $excel.Workbooks.Open($file)
$sheet = $workbook.Sheets.Item(1)
$data = @()
$row = 2 # Assuming data starts from row 2 (adjust if needed)

while ($sheet.Cells.Item($row, 1).Value2) {
    $baseLink = $sheet.Cells.Item($row, 1).Value2
    $destnLink = $sheet.Cells.Item($row, 2).Value2
    $data += [PSCustomObject]@{
        'BaseLink'  = $baseLink
        'DestnLink' = $destnLink
    }
    $row++
}

$workbook.Close()
$excel.Quit()

# Function to extract domain and language
function Extract-DomainAndLanguage {
    param([string]$baseLink)
    $pattern = 'https?://([^/]+)(?:/([^/]+))?'

    if ($baseLink -match $pattern) {
        $domainName = $matches[1]
        $languageCode = if ($matches[2]) { $matches[2] } else { '/' }
        return $domainName, $languageCode
    } else {
        return $null, $null
    }
}

# Process data to extract domain and language
$processedData = @()
foreach ($item in $data) {
    $domain, $language = Extract-DomainAndLanguage -baseLink $item.BaseLink
    $processedData += [PSCustomObject]@{
        'DomainName' = $domain
        'Language'   = $language
        'Destination' = $item.DestnLink
    }
}

# Export data to Excel
$processedData | Export-Excel -Path 'C:\path\to\domain_language_info.xlsx' -AutoSize

# Generate rules
$rules = "<rules>`n"

foreach ($row in $processedData) {
    $languagePattern = if ($row.Language -eq '/') { '^/$' } else { "^$($row.Language)$" }

    $rule = "`t<rule name=`"lwell-rule-lang-$($row.Language)`" stopProcessing=`"true`">`n"
    $rule += "`t`t<match url=`".*`" />`n"
    $rule += "`t`t<conditions logicalGrouping=`"MatchAll`">`n"
    $rule += "`t`t`t<add input=`"{HTTP_HOST}`" pattern=`".*$($row.DomainName)$`" />`n"
    $rule += "`t`t`t<add input=`"{REQUEST_URI}`" pattern=`"$languagePattern`" />`n"
    $rule += "`t`t</conditions>`n"
    $rule += "`t`t<action type=`"Redirect`" url=`"$($row.Destination)`" redirectType=`"Permanent`" appendQueryString=`"false`" />`n"
    $rule += "`t</rule>`n"
    $rules += $rule
}

$rules += "</rules>"

# Print or save generated rules to a file
Write-Host $rules
$rules | Set-Content -Path 'C:\path\to\generated_rules_powershell.xml' -Encoding UTF8

Write-Host "XML rules saved to 'C:\path\to\generated_rules_powershell.xml'"
