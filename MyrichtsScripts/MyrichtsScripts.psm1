function Start-FlushDNS {
    <#
    .SYNOPSIS
        Attempt to fix DNS issues.
    .DESCRIPTION
        I had a period where I experienced a lot of DNS issues on my laptop. This cmd script fixed it 9/10 times.
        I converted it to PowerShell to include in my Module. 
    .EXAMPLE
        PS C:\> Start-FlushDNS
    .NOTES
        Date latest change: 18/07/2021
    #>
    BEGIN {}
    PROCESS {
        Write-Host "StartiFlushDNS
        cmd.exe /c "ipconfig /StartdFlushDNS | Out-Null
        cmd.exe /c "ipconfig /registerdns" | Out-Null
        cmd.exe /c "ipconfig /release" | Out-Null
        Start-Sleep 5
        Write-Host "renewing"
        cmd.exe /c "ipconfig /renew" | Out-Null
        cmd.exe /c "netsh winsock reset" | Out-Null
        Write-Host "Press any key to continue..."
        $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyUp") | Out-Null
    }
    END {}
}

Export-ModuleMember -Function Start-FlushDNS

function Get-YouTubeMP3 {
    <#
    .SYNOPSIS
        Download a youtube video as an .mp3-file.
    .DESCRIPTION
        I always use the same setings in yt-dlp but tend to forget them.
    .NOTES
        Date latest change: 19/07/2012
        Requires yt-dlp to be installed.
    #>
    param (
        [String]    
        $URL
    )
    BEGIN {}
    PROCESS {
        $Folder = "C:\Users\kenneth\OneDrive\Music\"
        if ($URL -like "*list=*"){
        #I have a list of music, this isolates the video url.
        $sURL = $URL.Remove($URL.IndexOf('?'))
        }
        else{
            $sURL = $URL
        }
        #%(creator)s to add artists name if not in title.
        yt-dlp.exe $sURL --output "$Folder%(creator)s  %(title)s.%(ext)s" --extract-audio --audio-format mp3    
    }
    END {}
}
    
Export-ModuleMember Get-YouTubeMP3