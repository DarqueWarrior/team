<!-- #include "./common/header.md" -->

# Add-VSTeamWorkItemState

## SYNOPSIS

<!-- #include "./synopsis/Add-VSTeamWorkItemState.md" -->

## SYNTAX

## Description

Each WorkItem type in each process template has a set of possible states.  Items may have system-defined states and/or custom (user-defined) states. This command adds custom states. Note that unlike system states, custom ones can only be removed not hidden.

## EXAMPLES

### Example 1

```powershell
Add-VSTeamWorkItemState -WorkItemType Bug -Color Blue -Name Postponed -ProcessTemplate Scrum2 -Force

Order Name      Category   Color  Customization Hidden
----- ----      --------   -----  ------------- ------
4     Postponed InProgress 0000ff custom
```

This adds a state "postponed", shown in blue, as a custom state to the "Bug" WorkItem type in the "scrum2" process-template in the "in-progress" category. By default "Committed" is at position 3 in the list of states, as an "in-progress" state, and "Done" is at position 4 as a "completed" state, the new state is inserted between them, shifting "Done", and any state(s) below it, down by one position.

## PARAMETERS

### -Color

The color for the state either as a name, or as a hex RGB value like "ff0000" for Red. Color names should tab complete.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name

Name for the new state.

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

### -Order

Positions the new state in the selection list.  Items must flow in the order, Proposed, In Progress, Resolved, Completed. so it is not possible to create an item in the "Proposed" category with a high number or in the "Completed" category with a low one. The first position in the list is 1, and if no order is specified the new state will be added at the end of its category

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -StateCategory

Each state fits into one of five categories: Proposed, InProgress, Resolved, Completed, or Removed. If no category is given the new state is assumed to be a form of "in progress".

```yaml
Type: String
Parameter Sets: (All)
Aliases:
Accepted values: Proposed, InProgress, Resolved, Completed, Removed

Required: False
Position: Named
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

[Get-VsteamWorkItemState](Get-VsteamWorkItemState.md)

[Hide-VsteamWorkItemState](Hide-VsteamWorkItemState.md)

[Show-VsteamWorkItemState](Show-VsteamWorkItemState.md)

[Remove-VsteamWorkItemState](Remove-VsteamWorkItemState.md)