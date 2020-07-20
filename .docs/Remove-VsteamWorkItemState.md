<!-- #include "./common/header.md" -->

# Remove-VsteamWorkItemState

## SYNOPSIS
<!-- #include "./synopsis/Remove-VSTeamWorkItemState.md" -->

## SYNTAX

```
Remove-VsteamWorkItemState [-ProcessTemplate <Object>] -WorkItemType <Object> [[-Name] <Object>] [-Force]
 [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Each WorkItem type in each process templates has a set of possible states.  Items may have system defined states and/or custom (user defined) states. This command removes custom states. Note that system states, cannot be removed but can be hidden.

## EXAMPLES

### Example 1
```powershell
PS C:\> Remove-VsteamWorkItemState -WorkItemType Bug  -Name postponed -ProcessTemplate Scrum2

Confirm
Are you sure you want to perform this action?
Performing the operation "Modify WorkItem type 'Bug' in process template 'Scrum2'; delete state" on target "postponed".
[Y] Yes [A] Yes to All [N] No [L] No to All [S] Suspend [?] Help (default is "Yes"): y
```

This removes the state "Postponed" from the WorkItem type "Bug" in the template named "Scrum2" - because -Force was not specified a confirmation prompt is shown.

### Example 2
```powershell
PS C:\> Get-VsteamWorkItemState -WorkItemType Bug  -ProcessTemplate Scrum2 | Where-Object customizationType -eq "custom" | Remove-VsteamWorkItemState -Force

```

As an alternative to the first example, this removes any and all custom types from the WorkItem type "Bug" in the template named "Scrum2", and -Force is use to remove any prompt which might appear.


## PARAMETERS

### -Confirm
Prompts you for confirmation before running the cmdlet. By default the cmdlet displays the confirmation prompt so this is only required if the $ConfirmPreference automatic variable has been changed.

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

### -Force
Suppresses the confirmation dialog so the command can be run without user intervention.

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

### -Name
Name for the state to be removed.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 0
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -ProcessTemplate
Specifies the process template where the WorkItem Type to be modified is found; by default this will be the template for the current project. Because only custom templates can contain WorkItem types with custom values, this must be a custom template. Values for this parameter should tab-complete.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -WhatIf
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WorkItemType
The name of the WorkItem type whose state list is to be modified. Values for this parameter should tab-complete.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.Object

## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS