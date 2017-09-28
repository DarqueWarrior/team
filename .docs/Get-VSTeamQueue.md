#include "./common/header.md"

# Get-VSTeamQueue

## SYNOPSIS
#include "./synopsis/Get-VSTeamQueue.md"

## SYNTAX

### List (Default)
```
Get-VSTeamQueue [-ProjectName] <String> [-QueueName <String>] [-ActionFilter <String>]
```

### ByID
```
Get-VSTeamQueue [-ProjectName] <String> [-Id <String>]
```

## DESCRIPTION
#include "./synopsis/Get-VSTeamQueue.md"

## EXAMPLES

## PARAMETERS

### -QueueName
Name of the queue to return.

```yaml
Type: String
Parameter Sets: List
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ActionFilter
None, Manage or Use.

```yaml
Type: String
Parameter Sets: List
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

#include "./params/projectName.md"

### -Id
Id of the queue to return.

```yaml
Type: String
Parameter Sets: ByID
Aliases: QueueID

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

## INPUTS

### System.String

## OUTPUTS

### System.Object

## NOTES

## RELATED LINKS