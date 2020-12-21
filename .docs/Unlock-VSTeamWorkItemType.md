<!-- #include "./common/header.md" -->

# Unlock-VSTeamWorkItemType

## SYNOPSIS

<!-- #include "./synopsis/Unlock-VSTeamWorkItemType.md" -->

## SYNTAX

## Description

Takes a WorkItem type and if its customization field implies a custom or inherited type, simply returns it.
If it is a (locked) system type, creates a inherted type based on it, and returns the new type, optionally expanding the layout, states, or behaviors.

## PARAMETERS

### -Expand

If specified, the WorkItem type information returned after unlocking will have behavior, layout and/or state information attached, depending on the value of the parameter.
If not specified, the WorkItemType returned after unlocking will be simply be the result of the API call to create an inherited item.
Has no effect if the item is already unlocked.

```yaml
Type: String[]
Parameter Sets: Process
Accepted values: 'behaviors','layout','states'
```

<!-- #include "./params/forcegroup.md" -->

### -WorkItemType

An object representing the WorkItemType which should be unlocked (and may already be).

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 0
Default value: None
Accept pipeline input: True
Accept wildcard characters: False
```

## INPUTS

### System.String

## OUTPUTS

### System.Object

## NOTES

## RELATED LINKS

[Add-VSTeamWorkItemType](Add-VSTeamWorkItemType.md)

[Get-VSTeamWorkItemType](Get-VSTeamWorkItemType.md)

[Remove-VSTeamWorkItemType](Remove-VSTeamWorkItemType.md)