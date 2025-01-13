##########################################
##### must run in local powershell #######
##########################################

# Import the AzureAD module
Import-Module AzureAD

# Connect to Azure AD
Connect-AzureAD

# Import the CSV
$users = Import-Csv -Path "C:\CSV\Prod\EWR\BELLSetCompanyName.csv"

# Loop through each user and update the Company field
foreach ($user in $users) {
    try {
        # Update the user's Company field
        Set-AzureADUser -ObjectId $user.UserPrincipalName -CompanyName $user.Company
        Write-Host "Updated company for user: $($user.UserPrincipalName)" -ForegroundColor Green
    } catch {
        Write-Host "Failed to update user: $($user.UserPrincipalName). Error: $($_.Exception.Message)" -ForegroundColor Red
    }
}
