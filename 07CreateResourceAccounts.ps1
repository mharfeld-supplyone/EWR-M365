#####################################################################################
#####################################################################################
##                                                                                 ##
##  Program           07CreateResourceAccounts.ps1                                 ##
##  Author            Jeff Canfield / Chris Johnston                               ##
##  CreateDt          20240901                                                     ##
##  Description       This program creates resource accounts in the Supply One     ##
##                    tenant. 					                        		   ##
##  Usage             1. Connect-ExchangeOnline       			                   ##
##                    2. edit CSV location for variable $rooms		               ##
##                    3. verify log folder "C:\Temp" exists     	        	   ##
##                    3. run .\07CreateResourceAccounts.ps1                        ##
##  Inputs            CSV specified in the below path with the following columns:  ##
##                    Name,Alias,DisplayName,PrimarySmtpAddress,	        	   ##
##	        	      Capacity,ResourceCapacity    			                       ##
##                                                                                 ##
##                                                                                 ##
##                                                                                 ##
#####################################################################################
#####################################################################################
#####################################################################################


# Set the log file path and name 

$logFile = "C:\temp\AddResourceRooms_$(Get-Date -Format yyyyMMdd_HHmmss).log" 

 

# Bypass script blocked: (Typically always needed) 

Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force 

 

# Exchange Online: 

# Modules: 

Install-Module ExchangeOnlineManagement 

Import-Module ExchangeOnlineManagement 

 

# Connect to Exchange Online 

Connect-ExchangeOnline 

 

# Import the CSV file 

$rooms = Import-Csv -Path "C:\NewEnglandCSV\Rooms.csv" 

 

# Loop through each row in the CSV file 

foreach ($room in $rooms) { 

    # Create the room mailbox 

    $newMailbox = New-Mailbox -Name $room.Name -Room -Alias $room.Alias -DisplayName $room.DisplayName -PrimarySmtpAddress $room.PrimarySmtpAddress

 

    # Log the creation of the room mailbox 

    $logMessage = "Created room mailbox: $($room.Name) with alias $($room.Alias) and primary SMTP address $($room.PrimarySmtpAddress)" 

    Write-Output $logMessage 

    $logMessage | Add-Content -Path $logFile 

} 