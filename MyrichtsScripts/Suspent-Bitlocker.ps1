#change to 1 to auto re-enable
$reenable = 0
$mp = "c:"
Suspend-BitLocker -MountPoint $mp -RebootCount $reenable
write-host "Run Resume-BitLocker -MountPoint $mp after reboot!"