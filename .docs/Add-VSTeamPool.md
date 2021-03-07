<!-- #include "./common/header.md" -->

# Add-VSTeamPool

## SYNOPSIS

<!-- #include "./synopsis/Add-VSTeamPool.md" -->

## SYNTAX

## DESCRIPTION

<!-- #include "./synopsis/Add-VSTeamPool.md" -->

## EXAMPLES

## PARAMETERS

### -Name

Name of the pool to create.

```yaml
Type: string
Required: True
```

### -Description

Description of the pool to create.

```yaml
Type: string
Required: False
```

### -AutoProvision

Auto-provision this agent pool in new projects.

```yaml
Type: string
Required: True
```

### -AutoAuthorize

Grant access permission to all pipelines.

```yaml
Type: string
Required: True
```

### -NoAutoUpdates

Turn off automatic updates of agents in the pool. Default is turned on.

```yaml
Type: string
Required: True
```

## INPUTS

### System.String

## OUTPUTS

### System.Object

## NOTES

## RELATED LINKS

[Remove-VSTeamAccount](Remove-VSTeamAccount.md)
[Update-VSTeamAccount](Update-VSTeamAccount.md)
[Get-VSTeamAccount](Get-VSTeamAccount.md)