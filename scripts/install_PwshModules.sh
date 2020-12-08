#!/usr/local/bin/pwsh
#
# This script will install all required Powershell modules for the jupyter notebooks run
#
Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
Set-PowerCLIConfiguration -Scope User -ParticipateInCEIP $false -Confirm:$false
Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -DisplayDeprecationWarnings $false -Scope AllUsers -Confirm:$false

Install-Module -Name VMware.PowerCLI
Install-Module -Name ImportExcel
Install-Module -Name HPOneView.520 -RequiredVersion 5.20.2422.3962 -Scope AllUsers -Confirm:$false
Install-Module -Name HPEOneView.530 -RequiredVersion 5.30.2472.1534 -Scope AllUsers -Confirm:$false
Install-Module -Name HPEOneView.540 -RequiredVersion 5.40.2534.2926 -Scope AllUsers -Confirm:$false
Install-Module -Name HPEOneView.550 -RequiredVersion 5.50.2607.2724 -Scope AllUsers -Confirm:$false
