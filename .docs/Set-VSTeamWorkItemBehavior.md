<!-- #include "./common/header.md" -->

# Set-VSTeamWorkItemBehavior

## SYNOPSIS

<!-- #include "./synopsis/Set-VSTeamWorkItemBehavior.md" -->

## SYNTAX

## Description

Modifies the Portfolio backlog (a.k.a behavior) associated with a WorkItem type in a custom process template. Associating a type with a board allows WorkItems of that type to be added to the board. When a Board has more than one associated type, one of the types is nominated as the default for new WorkItems.

Note (1) System-defined Backlogs have WorkItem types associated with them which cannot be removed.

Note (2) The first WorkItem type added to a custom Backlog from the UI will be set as the default automatically. When adding the first one from the command-line this needs to be explicitly set.

## EXAMPLES

### Example 1

```powershell
 Set-VSTeamWorkItemBehavior -ProcessTemplate Scrum5 -WorkItemType Impediment -Behavior Epics

Confirm
Are you sure you want to perform this action?
Performing the operation "Modify Scrum5 to update definition of workitem type" on target "Impediment".
[Y] Yes [A] Yes to All [N] No [L] No to All [S] Suspend [?] Help (default is "Yes"): y

ProcessTemplate WorkItemType Behavior                                 IsDefault
--------------- ------------ --------                                 ---------
Scrum5          Impediment   Microsoft.VSTS.Scrum.EpicBacklogBehavior     False
```
This command adds the "Impediment" WorkItem type to the "Epics" Board in the custom Process Template named "Scrum5". It leaves the default type for new WorkItems as "Epic". The -Force switch has not been specified, so the command prompts for confirmation.


### Example 2

```powershell
 Set-VSTeamWorkItemBehavior -ProcessTemplate Scrum5 -WorkItemType Impediment -Remove -force

```
This undoes the previous example, without pausing for confirmation. Note that removing the default WorkItem type from the behavior will promote another type to be the default for new WorkItems. To explicitly promote a non-default WorkItem type to be the default, it must be removed and re-added.

## PARAMETERS

### -Confirm

Prompts you for confirmation before running the cmdlet. Normally the command will prompt for confirmation and -Confirm is only needed if \$ConfirmPreference has been changed.

<!-- #include "./params/force.md" -->

### -Behavior

Current name of the Behavior / Backlog. Either the display name or the reference name may be used.

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

### -ProcessTemplate

The Process Template containing the WorkItem type to be updated. Note that the built-in templates ("Scrum", "Agile" etc.) cannot be modified, only custom templates (derived from the built-in ones) can be changed.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -IsDefault
If specified when adding a behavior, makes that type the board's default for new items. Note that this can only be specified when adding a behavior.

```yaml
Type: SwitchParameter
Parameter Sets: AddOrSet
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Remove
If specified, removes any existing behavior from the WorkItem type. This is necessary before moving a custom type from one board to another or when promoting an item which is attached to one board to be the default for new WorkItems on that board.

```yaml
Type: SwitchParameter
Parameter Sets: Delete
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WorkItemType
The name of the WorkItem type to modify. Behaviors cannot be set for Bug, or for pre-exisitng Test types; and the WorkItem types bound to the system-created boards cannot removed from them; although other items can be added to these boards as their default type and the system-created WorkItem types can be disabled to prevent items of those types being created.

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

<!-- #include "./params/whatIf.md" -->

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS

[Get-Set-VSTeamWorkItemBehavior](Get-Set-VSTeamWorkItemBehavior.md)

[Get-VSTeamProcessBehavior](Get-VSTeamProcessBehavior.md)
