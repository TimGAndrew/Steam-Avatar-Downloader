Write-Host "Steam avatar will be downloaded to the folder running SteamAvatarDownloader.ps1"

$Continue = $null

While (($Continue -ne "Y"))
{
    Write-Host "`r`nFor the following URL: 'https://steamcommunity.com/id/____', " -NoNewline

    $ProfileID = Read-Host "please enter the profile id to replace  ___"

    $ProfileUrl = "https://steamcommunity.com/id/$($ProfileID)"

    $Continue = Read-Host "Profile is at '$($ProfileUrl)'. Proceed? (Y/N/Q)"

    if ($Continue -eq "Q")
    {
        Write-Host "User quit.."
        exit
    }
}

Write-Host "Attempting to analyze profile data.." -NoNewline


try
{
    

    $ProfileData = Invoke-WebRequest -Uri $ProfileUrl -UseBasicParsing -ErrorAction Stop

    Write-Host "Analyzed it!"

    Write-Host "Attempting to find Avatar image in profile.." -NoNewline

    try
    {
        $ProfileImage = $ProfileData.Images | Where-Object {($_.src -like "*/avatars/*") -and ($_.src -like "*_full.*")} | Select-Object -First 1 -ErrorAction Stop

        Write-Host "Found it!"

        $OutFile = "$($ProfileId).jpg"

        Write-Host "Attempting to grab and save Avatar image.." -NoNewline

        Invoke-WebRequest $ProfileImage.src -OutFile $OutFile -ErrorAction Stop
                
        Write-Host "Image saved as '$($PSScriptRoot)\$($OutFile)'!!"

        Write-Host "All done!"
    }
    catch
    {
        Write-Host "Error:`r`n$($_)"
    }
}
catch
{
    Write-Host "Error:`r`n$($_)"
}