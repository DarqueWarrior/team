<!-- #include "./common/header.md" -->

# Get-VsteamWorkItemField

## SYNOPSIS

<!-- #include "./synopsis/Get-VsteamWorkItemField.md" -->

## SYNTAX

## DESCRIPTION
<!-- #include "./synopsis/Get-VsteamWorkItemField.md" -->

## EXAMPLES

### Example 1
```powershell
Get-VSTeamWorkItemfield bug
```

Returns the fields for "Bug" WorkItems in the current project's process template.


### Example 2
```powershell
Get-VSTeamWorkItemfield -ProcessTemplate Scrum5 --WorkItemType  Change
```

Returns the fields in "Change" WorkItems in the custom process template named "Scrum5"

### Example 3
```powershell
Get-VSTeamWorkItemfield * | Group-Object -property Name  -NoElement  | Sort-Object count
```

Gets the fields for all WorkItem types in the current Project's template and produces a count to show how frequently they are used.

## PARAMETERS

### -ProcessTemplate
The name of the Process Template holding the WorkItem type(s) of interest

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


### -ReferenceName
The reference name of a field. The command will attempt to resolve a partial name like "ClosedDate" to its full reference name, like "Microsoft.VSTS.Common.ClosedDate". It will also search for wildcards in the field's Name and ReferenceName

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


### -WorkItemType
The name(s) of the WorkItem type(s) of interest (wildcards are allowed.)

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: True
Position: 0
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: True
```

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
