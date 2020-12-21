<!-- #include "./common/header.md" -->

# Set-VSTeamWorkItemField

## SYNOPSIS

<!-- #include "./synopsis/Set-VSTeamWorkItemField.md" -->

## SYNTAX

## DESCRIPTION
Every WorkItem has multiple data-fields, and the fields available form part of the definition of a WorkItem type. They are selected from a set of fields shared across all process templates in the organization. This command is used to modify the fields in the definitions of WorkItem types. Note that the WorkItem types in the built-in Process Templates cannot be modified. Changing a field in a system WorkItem-type in a custom Template changes the WorkItem type to an inherited one, and changing a system field, creates an inherited version of the field. Deleting the inherited version reverts the field back to the system version. A change only applies to a single process template without affecting copies of the WorkItem type in other templates.

## EXAMPLES

### Example 1
```powershell
Set-VSTeamWorkItemField -ProcessTemplate Scrum5 -WorkItemType imp* -ReferenceName Priority -AllowedValues 1,2 -DefaultValue 1  -Force                              

WorkItemType Name     Reference Name                 Required Type    customization
------------ ----     --------------                 -------- ----    -------------
Impediment   Priority Microsoft.VSTS.Common.Priority          integer inherited

```

Looks for the "Impediment" WorkItem type using a Wildcard imp*, finds the Microsoft.VSTS.Common.Priority field using its short name "Priority", and changes its allowed values to 1 and 2 only (the default is 1..4). Only some system-defined fields have AllowedValues, custom fields must use PickLists, and changing the setting converts the field from a system field to an inherited one. 

## PARAMETERS

### -AllowGroups
Sets an identity field to be allow the entry of a group identity. Does not apply to other field types. To remove the AllowGroups flag from a field use -AllowGroups:$false.

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

<!-- #include "./params/forcegroup.md" -->

<!-- #include "./params/processTemplate.md" -->

<!-- #include "./params/workItemType.md" -->

### -AllowedValues
Specifies new allowed values for some system-defined fields. Has no effect on other fields. 

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DefaultValue
Sets a default value for the field.

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

### -ReadOnly
Makes a read/write field read-only. To remove the ReadOnly flag and make the field editable, use -ReadOnly:$false 

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

### -Required
If specified, changes a field from optional to required. To remove the required flag, use -Required:$false

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

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
[Add-VSTeamField](Add-VSTeamField.md)

[Get-VSTeamWorkItemField](Get-VSTeamWorkItemField.md)

[Get-VSTeamWorkItemType](Get-VSTeamWorkItemType.md)