## note - older script, quick simple, but not "all" but most HTML is stripped out.
## each category has an H4 HTML tag wrapped around it on output result/s.

$urls=gc "$env:USERPROFILE\addresses.txt"

foreach($url in $urls){
$web = Invoke-WebRequest https://www.fortiguard.com/webfilter?q=$url 
# Write to console with Write-Host next not log file output
Write-Host "$url"
$web.tostring() -split "[`r`n]" | select-string ">Category: "
Write-Host "------"
Start-Sleep -Seconds 3
}
