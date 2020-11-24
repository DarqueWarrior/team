<!-- #include "./common/header.md" -->

# Set-VSTeamProcessBehavior

## SYNOPSIS

<!-- #include "./synopsis/Set-VSTeamProcessBehavior.md" -->

## SYNTAX

## Description

Modifies a Portfolio backlog (a.k.a behavior) in a Process Template.
Note (1) the built-in Process templates (Scrum, Agile etc.) do not allow their backlogs to be customized, this is only allowed for custom processes.
Note (2) System behaviors include a description, but this cannot be changed or set for custom behaviors.

## EXAMPLES

### Example 1

```powershell
Set-VSTeamProcessBehavior -ProcessTemplate Scrum5 -Name "Change Requests" -Color Blue


Rank Name            Workitem types Inherits                        color  Description
---- ----            -------------- --------                        -----  -----------
50   Change Requests                System.PortfolioBacklogBehavior 0000ff
```
Changes a portfolio backlog in the scrum5 processs template (note that the built-in templates, like "Scrum" cannot be changed, only user-defined ones - like scrum5 in this case - can have new backlogs).

## PARAMETERS

### -Color

Sets the the icon color for the backlog. The input value can be the name of a color like "Red" or "Aqua" or a hex value for red, green and blue parts. Color names should tab complete. If no color is provided, mid gray is used.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

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

### -NewName

Replacement name for the behavior / backlog

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

### -ProcessTemplate

The Process Template to modify. Note that the built-in Templates ("Scrum", "Agile" etc.) cannot be modified, only custom templates (derived from the built-in ones) can be changed.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 0
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

[Remove-VSTeamProcessBehavior](Remove-VSTeamProcessBehavior.md)
