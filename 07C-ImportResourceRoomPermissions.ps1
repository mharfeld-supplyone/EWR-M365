#####################################################################################
#####################################################################################
##                                                                                 ##
##  Program           07C-ImportResourceRoomPermissions.ps1                        ##
##  Author            Jeff Canfield / Chris Johnston                               ##
##  CreateDt          20240901                                                     ##
##  Description       This program adds delegate permissions to the                ##
##		              target tenant Resource Room and Equipment 		           ##
##		              Mailboxes (SupplyOne) 					                   ##
##  Usage             1. Connect-ExchangeOnline       			                   ##
##                    2. verify Log folder "C:\Temp" exists 		        	   ##
##		              3. Edit "C:\Temp\ResourceRoomPermissions.csv" created        ##
##		              with scripts 07A and 07B to reflect SupplyOne 	  	       ##
##		              names and users        				                       ##
##                    4. run .\07C-ImportResourceRoomPermissions.ps1               ##
##  Output            Delegate Permissions added to target Resource mailboxes      ##
##                                                                                 ##
##                                                                                 ##
##                                                                                 ##
#####################################################################################
#####################################################################################
#####################################################################################


# Bypass script blocked: (Typically always needed) 

Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force 

 

# Exchange Online: 

# Modules: 

Install-Module ExchangeOnlineManagement 

Import-Module ExchangeOnlineManagement 

 

# Connect to Exchange Online 

Connect-ExchangeOnline 

 

$logFile = "C:\temp\ImportResourceRoomPermissions_$(Get-Date -Format yyyyMMdd_HHmmss).log" 

$importFile = "C:\temp\ResourceRoomPermissions.csv" 

 

$permissions = Import-Csv -Path $importFile 

 

foreach ($permission in $permissions) { 

    $mailbox = Get-Mailbox -Identity $permission.MailboxAlias 

    if ($mailbox) { 

        switch ($permission.PermissionType) { 

            "SendAs" { 

                Add-RecipientPermission -Identity $mailbox.Identity -Trustee $permission.User -AccessRights SendAs -Confirm:$false 

                $logMessage = "Added SendAs permission for $($permission.User) on $($mailbox.Name)" 

            } 

            "SendOnBehalf" { 

                Add-RecipientPermission -Identity $mailbox.Identity -Trustee $permission.User -AccessRights SendOnBehalf -Confirm:$false 

                $logMessage = "Added SendOnBehalf permission for $($permission.User) on $($mailbox.Name)" 

            } 

            "FullAccess" { 

                Add-MailboxPermission -Identity $mailbox.Identity -User $permission.User -AccessRights FullAccess -InheritanceType All -Confirm:$false 

                $logMessage = "Added FullAccess permission for $($permission.User) on $($mailbox.Name)" 

            } 

        } 

        Write-Output $logMessage 

        $logMessage | Add-Content -Path $logFile 

    } else { 

        $logMessage = "Mailbox $($permission.MailboxAlias) not found." 

        Write-Output $logMessage 

        $logMessage | Add-Content -Path $logFile 

    } 

} 