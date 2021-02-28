<!-- #include "./common/header.md" -->

# Remove-VSTeamWorkItemType

## SYNOPSIS

<!-- #include "./synopsis/Remove-VSTeamWorkItemType.md" -->

## SYNTAX

## Description

Removes a custom WorkItem type or reverts an inherited WorkItem type back to the built-in Type.

If the type is a system type (as all WorkItem types in built-in Process templates are) then an error will be thrown.

## EXAMPLES

### Example 1

```powershell
Remove-VSTeamWorkItemType -ProcessTemplate Scrum5 -WorkItemType ChangeRequest
```

Removes the custom WorkItem type named "ChangeRequest" from the custom process template named "Scrum5"

## PARAMETERS

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

### -WorkItemType

The name of the WorkItem type to be removed or reverted. If the WorkItem type is a system type (for example if had been changed but has already been reverted), then an error will be thrown.

The built-in system types cannot be deleted, but can be disabled with Set-VSTeamWorkItemType.

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

[Add-VSTeamWorkItemType](Add-VSTeamWorkItemType.md)

[Get-VSTeamWorkItemType](Get-VSTeamWorkItemType.md)

[Set-VSTeamWorkItemType](Remove-VSTeamWorkItemType.md)
