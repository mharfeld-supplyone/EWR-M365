# Get the Dynamic Distribution List's recipient filter
$ddl = Get-DynamicDistributionGroup -Identity "EWR ALL"

# Use the filter to get matching recipients
Get-Recipient -RecipientPreviewFilter $ddl.RecipientFilter | Select -ExpandProperty PrimarySmtpAddress
