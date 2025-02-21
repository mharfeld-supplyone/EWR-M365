#####################################################################################
#####################################################################################
##                                                                                 ##
##  Program           25CreateEmailForwardsonSource.ps1                            ##
##  Author            Jeff Canfield / Chris Johnston                               ##
##  CreateDt          20240901                                                     ##
##  Description       This program enables email forwarding from the source tenant ##
##                    to the destination tenant. Typically enabled at the start    ##
##		              of migration weekend. (with anti-spam policy modifications   ##
##		              in the migration plan not listed here)                       ##
##  Usage             1. Connect-ExchangeOnline       			                   ##
##                    2. edit CSV location for variable $users                     ##
##                    3. verify log folder "C:\Logs" exists     		           ##
##                    4. run .\25CreateEmailForwardsonSource.ps1                   ##
##  Inputs            CSV specified in the below path with the following columns:  ##
##                    UserPrincipalName,ForwardingAddress   	        		   ##
##                    eg. johndoe@romanowcontainer.com,jdoe@supplyone.com          ##
##                                                                                 ##
##                                                                                 ##
#####################################################################################
#####################################################################################
#####################################################################################


# Bypass script blocked: (Typically always needed) 

Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force 

# Exchange Online: 

# Modules: 

#Install-Module ExchangeOnlineManagement 

Import-Module ExchangeOnlineManagement 

# Connect to Exchange Online 

Connect-ExchangeOnline -UserPrincipalName sharegate@bellcontainer.com

$logFile = "C:\Logs\SetMailboxForwarding_$(Get-Date -Format yyyyMMdd_HHmmss).log" 

# Import the CSV file 

$users = Import-Csv -Path "C:\CSV\Prod\EWR\EWRforwarding.csv"

# Loop through each user in the CSV file 

foreach ($user in $users) { 

    try { 

        # Get the mailbox for the current user 

        $mailbox = Get-Mailbox -Identity $user.UserPrincipalName 

        # Set the forwarding address and leave a copy on the mailbox 

        Set-Mailbox -Identity $mailbox.DistinguishedName -ForwardingSmtpAddress $user.ForwardingAddress -DeliverToMailboxAndForward $true 

        $logMessage = "Set forwarding address for $($user.UserPrincipalName) to $($user.ForwardingAddress)" 

        Write-Output $logMessage 

        $logMessage | Add-Content -Path $logFile 

    } 

    catch { 

        $logMessage = "Error setting forwarding address for $($user.UserPrincipalName): $($Error[0].Message)" 

        Write-Output $logMessage 

        $logMessage | Add-Content -Path $logFile 

    } 
}
