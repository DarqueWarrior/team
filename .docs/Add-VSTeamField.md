<!-- #include "./common/header.md" -->

# Add-VSTeamField

## SYNOPSIS

<!-- #include "./synopsis/Add-VSTeamField.md" -->

## SYNTAX

## DESCRIPTION

Every WorkItem has multiple data-fields. The definition of a Workitem type includes that type's fields, which are selected from a set of fields shared across all process templates in the organization. Each field has a name, a description, a datatype, and optionally a PickList of values. This command defines new fields. Note that the API only allows fields to be disabled after they have been created, not to be modified or deleted.


## EXAMPLES

### Example 1
```powershell
Add-VSTeamField -Name Office -Type string -PicklistID Offices -Description "Business Location"  -force

Name    Reference Name   Usage    Type   Read Only Description
----    --------------   -----    ----   --------- -----------
Office   Custom.Office   workItem string False    Business Location

```
Creates a new field, with a Name, Description and PickList option. Normally the command will pause for confirmation but here -Force has been specified.

## PARAMETERS

<!-- #include "./params/forcegroup.md" -->

### -Description
A description for the data-field.

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

### -IsPickListSuggested
If a picklist is specified, the input must be a value from the list, unless -IsPickListSuggested is supplied which means options are suggestions but other values may be entered.

```yaml
Type: SwitchParameter
Parameter Sets: WithPickList
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name
Name for the  new field.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -NoSort
If specified, the field will be configured to not allow sorting.

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

### -NotQueryable
If specified, the field cannot be the basis of a query.

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

### -PicklistID
Specifies a pre-existing picklist. Depending on the value of -IsPickListSuggested, selecting from the Picklist can be mandatory or optional.

```yaml
Type: Object
Parameter Sets: WithPickList
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -ReadOnly
If specified, user input to the field is not allowed.

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
Every field has a qualified reference name, in addition to its short name. If this field is not provided the reference name will be set to "Custom.Shortname"

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

### -Type
The datatype for the new field. This defaults to string, which is a single line of plain text in the user interface; multi-line rich text boxes are HTML, and as well as normal Boolean, integer, double, and datetime values, identity (a box to select a person, similar to the existing assigned-to one) is supported.

```yaml
Type: String
Parameter Sets: (All)
Aliases:
Accepted values: boolean, dateTime, double, html, identity, integer, string

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Usage
Fields may be defined for use in WorkItems, WorkItem links, WorkItem-type extensions, trees, or none of the these. The default value is workitem and this should not need to be changed.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:
Accepted values: workItem, workItemLink, workItemTypeExtension, tree, none

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

[Get-VSTeamField](Get-VSTeamField.md)

[Add-VSTeamWorkItemField](Add-VSTeamWorkItemField.md)

[Get-VSTeamPickList](Get-VSTeamPickList.md)

