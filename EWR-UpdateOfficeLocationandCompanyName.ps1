# Connect to Microsoft Graph PowerShell
Connect-MgGraph -Scopes "User.ReadWrite.All"

# Import CSV file (Make sure to update the file path)
$users = Import-Csv "C:\CSV\Prod\EWR\BELLupdate.csv"

# Define the new values for Office Location and Company Name
$officeLocation = "BELL"
$companyName = "BELL"

# Loop through each user in the CSV and update their properties
foreach ($user in $users) {
    $upn = $user.UserPrincipalName

    try {
        # Update user attributes
        Update-MgUser -UserId $upn -OfficeLocation $officeLocation -CompanyName $companyName

        Write-Host "Updated: $upn | Office: $officeLocation | Company: $companyName" -ForegroundColor Green
    }
    catch {
        Write-Host "Failed to update: $upn | Error: $_" -ForegroundColor Red
    }
}

# Disconnect after completion
Disconnect-MgGraph
