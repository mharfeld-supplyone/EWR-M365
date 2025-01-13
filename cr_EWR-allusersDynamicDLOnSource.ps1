
$Filter = "((Company -eq 'BELL') -and (UserAccountControl -ne 'AccountDisabled') )"

New-DynamicDistributionGroup -Name "BELL ALL" -DisplayName "BELL All Employees" -Alias AllArchitects -PrimarySmtpAddress EWR-allusers@BellContainer.com -RecipientFilter $Filter

$group = Get-DynamicDistributionGroup -Identity "BELL ALL"

Get-Recipient -RecipientPreviewFilter $group.RecipientFilter | Select-Object PrimarySmtpAddress

#manually set owner(s) attributes
