#####################################################################################
#####################################################################################
##                                                                                 ##
##  Program           DisableSourceAccountloginNoPWDChange.ps1                     ##
##  Author            Marc Harfeld                                                 ##
##  CreateDt          20250225                                                     ##
##  Description       This program disables user accounts and revokes tokens 	   ##
##                    at the source tenant. It does not reset passwords            ##
##  Usage             1. Connect-MgGraph -Scopes "User.ReadWrite.All"              ##
##                    2. edit CSV location for variable $csvPath                   ##
##                    3. verify log folder "C:\Logs" exists                        ##
##                    4. run .\DisableSourceAccountloginNoPWDChange.ps1            ##
##  Inputs            CSV specified in the below path with the following columns:  ##
##                         UserPrincipalName 			                           ##
##                                                                                 ##
##                                                                                 ##
#####################################################################################
#####################################################################################
#####################################################################################


# Install the necessary modules (only needed if you haven't installed them before) 

#Install-Module -Name Microsoft.Graph 

#Install-Module -Name Microsoft.Graph.Users 

# Import the necessary modules 

Import-Module -Name Microsoft.Graph 

Import-Module -Name Microsoft.Graph.Users 

# Connect to Microsoft Graph 

Connect-MgGraph -Scopes "User.ReadWrite.All", "UserAuthenticationMethod.ReadWrite.All" 

# Define the path to your CSV file 

$csvPath = "C:\Data\EWRdisable.csv" 

# Import the CSV file and search for users 

$users = Import-Csv -Path $csvPath

foreach ($user in $users) {

     Write-Host "User: $user.UserPrincipalName " 
     $upn = Get-ADUser -identity $user.UserPrincipalName

    if ($upn.id) { 

       
        # Revoke the user's refresh tokens 

        Revoke-MgUserSignInSession -UserId $upn.Id 

        # Disable the user account 

        Update-MgUser -UserId $upn.Id -AccountEnabled:$false 

        Write-Host "User found and processed: $($upn.DisplayName)" 

    } else { 

        Write-Host "User not found: $user.UserPrincipalName" 

    } 

} 

 