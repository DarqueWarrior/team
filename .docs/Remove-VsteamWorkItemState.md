<!-- #include "./common/header.md" -->

# Remove-VSTeamWorkItemState

## SYNOPSIS

<!-- #include "./synopsis/Remove-VSTeamWorkItemState.md" -->

## SYNTAX

## Description

Each WorkItem type in each process template has a set of possible states.  Items may have system-defined states and/or custom (user-defined) states. This command removes custom states. Note that system states cannot be removed but can be hidden.

## EXAMPLES

### Example 1

```PowerShell
 Remove-VSTeamWorkItemState -WorkItemType Bug  -Name postponed -ProcessTemplate Scrum2

Confirm
Are you sure you want to perform this action?
Performing the operation "Modify WorkItem type 'Bug' in process template 'Scrum2'; delete state" on target "postponed".
[Y] Yes [A] Yes to All [N] No [L] No to All [S] Suspend [?] Help (default is "Yes"): y
```

This removes the state "Postponed" from the WorkItem type "Bug" in the template named "Scrum2" - because -Force was not specified a confirmation prompt is shown.

### Example 2

```PowerShell
Get-VSTeamWorkItemState -WorkItemType Bug  -ProcessTemplate Scrum2 | Where-Object customizationType -eq "custom" | Remove-VSTeamWorkItemState -Force
```

As an alternative to the first example, this removes any and all custom types from the WorkItem type "Bug" in the template named "Scrum2", and -Force is used to suppress any prompt which might appear.

## PARAMETERS

### -Name

The name of the state to be removed.

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

[Hide-VSTeamWorkItemState](Hide-VSTeamWorkItemState.md)

[Show-VSTeamWorkItemState](Show-VSTeamWorkItemState.md)