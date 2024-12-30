#Connect to Microsoft Graph
Connect-MgGraph -Scopes "AuditLog.Read.All","User.Read.All"
 
#Set the Graph Profile
# Select-MgProfile beta
 
#Properties to Retrieve
$Properties = @(
    'Id','DisplayName','Mail','UserPrincipalName','UserType', 'AccountEnabled', 'SignInActivity', 'companyName' 
)


     $AllUsers = Get-MgUser -All -Property $Properties #| Select-Object $Properties


$SigninLogs = @()

ForEach ($User in $AllUsers)
{
    $SigninLogs += [PSCustomObject][ordered]@{
            LoginName       = $User.UserPrincipalName
            Email           = $User.Mail
            DisplayName     = $User.DisplayName
            UserType        = $User.UserType
            AccountEnabled  = $User.AccountEnabled
            LastSignIn      = $User.SignInActivity.LastSignInDateTime
            Company         = $User.companyName
    }
}
 
& {
    & $SigninLogs
} 2> $null

 
#Export Data to CSV
$SigninLogs | Export-Csv -Path "C:\Temp\SigninLogs_SupplyOne_20241226.csv" -NoTypeInformation