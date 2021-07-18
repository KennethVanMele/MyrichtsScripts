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

    try{
        $file = "c:\temp.txt"
        $i = (Get-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment' -Name PATH).Path
        $i -Split ";" | Out-File $file | notepad.exe $file

        if($Backup){
            Copy-Item -Path $file -Destination "c:\temp.back"
            Write-host "Backup created"
        }

        do{Start-Sleep 2}while (Get-Process notepad -ErrorAction SilentlyContinue)

        $lines = Get-Content $file
        $newPath = ""
    }
    
    finally{
                foreach ($line in $lines){
            $newPath += $line + ";"
        }
        Write-Host $newPath
        Set-ItemProperty -Path "Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment" -Name PATH -Value $newPath -Confirm
        Remove-Item c:\temp.txt
    }
}