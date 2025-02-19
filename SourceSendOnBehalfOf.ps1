# Connect to Exchange Online
Connect-ExchangeOnline -UserPrincipalName sharegate@bellcontainer.com

# Get all mailboxes
$Mailboxes = Get-Mailbox -ResultSize Unlimited

# Create an empty array to store results
$SendOnBehalfPermissions = @()

# Loop through each mailbox and check Send On Behalf permissions
foreach ($Mailbox in $Mailboxes) {
    $Permissions = Get-Mailbox -Identity $Mailbox.PrimarySmtpAddress | Select-Object -ExpandProperty GrantSendOnBehalfTo

    if ($Permissions) {
        foreach ($Delegate in $Permissions) {
            $SendOnBehalfPermissions += [PSCustomObject]@{
                Mailbox            = $Mailbox.PrimarySmtpAddress
                Delegate           = $Delegate
            }
        }
    }
}

# Export results to CSV
$SendOnBehalfPermissions | Export-Csv -Path "C:\Temp\SendOnBehalfPermissions.csv" -NoTypeInformation

Write-Host "Export completed! File saved to C:\Temp\SendOnBehalfPermissions.csv" -ForegroundColor Green

# Disconnect session
Disconnect-ExchangeOnline -Confirm:$false
