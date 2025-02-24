# Import the CSV file
Connect-ExchangeOnline

$Users = Import-Csv -Path "C:\CSV\Prod\EWR\EWRdisableprotocols.csv"

# Loop through each user and disable protocols
foreach ($User in $Users) {
    $Email = $User.EmailAddress
    Write-Host "enabling protocols for $Email" -ForegroundColor Yellow

    Set-CASMailbox -Identity $Email -OWAEnabled $true
    Set-CASMailbox -Identity $Email -ActiveSyncEnabled $true
    Set-CASMailbox -Identity $Email -ImapEnabled $true
    Set-CASMailbox -Identity $Email -PopEnabled $true
    Set-CASMailbox -Identity $Email -MAPIEnabled $true
}

Write-Host "Protocols enabled for all users in CSV!" -ForegroundColor Green
