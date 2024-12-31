#####################################################################################
#####################################################################################
##                                                                                 ##
##  Program           06CreateSharedMailboxes.ps1                                  ##
##  Author            Jeff Canfield / Chris Johnston                               ##
##  CreateDt          20240901                                                     ##
##  Description       This program creates shared mailboxes in the Supply One      ##
##                    tenant. 							                           ##
##  Usage             1. Connect-ExchangeOnline       			                   ##
##                    2. edit CSV location for variable $sharedMailboxes           ##
##                    3. verify Temp folder "C:\Temp" exists     		           ##
##                    3. run .\06CreateSharedMailboxes.ps1                         ##
##  Inputs            CSV specified in the below path with the following columns:  ##
##                         Name, Alias, displayName, PrimarySmtpAddress            ##
##                                                                                 ##
##                                                                                 ##
##                                                                                 ##
#####################################################################################
#####################################################################################
#####################################################################################


# Set the log file path and name 

$logFile = "C:\temp\AddSharedMailboxes_$(Get-Date -Format yyyyMMdd_HHmmss).log" 

 

# Bypass script blocked: (Typically always needed) 

Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force 

 

# Exchange Online: 

# Modules: 

Install-Module ExchangeOnlineManagement 

Import-Module ExchangeOnlineManagement 

 

# Connect to Exchange Online 

Connect-ExchangeOnline 

 

# Import the CSV file 

$sharedMailboxes = Import-Csv -Path "C:\CSV\Sandbox\CCB\SharedMailboxes.csv" 

 

# Loop through each row in the CSV file 

foreach ($sharedMailbox in $sharedMailboxes) { 

    # Create the shared mailbox 

    $newMailbox = New-Mailbox -Name $sharedMailbox.Name -Shared -Alias $sharedMailbox.Alias -DisplayName $sharedMailbox.DisplayName -PrimarySmtpAddress $sharedMailbox.PrimarySmtpAddress 

 

    # Log the creation of the shared mailbox 

    $logMessage = "Created shared mailbox: $($sharedMailbox.Name) with alias $($sharedMailbox.Alias) and primary SMTP address $($sharedMailbox.PrimarySmtpAddress)" 

    Write-Output $logMessage 

    $logMessage | Add-Content -Path $logFile 

} 

 

 