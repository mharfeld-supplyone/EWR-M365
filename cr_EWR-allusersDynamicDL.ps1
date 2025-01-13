
$Filter = "((((Company -eq 'BELL') -and (RecipientTypeDetails -eq 'UserMailbox')))  -and (-not(Name -like 'EWR-{*'))  -and (-not(Title -eq 'SMTP Relay'))  -and (-not(RecipientTypeDetailsValue -eq 'MailboxPlan'))  -and (-not(RecipientTypeDetailsValue -eq 'DiscoveryMailbox'))  -and (-not(RecipientTypeDetailsValue -eq 'PublicFolderMailbox'))  -and (-not(RecipientTypeDetailsValue -eq 'ArbitrationMailbox'))  -and (-not(RecipientTypeDetailsValue -eq 'AuditLogMailbox'))  -and (-not(RecipientTypeDetailsValue -eq 'AuxAuditLogMailbox'))  -and (-not(RecipientTypeDetailsValue -eq 'SupervisoryReviewPolicyMailbox'))  -and (UserAccountControl -ne 'AccountDisabled') )"

New-DynamicDistributionGroup -Name "EWR ALL" -DisplayName "BELL All Employees" -Alias AllArchitects -PrimarySmtpAddress EWR-allusers@supplyone.com -RecipientFilter $Filter

$group = Get-DynamicDistributionGroup -Identity "GLF ALL"

Get-Recipient -RecipientPreviewFilter $group.RecipientFilter | Select-Object PrimarySmtpAddress

#manually set owner(s) attributes