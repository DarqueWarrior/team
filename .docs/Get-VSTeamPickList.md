<!-- #include "./common/header.md" -->

# Get-VSTeamPickList

## SYNOPSIS

<!-- #include "./synopsis/Get-VSTeamPickList.md" -->

## SYNTAX

## DESCRIPTION

Lists the PickList avaialable to populate String and Integer fields used by WorkItems.

## EXAMPLES

### Example 1
```powershell
Get-VSTeamPickList

Name       Type   Suggested Items
----       ----   --------- -----
Region     String False
Offices    String False
Continents String False

```

With no parameters, all the PickList are returned: note that the API can't show the values in each list when getting the list-of-lists.

### Example 2
```powershell
Get-VSTeamPickList offices,Regions

Name    Type   Suggested Items
----    ----   --------- -----
Offices String False     New York, London, Paris, Munich
Regions String False     North, South, East, West, Central
```

When specifying one or more PickList by name or by GUID, the values in the list are shown.


### Example 3
```powershell
Get-VSTeamPickList | Get-VSTeamPickList

Name       Type   Suggested Items
----       ----   --------- -----
Offices    String False     New York, London, Paris, Munich
Regions    String False     North, South, East, West, Central
Continents String False     Africa, Americas, Asia, Europe, Ocenania
```

We can call the command twice, once to get a list-of-lists, and then piping each list into a second instance to get its values.

## PARAMETERS

### -PicklistID
The name or ID of one or more PickList. If a PickList object is passed, its ID will be used.

```yaml
Type: Object
Parameter Sets: (All)
Aliases: Name, ID

Required: False
Position: 0
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS

[Add-VSTeamPickList](Add-VSTeamPickList.md)

[Set-VSTeamPickList](Set-VSTeamPickList.md)

[Get-VSTeamField](Get-VSTeamField.md)
