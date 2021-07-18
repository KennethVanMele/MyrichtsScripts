﻿#Requires -RunAsAdministrator
function Set-Hypervisor {
    <#
    .SYNOPSIS
        Switch between Hypervisors.
    .DESCRIPTION
        Hyper-V doesn't play nice with other hypervisors like Oracles Virtual Box. This script lets you switch so you can use docker and Virtual Box side by side.
    .EXAMPLE
        PS C:\> Set-Hypervisor -HypervisorName "Other"
        Will set hypervisor to Virtual Box or any other hypervisor.
    .EXAMPLE
        PS C:\> Set-Hypervisor -Name "Hyper-V"
        Will set hypervisor to Hyper-V
    .PARAMETER HypervisorName
        Hypervisor to switch to.
    .PARAMETER HypervisorName
        Should pc reboot immediately?
    .NOTES
        Date latest change: 05/09/2019
    #>
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'High')]
    Param (
        [parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $false)]
        [ValidateSet('Other', 'Hyper-V')]
        [Alias('Name')]
        [string]$HypervisorName,

        [switch]$reboot
    )
	
	function Get-Reboot{
        param(
            [parameter(mandatory = $True)]
            [boolean]$reboot
        )

        if ($reboot) {
            Restart-Computer -Confirm
        }
        else {
            Write-Information "Reboot pending..."
        }
    }

    if ($PSCmdlet.ShouldProcess("$HypervisorName")){
        try{
            $status = (bcdedit | Out-String -stream | select-string "hypervisorlaunchtype")
            if ($hypervisorname = 'Other') {
                if ($status | Select-String "off") {
                    Write-Verbose "Already on Other"
                }
                else {
                    Write-Verbose "Setting hypervisor to Other"
                    bcdedit /set hypervisorlaunchtype off
                    Get-Reboot $reboot
                }
            }
            elseif ($hypervisorname = 'Hyper-V') {
                if ($status | Select-String "auto") {
                    Write-Verbose "Already on Hyper-V"
                }
                else {
                    Write-Verbose "Setting hypervisor to Hyper-V"
                    bcdedit /set hypervisorlaunchtype auto
                    Get-Reboot $reboot
                }
            }
        }catch{
            Write-Error "Can't set hypervisor to $HypervisorName."
        }
    }
}