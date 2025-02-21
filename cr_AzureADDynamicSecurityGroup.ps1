# Connect to Microsoft Graph PowerShell
Connect-MgGraph -Scopes "Group.ReadWrite.All"

# Define the dynamic membership rule
$Rule = "(companyName -eq 'BELL') -and " + 
        "(-not(startsWith(userPrincipalName, 'EWR-'))) -and " +
        "(accountEnabled -eq true)"

# Create the Azure AD Dynamic Security Group
$GroupParams = @{
    DisplayName = "EWR-ALLSecurityTraining"
    MailNickname = "EWR-ALLSecurityTraining"
    SecurityEnabled = $true   # Security group
    MailEnabled = $false      # Not a Microsoft 365 (mail-enabled) group
    GroupTypes = @("DynamicMembership")
    MembershipRule = $Rule
    MembershipRuleProcessingState = "On"
}

New-MgGroup @GroupParams
# (user.companyName -eq "BELL") and (user.userPrincipalName -notStartsWith "EWR-") and (user.accountEnabled -eq true)
#(user.companyName -eq "Gulf") and (user.userPrincipalName -notStartsWith "GLF-") and (user.accountEnabled -eq true)
#(user.companyName -eq "Crownhill Packaging") and (user.userPrincipalName -notStartsWith "CAN-") and (user.accountEnabled -eq true) and (user.userPrincipalName -notStartsWith "TPC-")
#(user.companyName -eq "CCB") and (user.userPrincipalName -notStartsWith "NWR-") and (user.accountEnabled -eq true)
#(user.companyName -eq "Romanow") and (user.userPrincipalName -notStartsWith "NEN-") and (user.accountEnabled -eq true)
Write-Output "Azure AD Dynamic Security Group 'EWR-ALLSecurityTraining' created successfully."

# Retrieve the Group ID
$GroupId = $NewGroup.Id

# Wait briefly to ensure group membership updates
Start-Sleep -Seconds 20

# List all members of the newly created group
Write-Output "Listing all members of the newly created dynamic security group 'EWR-ALLSecurityTraining':"
Get-MgGroupMember -GroupId $GroupId | Select-Object Id, DisplayName, UserPrincipalName


