#Script to add email addressees to block in bulk to the TenantAllowBlockList
#CSV should contain one column with a header of 'EmailAddress' with email addresses to block

Connect-ExchangeOnline -UserPrincipalName adm-jcanfield@supplyonesandbox.onmicrosoft.com

$Emails = Import-Csv "C:\CSV\Sandbox\blocklist.csv"

foreach ($Email in $Emails.EmailAddress) {
    New-TenantAllowBlockListItems -ListType Sender -Block -Entries $Email -Notes "block address bulk test"
}

#Verify the Block/Allow List by running the script below:

#Get-TenantAllowBlockListItems -ListType Sender

