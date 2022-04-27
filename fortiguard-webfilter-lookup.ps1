#$urls=gc "url-blacklist-scan.txt"
$urls=gc "$env:USERPROFILE\Documents\GitHub\web-filter-lookup\url-blacklist-scan.txt"

foreach($url in $urls){
$web = Invoke-WebRequest https://www.fortiguard.com/webfilter?q=$url 
# Write to console with Write-Host next not log file output
Write-Host "$url"
$web.tostring() -split "[`r`n]" | select-string ">Category: "
Write-Host "------"
Start-Sleep -Seconds 3
}