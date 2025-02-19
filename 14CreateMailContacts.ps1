#####################################################################################
#####################################################################################
##                                                                                 ##
##  Program           14CreateMailContacts.ps1                                     ##
##  Author            Jeff Canfield / Chris Johnston                               ##
##  CreateDt          20240901                                                     ##
##  Description       This program creates mail contacts in the Supply One         ##
##                    tenant. 		                        					   ##
##  Usage             1. Connect-ExchangeOnline       		        	           ##
##                    2. edit CSV location for variable $contacts                  ##
##                    3. verify log folder "C:\Temp" exists              		   ##
##                    4. run .\14CreateMailContacts.ps1                            ##
##  Inputs            CSV specified in the below path with the following columns:  ##
##                    Name,DisplayName,ExternalEmailAddress,FirstName,LastName     ##
##                                                                                 ##
##                                                                                 ##
##                                                                                 ##
#####################################################################################
#####################################################################################
#####################################################################################


# Bypass script blocked: (Typically always needed) 

Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force 

 #test

# Exchange Online: 

# Modules: (remove the hash on next line if you do not have this module already installed)

#Install-Module ExchangeOnlineManagement 


Import-Module ExchangeOnlineManagement 

 

# Connect to Exchange Online 

Connect-ExchangeOnline 

 

$logFile = "C:\temp\ImportMailContacts_$(Get-Date -Format yyyyMMdd_HHmmss).log" 

 

# Import the CSV file 

$contacts = Import-Csv -Path "C:\CSV\Prod\EWR\BellMailContacts.csv" 

 

# Loop through each row in the CSV file 

foreach ($contact in $contacts) { 

    try { 

        # Create the mail contact 

        New-MailContact -Name $contact.Name -DisplayName $contact.DisplayName -ExternalEmailAddress $contact.ExternalEmailAddress -FirstName $contact.FirstName -LastName $contact.LastName 

        $logMessage = "Created mail contact for $($contact.Name)" 

        Write-Output $logMessage 

        $logMessage | Add-Content -Path $logFile 

    } 

    catch { 

        $logMessage = "Error creating mail contact for $($contact.Name): $($Error[0].Message)" 

        Write-Output $logMessage 

        $logMessage | Add-Content -Path $logFile 

    } 

} 
