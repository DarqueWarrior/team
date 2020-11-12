<!-- #include "./common/header.md" -->

# Show-VSTeamWorkItemState

## SYNOPSIS

<!-- #include "./synopsis/Show-VSTeamWorkItemState.md" -->

## SYNTAX

## Description

Each WorkItem type in each process template has a set of possible states.  Items may have system-defined states and/or custom (user-defined) states. This command is used to un-hide system states which have previously been hidden.  Note that although some WorkItem types like "Bug" or "Task" are found in multiple templates, a change to the available states only applies to one template, and only custom templates can be modified, the built-in ones cannot.


## EXAMPLES

### Example 1

```PowerShell
Show-VSTeamWorkItemState -WorkItemType Bug -Name Approved -ProcessTemplate Scrum2 -Force
```
This un-hides the "Approved" state for Bugs in the custom process template "Scrum2", without the confirmation prompt.
If the state is not hidden a warning message will appear and the state will not be changed.

## PARAMETERS

### -Name

The name of the state to be revealed.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

<!-- #include "./params/forcegroup.md" -->

<!-- #include "./params/processTemplate.md" -->

<!-- #include "./params/workItemType.md" -->

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS

[Add-VSTeamWorkItemState](Add-VSTeamWorkItemState.md)

[Get-VSTeamWorkItemState](Get-VSTeamWorkItemState.md)

[Hide-VSTeamWorkItemState](Hide-VSTeamWorkItemState.md)

[Remove-VSTeamWorkItemState](Remove-VSTeamWorkItemState.md)