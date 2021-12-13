$urls=gc "url-blacklist-scan.txt"
foreach($url in $urls){
$web = Invoke-WebRequest $url 
Write-Host "$url"
$web.tostring() -split "[`r`n]" | select-string ">Category: "
Write-Host "------"
Start-Sleep -Seconds 3
}