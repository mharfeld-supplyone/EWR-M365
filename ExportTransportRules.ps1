#Connect-ExchangeOnline -UserPrincipalName sharegate@bellcontainer.com

#Get-TransportRule | Select-Object Name, Priority, Enabled, Comments, Conditions, Actions, Mode | Export-Csv -Path "C:\Temp\BellTransportRules.csv" -NoTypeInformation

Get-InboundConnector | Select-Object Name, ConnectorType, Enabled, SenderDomains, RequireTls | Export-Csv -Path "C:\Temp\BellInboundConnectors.csv" -NoTypeInformation

Get-OutboundConnector | Select-Object Name, RecipientDomains, SmartHosts, Enabled, UseMXRecord | Export-Csv -Path "C:\Temp\BellOutboundConnectors.csv" -NoTypeInformation

