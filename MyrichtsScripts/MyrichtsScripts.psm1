function Add-Path {
    <#
    .SYNOPSIS
        Add folder to $env:path
    .DESCRIPTION
        This function provides an easy way to permanently add a folder to the $env:path environment variable.
    .EXAMPLE
        PS C:\> Add-Path -FolderName "c:\test"
        This will add the c:\test folder to $env:path.
    .PARAMETER FolderName
        Folder you want to add.
    .NOTES
        Date latest change: 18/07/2021
    #>
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'Low')]
    Param (
        [parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true)]
        [Alias('Path')]
        [string]$FolderName
    )
    BEGIN {}
    PROCESS {
        if ($PSCmdlet.ShouldProcess("$FolderName")) {
            if (Test-Path -Path $FolderName -PathType Container) {
                $oldPath = (Get-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment' -Name PATH).Path
                Write-Verbose $oldPath
                $newPath = $oldPath + ';' + $FolderName
                Write-Verbose $newPath
                Set-ItemProperty -Path "Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment" -Name PATH -Value $newPath
            }
            else {
                write-error "Folder does not exist." -ErrorAction Stop
            }
        }
    }
    END {}
}

Export-ModuleMember -Function Add-Path

function Edit-Path {
    <#
    .SYNOPSIS
        Edit $env:path
    .DESCRIPTION
        This function provides an easy way to edit the $env:path environment variable by making it editable in notepad.
    .EXAMPLE
        PS C:\> Remove-Path
        This will open your $env:path variable in a list in notepad. Remove any line you want, save and close notepad.
    .PARAMETER Backup
        Create a backup in c:\temp.back.
    .NOTES
        Date latest change: 05/09/2019
    #>
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'High')]
    Param (
        [Switch] $Backup
    )
    BEGIN {}
    PROCESS {
        try {
            $file = "c:\temp.txt"
            $i = (Get-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment' -Name PATH).Path
            $i -Split ";" | Out-File $file | notepad.exe $file
    
            if ($Backup) {
                Copy-Item -Path $file -Destination "c:\temp.back"
                Write-host "Backup created"
            }
    
            do { Start-Sleep 2 }while (Get-Process notepad -ErrorAction SilentlyContinue)
    
            $lines = Get-Content $file
            $newPath = ""
        }
        
        finally {
            foreach ($line in $lines) {
                $newPath += $line + ";"
            }
    
            Write-Host $newPath
            Set-ItemProperty -Path "Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment" -Name PATH -Value $newPath -Confirm
            Remove-Item c:\temp.txt
        }
    }
    END {}
}

Export-ModuleMember -Function Edit-Path

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
        I always use the same setings in youtube-dl but tend to forget them.
    .NOTES
        Date latest change: 19/07/2012
        Required youtube-dl to be installed.
    #>
    param (
        [String]    
        $URL
    )
    BEGIN {}
    PROCESS {
        $Folder = "D:\Muziek\"
        #I have a list of music, this isolates the video url.
        $sURL = $URL.Remove($URL.IndexOf('?'))
        #%(creator)s to add artists name if not in title.
        youtube-dl.exe $sURL --output "$Folder%(creator)s  %(title)s.%(ext)s" --extract-audio --audio-format mp3    
    }
    END {}
}
    
Export-ModuleMember Get-YouTubeMP3