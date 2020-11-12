<!-- #include "./common/header.md" -->

# Set-VSTeamWorkItemType

## SYNOPSIS

<!-- #include "./synopsis/Set-VSTeamWorkItemType.md" -->

## SYNTAX

## Description

Modifies an existing WorkItem type in a custom process; where the WorkItem type is a built-in type, like "Bug",
the original item is preserved, and a new inherited version is created.
It is possible to change the Description, Icon, Icon Color, and to enable or disable the WorkItem type

## EXAMPLES

### Example 1

```powershell
Set-VSTeamWorkItemType -ProcessTemplate Scrum5 -WorkItemType Impediment -Disabled
```

Modifies the custom process "Scrum5", disabling the built-in WorkItem type "Impediment".

### Example 2

```powershell
Set-VSTeamWorkItemType -ProcessTemplate Scrum5 -WorkItemType ChangeRequest -Icon icon_parachute -color Blue -Description "For requests from customers"
```

Modifies the custom process "Scrum5", changing a user-defined WorkItem type "ChangeRequest" to use
a blue parachute icon and update its description.

## PARAMETERS

### -Color

Changes the  icon color. The input value can be the name of a color name like "Red" or "Aqua" or
a hex value for red, green and blue parts. Color names should tab complete.

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

### -Confirm

Prompts you for confirmation before running the cmdlet. Normally the command will prompt for confirmation and -Confirm is only needed if \$ConfirmPreference has been changed.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```
<!-- #include "./params/Force.md" -->

<!-- #include "./params/whatif.md" -->

<!-- #include "./params/processTemplate.md" -->

<!-- #include "./params/workItemType.md" -->

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

### -Disabled

If specified, disables the WorkItem type so that it cannot be selected for new items.

```yaml
Type: SwitchParameter
Parameter Sets: Hide
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Enabled

If specified, enables a WorkItem type which was previously disabled.

```yaml
Type: SwitchParameter
Parameter Sets: Show
Aliases:

Required: True
Position: Named
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

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS

[Add-VSTeamWorkItemType](Add-VSTeamWorkItemType.md)

[Get-VSTeamWorkItemType](Get-VSTeamWorkItemType.md)

[Remove-VSTeamWorkItemType](Remove-VSTeamWorkItemType.md)