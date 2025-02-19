# Install and import required modules
if (-not (Get-Module -ListAvailable -Name Microsoft.Graph)) {
    Install-Module Microsoft.Graph -Scope CurrentUser -Force
}
Import-Module Microsoft.Graph

# Connect to Microsoft Graph (Requires admin consent)
Connect-MgGraph -Scopes "User.Read.All", "AuditLog.Read.All"

# Get all users in the tenant
$users = Get-MgUser -All -Property UserPrincipalName,CompanyName,StrongAuthenticationMethods

# Prepare output
$results = @()

foreach ($user in $users) {
    # Determine MFA status
    $mfaStatus = if ($user.StrongAuthenticationMethods.Count -gt 0) { "Enabled" } else { "Disabled" }

    # Get last login date (Sign-in logs)
    $signInLogs = Get-MgAuditLogSignIn -Filter "userPrincipalName eq '$($user.UserPrincipalName)'" -Top 1 -Sort "createdDateTime DESC"
    $lastSignIn = if ($signInLogs) { $signInLogs.CreatedDateTime } else { "No data" }

    # Create object with relevant details
    $results += [PSCustomObject]@{
        UPN       = $user.UserPrincipalName
        Company   = $user.CompanyName
        MFAStatus = $mfaStatus
        LastLogin = $lastSignIn
    }
}

# Display results in table format
$results | Format-Table -AutoSize

# Export results to CSV
$results | Export-Csv -Path "AzureAD_User_MFA_Status.csv" -NoTypeInformation

Write-Output "MFA status and last login report exported to AzureAD_User_MFA_Status.csv"

# Disconnect from Microsoft Graph
Disconnect-MgGraph

