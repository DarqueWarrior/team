<!-- #include "./common/header.md" -->

# Remove-VSTeamWorkItemField

## SYNOPSIS

<!-- #include "./synopsis/Remove-VSTeamWorkItemField.md" -->

## SYNTAX

## DESCRIPTION
Every WorkItem has multiple data-fields, and Fields are part of the definition of a WorkItem type. This command removes custom and inherited fields from the definitions of WorkItem types, undoing a previous change by an Add- or Set- command. System fields cannot be removed, and removing an inherited field reverts the field back to its system definition,

## EXAMPLES

### Example 1
```powershell
Remove-VSTeamWorkItemField -WorkItemType Impediment -ReferenceName Microsoft.VSTS.Common.Priority -ProcessTemplate Scrum5 -force

```

In the example for Set-VSTeamWorkItemField, the "Priority" field of the "Impediment" WorkItem type was modified, here the inherited field is deleted, taking the field back to its original definition. Running the command a second time, and attempting to delete the system field does not return an error or make any change.

## PARAMETERS

<!-- #include "./params/forcegroup.md" -->

<!-- #include "./params/processTemplate.md" -->

<!-- #include "./params/workItemType.md" -->

### -ReferenceName
The reference name of the field. The command will attempt to resolve a display name like "Closed Date" a partial name like "ClosedDate" to its full reference name, like "Microsoft.VSTS.Common.ClosedDate". Values for the field names should tab-complete.

```yaml
Type: Object
Parameter Sets: (All)
Aliases: Name, FieldName

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
[Get-VSTeamWorkItemField](Get-VSTeamWorkItemField.md)

[Set-VSTeamWorkItemField](Get-VSTeamWorkItemField.md)

