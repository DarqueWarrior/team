<!-- #include "./common/header.md" -->

# Remove-VSTeamField

## SYNOPSIS

<!-- #include "./synopsis/Remove-VSTeamField.md" -->

## SYNTAX

## DESCRIPTION

The data fields used definition of a Workitem types are selected from a set of Fields shared across all Process Templates in the Organization. This command removes custom fields from the list of available fields. 

## EXAMPLES

### Example 1
```powershell
Get-VSTeamField Custom.* | Remove-VSTeamField  -Forces
```
Resets the system by deleting custom field types

## PARAMETERS

<!-- #include "./params/forcegroup.md" -->


### -ReferenceName
The reference name or short name of the field. 

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: true (ByValue)
Accept wildcard characters: False
```

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS

[Get-VSTeamField](Get-VSTeamField.md)

