## Created by SystemJargon
## https://github.com/SystemJargon
## Created as Fortinet do not have a bulk URL scan utility nor any friendly API which exists for their webfilter.

## What this script does / things to understand?

## In your C:\users\username folder, you will have a folder called FortiWebFilter-BulkScan\ created.
## Also you will have a text file called addresses.txt created in this new folder above.
## Open addresses.txt. Place domains/urls - 1 per line to scan via Fortinet's webfilter.
## The script will in console (in the ps window) and via output file save any results. The output file is "webfilter-output.txt"


# Full path of the file
$file = "$env:USERPROFILE\FortiWebFilter-BulkScan\addresses.txt"

#Full path to the archiving folder
$WorkingDir = "$env:USERPROFILE\FortiWebFilter-BulkScan"

# If the file exists, do nothing, else create it.
if (Get-Item -Path $file -ErrorAction Ignore) {
    try {
        ## If the Working directory does not exist, create it now.
        if (-not(Test-Path -Path $WorkingDir -PathType Container)) {
            $null = New-Item -ItemType Directory -Path $WorkingDir -ErrorAction STOP
        }
        ## Other actions we can place here if needed in the future

     } catch {
        throw $_.Exception.Message
     }
 }
 
 #If the file does not exist, create it.
if (-not(Test-Path -Path $file -PathType Leaf)) {
     try {
         $null = New-Item -ItemType File -Path $file -Force -ErrorAction Stop
         Write-Host "The file [$file] has been created."
         Write-Host "Place the URLs or domains you wish to scan in addresses.txt in '$WorkingDir'"
     }
     catch {
         throw $_.Exception.Message
     }
 }
# If the file already exists, show the message and do nothing.
 else {
     Write-Host "Cannot create [$file] because a file with that name already exists."
 }


# start actions

cd "$WorkingDir"

# Wait for confirmation to run script and that addresses has content
# addresses should contain a url or domain per line we want to scan Fortiguard webfilter with in bulk


pause

# input of urls or domains
$urls=gc "addresses.txt"

# output files
$wfout1 = "webfilter-output-raw.txt"
$wfout2 = "webfilter-output.txt"

# clean-up results at start from last run
rm $wfout2
rm $wfout1

New-Item -ItemType File -Path $wfout1 -Force -ErrorAction Stop
New-Item -ItemType File -Path $wfout2 -Force -ErrorAction Stop

Clear-Host

Write-Host "Begining webfilter category scan from addresses.txt"
#Write-Host "This may take some time depending on how many url or domains are to be scanned"

foreach($url in $urls) {
$web = Invoke-WebRequest https://www.fortiguard.com/webfilter?q=$url 
# Write Output
Add-Content -Value "$url" -Path $wfout1 
$stringup = $web.tostring() -split "[`r`n]" | select-string ">Category: "
Add-Content -Value $stringup -Path $wfout1 
Add-Content -Value ------  -Path $wfout1 

Start-Sleep -Seconds 3
}

# get rid of the HTML tags from output
get-content $wfout1 | % {$_ -replace "\<.*?\>",""} | Out-File $wfout2

# remove our sort of temp file
rm $wfout1

Write-Host "#################################################"
Write-Host "Completed. Output written to '$wfout2'"
Write-Host "#################################################"
Write-Host "Results are also below"
Write-Host ""
Get-Content $wfout2

#EOF
