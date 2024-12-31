#####################################################################################
#####################################################################################
##                                                                                 ##
##  Program           07B-ExportResourceEquipmentPermissions.ps1                   ##
##  Author            Jeff Canfield / Chris Johnston                               ##
##  CreateDt          20240901                                                     ##
##  Description       This program exports a CSV with Equipment mailbox  	       ##
##		              permissions on the source tenant     			               ##
##  Usage             1. Connect-ExchangeOnline       			                   ##
##                    2. verify Log folder "C:\Temp" exists 		               ##
##                    3. run .\07B-ExportResourceEquipmentPermissions.ps1          ##
##  Output            CSV exported to 					                    	   ##
##		              C:\temp\ResourceRoomPermissions.csv	        	           ##
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

 

$logFile = "C:\temp\ExportResourceRoomPermissions_$(Get-Date -Format yyyyMMdd_HHmmss).log" 

$resourceRooms = Get-Mailbox -RecipientTypeDetails EquipmentMailbox 

$exportFile = "C:\temp\ResourceRoomPermissions.csv" 

 

$permissions = @() 

 

foreach ($mailbox in $resourceRooms) { 

    $sendAsPermissions = Get-RecipientPermission -Identity $mailbox.Identity -AccessRights SendAs 

    foreach ($permission in $sendAsPermissions) { 

        $permissions += [PSCustomObject]@{ 

            MailboxName = $mailbox.Name 

            MailboxAlias = $mailbox.Alias 

            PermissionType = "SendAs" 

            User = $permission.User 

        } 

    } 

 

    $sendOnBehalfPermissions = $mailbox.GrantSendOnBehalfTo 

    foreach ($permission in $sendOnBehalfPermissions) { 

        $permissions += [PSCustomObject]@{ 

            MailboxName = $mailbox.Name 

            MailboxAlias = $mailbox.Alias 

            PermissionType = "SendOnBehalf" 

            User = $permission.Name 

        } 

    } 

 

    $fullAccessPermissions = Get-MailboxPermission -Identity $mailbox.Identity | Where-Object {$_.AccessRights -eq "FullAccess"} 

    foreach ($permission in $fullAccessPermissions) { 

        $permissions += [PSCustomObject]@{ 

            MailboxName = $mailbox.Name 

            MailboxAlias = $mailbox.Alias 

            PermissionType = "FullAccess" 

            User = $permission.User 

        } 

    } 

} 

 

$permissions | Export-Csv -Path $exportFile -NoTypeInformation 

 

$logMessage = "Exported permissions for Resource Rooms to $exportFile" 

Write-Output $logMessage 

$logMessage | Add-Content -Path $logFile 