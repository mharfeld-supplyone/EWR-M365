#####################################################################################
#####################################################################################
##                                                                                 ##
##  Program           04Update Users.ps1                                           ##
##  Author            Jeff Canfield / Chris Johnston                               ##
##  CreateDt          20240901                                                     ##
##  Description       This program takes in a list of users in a CSV and updates   ##
##                    the following Acccount required attributes:                  ##
##                        DisplayName, GivenName, Surname, JobTitle, Department,   ##
##                        UsageLocation, OfficeLocation, CompanyName               ##
##  Usage             1. Connect-MgGraph -Scopes "User.ReadWrite.All"              ##
##                    2. edit CSV location for variable $users                     ##
##                    3. verify log folder "C:\Logs" exists                        ##
##                    4. run .\04UpdateUsers.ps1                                   ##
##  Inputs            CSV specified in the below path with the following columns:  ##
##                         UserPrincipalName, DisplayName, GivenName, Surname,     ##
##                         JobTitle, Department, UsageLocation OfficeLocation,     ##
##                         CompanyName                                             ##
##                                                                                 ##
##                                                                                 ##
#####################################################################################
#####################################################################################
#####################################################################################

# Bypass script blocked: (Typically always needed:)
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force

# Install Module
Install-Module -Name Microsoft.Graph

# Connect to the Microsoft Graph API with the required scopes
Connect-MgGraph -Scopes "User.ReadWrite.All"

# Import the CSV file
$users = Import-Csv -Path "C:\CSV\Sandbox\CCB\04corrected.csv"

# Set the log file path and name
$logFile = "C:\Logs\UpdateUsers_$(Get-Date -Format yyyyMMdd_HHmmss).log"

# Iterate over each user in the CSV file
foreach ($user in $users) {
    # Get the existing user object
    $existingUser = Get-MgUser -UserId $user.UserPrincipalName -ErrorAction SilentlyContinue

    if ($existingUser) {
        # Make sure $existingUser is not null before trying to update it
        if ($null -ne $existingUser) {
            # Update the user properties
            Update-MgUser -UserId $existingUser.Id -DisplayName $user.DisplayName -GivenName $user.GivenName -Surname $user.Surname -JobTitle $user.JobTitle -Department $user.Department -UsageLocation $user.UsageLocation -OfficeLocation $user.OfficeLocation -CompanyName $user.CompanyName

            # Write a message to the console indicating that the user was updated
            Write-Host "User updated: $($existingUser.UserPrincipalName)" -ForegroundColor Green

            # Log the update to the file
            "Updated user: $($existingUser.UserPrincipalName) at $(Get-Date)" | Add-Content -Path $logFile
        } else {
            Write-Host "Error: $existingUser is null" -ForegroundColor Red
        }
    } else {
        Write-Host "User not found: $($user.UserPrincipalName)" -ForegroundColor Yellow

        # Log the error to the file
        "User not found: $($user.UserPrincipalName) at $(Get-Date)" | Add-Content -Path $logFile
    }
}