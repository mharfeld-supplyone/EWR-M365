# Import the CSV file
Connect-ExchangeOnline

$Users = Import-Csv -Path "C:\Data\EWRdisable.csv"

# Loop through each user and disable protocols
foreach ($User in $Users) {
    $Email = $User.UserPrincipalName
    Write-Host "disabling protocols for $Email" -ForegroundColor Yellow

    Set-CASMailbox -Identity $Email -OWAEnabled $false
    Set-CASMailbox -Identity $Email -ActiveSyncEnabled $false
    Set-CASMailbox -Identity $Email -ImapEnabled $false
    Set-CASMailbox -Identity $Email -PopEnabled $false
    Set-CASMailbox -Identity $Email -MAPIEnabled $false
}

Write-Host "Protocols disabled for all users in CSV!" -ForegroundColor Green
