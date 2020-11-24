<!-- #include "./common/header.md" -->

# Remove-VSTeamProcessBehavior

## SYNOPSIS

<!-- #include "./synopsis/Remove-VSTeamProcessBehavior.md" -->

## SYNTAX

## Description

<!-- #include "./synopsis/Remove-VSTeamProcessBehavior.md" -->

## EXAMPLES

### Example 1

```powershell
Set-VSTeamProcessBehavior -ProcessTemplate Scrum5 -Name "Change Requests"
```
Removes a Portfolio Backlog from the "scrum5" Processs Template (note that the only custom Behaviors on custom Templates can be removed).

## PARAMETERS

### -Confirm

Prompts you for confirmation before running the cmdlet. Normally the command will prompt for confirmation and -Confirm is only needed if \$ConfirmPreference has been changed.

<!-- #include "./params/force.md" -->

### -Name

Current name of the behavior / backlog

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

<!-- #include "./params/whatIf.md" -->

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
[Add-VSTeamProcessBehavior](Add-VSTeamProcessBehavior.md)

[Get-VSTeamProcessBehavior](Get-VSTeamProcessBehavior.md)

[Set-VSTeamProcessBehavior](Set-VSTeamProcessBehavior.md)
