#include "./common/header.md"

# Add-VSTeamAzureRMServiceEndpoint

## SYNOPSIS
#include "./synopsis/Add-VSTeamAzureRMServiceEndpoint.md"

## SYNTAX

```
Add-VSTeamAzureRMServiceEndpoint [-ProjectName] <String> [-DisplayName] <String> [-SubscriptionId] <String>
 [-SubscriptionTenantId] <String> [[-EndpointName] <String>]
```

## DESCRIPTION
The cmdlet adds a new connection between TFS/VSTS and Azure using the Azure 
Resource Manager connection type.

## EXAMPLES

## PARAMETERS

### -DisplayName
The display name of the service endpoint.

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: True
Position: 0
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -SubscriptionId
The id of the Azure subscription to use.

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -SubscriptionTenantId
The id of the Azure tenant to use.

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: True
Position: 2
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -EndpointName
The name displayed on the services page. 
In VSTS this is the Connection Name.

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

#include "./params/projectName.md"

## INPUTS

### System.String

## OUTPUTS

### System.Object

## NOTES

## RELATED LINKS