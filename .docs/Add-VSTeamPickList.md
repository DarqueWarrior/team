<!-- #include "./common/header.md" -->

# Add-VSTeamPickList

## SYNOPSIS

<!-- #include "./synopsis/Add-VSTeamPickList.md" -->

## SYNTAX

## DESCRIPTION

Fields in WorkItems can be populated using PickLists to supply string or integer values. The user may be constrained to selecting from the list or the list may be "suggestions" allowing other values to be entered. This command creates a new PickList which may then be used in multiple fields if required.

## EXAMPLES

### Example 1
```powershell
Add-VSTeamPickList -Name Offices -Items "New York", "London", "Paris", "Munich"

Name    Type   Suggested Items
----    ----   --------- -----
Offices String False     New York, London, Paris, Munich
```

Creates a PickList to suggest locations. Note the items only need to be enclosed in quotes where they contain spaces or punctuation. In this case the type has been left as string, and list is not suggestions but the only allowed choices.

## PARAMETERS

<!-- #include "./params/forcegroup.md" -->

### -IsSuggested
By default, the selection for a control using a PickList must be a value from the list. If IsSuggested is set, then other values may be entered.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Items
A comma separated  list of items, or variable containing the items to offer in the list.

```yaml
Type: Object[]
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name
A name for the PickList, this name will only be used to link the list to one or more fields - the user interface only shows the field-names.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Type
String by default, Integer may be specified if the values are all Integers.

```yaml
Type: String
Parameter Sets: (All)
Aliases:
Accepted values:  integer, string

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS

[Get-VSTeamPickList](Get-VSTeamPickList.md)

[Set-VSTeamPickList](Set-VSTeamPickList.md)

[Remove-VSTeamPickList](Remove-VSTeamPickList.md)

[Add-VSTeamField](Add-VSTeamField.md)
