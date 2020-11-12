<!-- #include "./common/header.md" -->

# Hide-VSTeamWorkItemState

## SYNOPSIS

<!-- #include "./synopsis/Hide-VSTeamWorkItemState.md" -->

## SYNTAX

## Description

Each WorkItem type in each process template has a set of possible states.  Items may have system-defined states and/or custom (user-defined) states. System states cannot be removed, but this command can hide them. Note that although some WorkItem types like "Bug" or "Task" are found in multiple templates, a change to the available states only applies to one template, and only custom templates can be modified, the built-in ones cannot.

## EXAMPLES

### Example 1

```PowerShell
Hide-VSTeamWorkItemState -WorkItemType Bug -Name Approved

Confirm
Are you sure you want to perform this action?
Performing the operation "Modify WorkItem type 'Bug' in process template 'Scrum'; hide state" on target "Approved".
[Y] Yes [A] Yes to All [N] No [L] No to All [S] Suspend [?] Help (default is "Yes"): y
WARNING: An error occurred: Response status code does not indicate success: 403 (Forbidden).
WARNING: VS402356: You do not have the permissions required to perform the attempted operation on this process.
```

In this example the user has tried to hide the state "Approved" for Bugs in the current project's template. -Force has not been specified and the confirmation prompt says that the process template to be modified is "Scrum". This is a built-in template, therefore WorkItem types and their states are read-only. The user continues and an error occurs (the full error is not shown) because changing the system process is forbidden.

### Example 2

```PowerShell
Hide-VSTeamWorkItemState -WorkItemType Bug -Name Approved -ProcessTemplate Scrum2 -Force

Order Name     Category Color  Customization Hidden
----- ----     -------- -----  ------------- ------
6     Approved Proposed b2b2b2 inherited     True
```

This version hides the state "Approved" for Bugs in the custom template named "Scrum2". -Force has specified to skip the confirmation, and the command returns the modified state. Notice that the customization column changes from "system" to "inherited" when a state is hidden.

If the state is already hidden a warning message will appear and the state will not be changed.

## PARAMETERS

### -Name

The name of the state to be hidden.

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

<!-- #include "./params/processTemplate.md" -->

<!-- #include "./params/workItemType.md" -->

<!-- #include "./params/forcegroup.md" -->

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS

[Add-VSTeamWorkItemState](Add-VSTeamWorkItemState.md)

[Get-VSTeamWorkItemState](Get-VSTeamWorkItemState.md)

[Show-VSTeamWorkItemState](Show-VSTeamWorkItemState.md)

[Remove-VSTeamWorkItemState](Remove-VSTeamWorkItemState.md)