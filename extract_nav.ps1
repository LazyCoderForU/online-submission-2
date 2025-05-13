# PowerShell script to extract Scheme Name and Asset Value from AMFI NAVAll.txt and save as TSV

$sourceUrl = "https://www.amfiindia.com/spages/NAVAll.txt"
$outputFile = "nav_data.tsv"

# Download the file
Invoke-WebRequest -Uri $sourceUrl -OutFile "NAVAll.txt"

# Read the file, skip header lines, and extract columns
Get-Content "NAVAll.txt" |
    Where-Object { $_ -match '^[0-9]{6};' } | # Only lines starting with 6 digits and semicolon
    ForEach-Object {
        $fields = $_ -split ';'
        if ($fields.Length -ge 6) {
            # Scheme Name is 4th column, Asset Value is 6th column
            "$($fields[3])`t$($fields[5])"
        }
    } | Set-Content $outputFile

Write-Host "Extracted data saved to $outputFile"
