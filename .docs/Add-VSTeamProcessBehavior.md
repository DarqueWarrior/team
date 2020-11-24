<!-- #include "./common/header.md" -->

# Add-VSTeamProcessBehavior

## SYNOPSIS

<!-- #include "./synopsis/Add-VSTeamProcessBehavior.md" -->

## SYNTAX

## Description

Adds a new portfolio backlog (a.k.a behavior) to a Process Template.     
Note (1) The built-in Process templates (Scrum, Agile etc.) do not allow their backlogs to be customized, this is only allowed for custom processes.    
Note (2) System behaviors include a description, but this cannot be changed or set for custom behaviors.    
Note (3) The user interface hides any backlog which does not have any WorkItem type(s) associated with it.

## EXAMPLES

### Example 1

```powershell
Add-VSTeamProcessBehavior -ProcessTemplate Scrum5 -Name "Change Requests" -Color AliceBlue


Rank Name            Workitem types Inherits                        color  Description
---- ----            -------------- --------                        -----  -----------
50   Change Requests                System.PortfolioBacklogBehavior f0f8ff
```
This adds a new Portfolio Backlog to the "scrum5" process template (note that the built-in templates, like "Scrum" cannot be changed, only user-defined ones - like scrum5 in this case - can have new Backlogs). Initially no WorkItem types are attached to the new Backlog.

## PARAMETERS

### -Color

Sets the icon color for the Backlog. The input value can be the name of a color, like "Red" or "Aqua" or a hex value for red, green and blue parts. Color names should tab complete. If no color is provided, mid gray is used.

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

<!-- #include "./params/forcegroup.md" -->

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

### -Name

Name for the new Behavior / Backlog.

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

The process template to modify. Note that the built-in templates ("Scrum", "Agile" etc.) cannot be modified, only custom templates (derived from the built-in ones) can be changed.

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

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS

[Get-VSTeamProcessBehavior](Get-VSTeamProcessBehavior.md)

[Remove-VSTeamProcessBehavior](Remove-VSTeamProcessBehavior.md)

[Set-VSTeamProcessBehavior](Set-VSTeamProcessBehavior.md)
