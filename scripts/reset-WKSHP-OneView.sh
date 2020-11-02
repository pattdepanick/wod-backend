#!/usr/bin/pwsh
#
# script to reset OneView backend
#Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -Confirm:$false
$servername = {{ VCENTERAPP }}
$username = {{ VCENTERADMIN }}
$password = {{ VCENTERPWD }}
#Reverting HPE OneView Simulator 1 VM
#Set Vm name as variable
$vmsimu1 = {{ OVVMSIMU1 }}
#Reverting HPE OneView Simulator 2 VM
#Set Vm name as variable
$vmsimu2 = {{ OVVMSIMU2 }}
#-------------------------------------------------------------
#Connect to Vcenter appliance :
connect-viserver $servername -username $username -password $password
#Get snapshot name from VMs
$snap1 = Get-Snapshot -VM $vmsimu1
#Revert to snapshot
#Reverting snap $snap1"
Set-VM -VM $vmsimu1 -SnapShot $snap1 -Confirm:$false
#Get snapshot name from VMs
$snap2 = Get-Snapshot -VM $vmsimu2
#Revert to snapshot
#Reverting snap $snap2"
Set-VM -VM $vmsimu2 -SnapShot $snap2 -Confirm:$false
exit