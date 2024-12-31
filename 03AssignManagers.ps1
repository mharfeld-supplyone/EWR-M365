#####################################################################################
#####################################################################################
##                                                                                 ##
##  Program           03AssingManagers.ps1                                         ##
##  Author            Jeff Canfield / Chris Johnston                               ##
##  CreateDt          20240901                                                     ##
##  Description       This program assigns the required manager attribute in       ##
##                    Entra to users that need a manager assigned 		           ##
##		              (most or all users will need this)                           ##
##  Usage                                                                          ##
##              NOTE: This needs to be run in Powershell Desktop Edition           ##
##                    1. Import-Module -Name AzureAD                               ##
##                    2. edit CSV location for variable $users                     ##
##                    3. verify log folder "C:\Temp" exists                        ##
##                    4. run .\03AssingManagers.ps1                                ##
##  Inputs            CSV specified in the below path with the following columns:  ##
##                         UserPrincipalName, ManagerUserPrincipalName             ##
##		              e.g. jsmith@supplyone.com, jdoe@supplyone.com                ##
##                                                                                 ##
##                                                                                 ##
#####################################################################################
#####################################################################################
#####################################################################################

# Import the Azure AD PowerShell module
Import-Module -Name AzureAD

#connect Azure AD - NOTE:  This script needs to be run in the Powershell Desktop Edition
Connect-AzureAD

# Import the CSV file
$users = Import-Csv -Path "C:\CSV\Prod\GLF\GLFmanagers2.csv"

# Set the log file path and name
$logFile = "C:\Temp\AddManager_$(Get-Date -Format yyyyMMdd_HHmmss).log"

# Loop through each row in the CSV file
foreach ($user in $users) {
    # Get the user object
    $userObject = Get-AzureADUser -Filter "UserPrincipalName eq '$($user.UserPrincipalName)'"

    # Get the manager object
    $managerObject = Get-AzureADUser -Filter "UserPrincipalName eq '$($user.ManagerUserPrincipalName)'"

    if ($userObject -and $managerObject) {
        # Assign the manager to the user
        Set-AzureADUserManager -ObjectId $userObject.ObjectId -RefObjectId $managerObject.ObjectId

        # Write output to the screen
        Write-Output "Updated manager for $($user.UserPrincipalName) to $($managerObject.UserPrincipalName)"

        # Log the update to the file
        "Updated manager for $($user.UserPrincipalName) to $($managerObject.UserPrincipalName) at $(Get-Date)" | Add-Content -Path $logFile
    } else {
        Write-Output "Error: Unable to find user or manager for $($user.UserPrincipalName)"
        "Error: Unable to find user or manager for $($user.UserPrincipalName) at $(Get-Date)" | Add-Content -Path $logFile
    }
}
