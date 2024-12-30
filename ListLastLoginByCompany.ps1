# Uninstall-Module -Name AzureAD
# Install-Module -Name AzureADPreview -AllowClobber
# Import-Module AzureADPreview

# Connect-AzureAD
#Get-Command Get-AzureADAuditSignInLogs
#Get-AzureADAuditSignInLogs -All $true


<# 
.DESCRIPTION 
    This script retrieves all users from Azure AD where the company name is "Gulf" and their last login date.
    Author: Your Name
    Version: 1.1.0 
#>

# Connect to Azure AD
# Connect-AzureAD

# Get all users from Azure AD where company name is "Gulf"
$allUsers = Get-AzureADUser  -All $true | Where-Object { $_.CompanyName -eq "Gulf" }

# Create an empty array to store user data
$userData = @()

# Loop through each user and get their last login date
foreach ($user in $allUsers) {
    $signInActivity = Get-AzureADAuditSignInLogs -Top 1 -Filter "userPrincipalName eq '$($user.UserPrincipalName)'" | Sort-Object -Property CreatedDateTime -Descending
    $lastLoginDate = if ($signInActivity) { $signInActivity.CreatedDateTime } else { "Never Logged in" }

    # Add user data to the array
    $userData += [PSCustomObject]@{
        UserPrincipalName = $user.UserPrincipalName
        DisplayName       = $user.DisplayName
        LastLoginDate     = $lastLoginDate
    }
}

# Export user data to CSV
$userData | Export-Csv -Path "C:\Temp\GulfUsersLastLoginInfo.csv" -NoTypeInformation