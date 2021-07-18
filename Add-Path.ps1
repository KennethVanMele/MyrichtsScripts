function Add-Path {
    <#
    .SYNOPSIS
        Add folder to $env:path
    .DESCRIPTION
        This function provides an easy way to permanently add a folder to the $env:path environment variable.
    .EXAMPLE
        PS C:\> Add-Path -PathName "c:\test"
        This will add the c:\test folder to $env:path.
    .PARAMETER PathName
        Path you want to add.
    .NOTES
        Date latest change: 11/02/2019
    #>
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'Low')]
    Param (
        [parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true)]
        [Alias('Path')]
        [string]$PathName
    )

    if ($PSCmdlet.ShouldProcess("$PathName")){
        if (Test-Path -Path $PathName -PathType Container) {
            $oldPath = (Get-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment' -Name PATH).Path
            Write-Verbose $oldPath
            $newPath = $oldPath + ';' + $PathName
            Write-Verbose $newPath
            Set-ItemProperty -Path "Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment" -Name PATH -Value $newPath
        }
        else {
            write-error "Folder does not exist." -ErrorAction Stop
        }
    }
}