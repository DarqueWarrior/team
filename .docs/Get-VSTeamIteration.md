<!-- #include "./common/header.md" -->

# Get-VSTeamIteration

## SYNOPSIS

<!-- #include "./synopsis/Get-VSTeamIteration.md" -->

## SYNTAX

## DESCRIPTION

<!-- #include "./synopsis/Get-VSTeamIteration.md" -->

## PARAMETERS

### Depth

Depth of children to fetch.

```yaml
Type: int32
```

### -Expand
If specified expands the `Children` node so the functions returns all decendants to the limit specified in depth.

```yaml
Type: SwitchParameter
Parameter Sets: WorkingDays
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### Path

Path of the classification node.

```yaml
Type: string
```

### Id

Integer classification nodes ids.

```yaml
Type: int32[]
```

<!-- #include "./params/projectName.md" -->

## INPUTS

## OUTPUTS

### System.Object

## NOTES

This is a wrapper function for Get-VSTeamClassificationNode

<!-- #include "./common/prerequisites.md" -->

## RELATED LINKS

<!-- #include "./common/related.md" -->

[Get-VSTeamClassificationNode](Get-VSTeamClassificationNode.md)

[Get-VSTeamIteration](Get-VSTeamIteration.md)
