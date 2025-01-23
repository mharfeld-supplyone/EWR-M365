#Connect-ExchangeOnline -UserPrincipalName sharegate@supplyone.com

# Import the CSV file
$users = Import-Csv -Path "C:\CSV\Prod\EWR\HideFromGAL.csv"

# Iterate through each user and update the HiddenFromAddressListsEnabled property
foreach ($user in $users) {
    try {
        Set-Mailbox -Identity $user.UserPrincipalName -HiddenFromAddressListsEnabled $true
        Write-Host "Successfully updated visibility for $($user.UserPrincipalName)" -ForegroundColor Green
    } catch {
        Write-Host "Failed to update visibility for $($user.UserPrincipalName). Error: $($_.Exception.Message)" -ForegroundColor Red
    }
}
