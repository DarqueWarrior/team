<!-- #include "./common/header.md" -->

# Add-VSTeamWorkItemType

## SYNOPSIS

<!-- #include "./synopsis/Add-VSTeamWorkItemType.md" -->

## SYNTAX

## Description

Adds a new WorkItem type to a custom process template. Note that the built-in process templates (Scrum, Agile etc.) do not allow their WorkItem types to be customized, this is only allowed for custom processes.

## EXAMPLES

### Example 1

```powershell
Add-VSTeamWorkItemType  -ProcessTemplate Scrum5 -WorkItemType ChangeRequest  -Description "New WorkItem Type" -Color Red  -Icon icon_asterisk
```

Modifies the custom process "Scrum5", creating a user-defined WorkItem type "ChangeRequest" with a red asterisk as its icon and some simple text in the description.

## PARAMETERS

<!-- #include "./params/forcegroup.md" -->

<!-- #include "./params/processTemplate.md" -->

### -Color

Sets the icon color. The input value can be the name of a color name like "Red" or "Aqua" or a hex value for red, green and blue parts. Color names should tab complete.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Description

Long text description of the WorkItem type.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Icon

One of the predefined icons for WorkItem types. Possible values should tab complete and
if the name omits the leading "Icon\_" it will be added automatically.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WorkItemType

The name for the new WorkItem type. (Alias "Name")

```yaml
Type: String
Parameter Sets: (All)
Aliases: Name

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS

[Get-VSTeamWorkItemType](Get-VSTeamWorkItemType.md)

[Set-VSTeamWorkItemType](Set-VSTeamWorkItemType.md)

[Remove-VSTeamWorkItemType](Remove-VSTeamWorkItemType.md)