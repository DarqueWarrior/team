<!-- #include "./common/header.md" -->

# Set-VSTeamSetting

## SYNOPSIS

<!-- #include "./synopsis/Set-VSTeamSetting.md" -->

## SYNTAX

## Description

Modifies the settings either for the default team in a project, or for a named team, if one is specified. Teams can be piped into the command.  Depending on parameters passed, it can set the Default and Backlog Iterations, the Bug Behavior (handled as tasks, handled as requirements, or not handled through boards) Working Days, the Team Name and the Team Description.

## EXAMPLES

### Example 1

```powershell
Set-VSTeamSetting -ProjectName MyProj -Team 'Planning Team'  -BugsBehavior asTasks -BackLogVisibilites @{Epics=$true} -BacklogIteration CY2020-H2

Name                          Value
----                          -----
Microsoft.EpicCategory        Visible
Custom.Fails                  Hidden
Microsoft.FeatureCategory     Visible
Microsoft.RequirementCategory Visible
Bug display mode              asTasks
Working Days                  monday, tuesday, wednesday, thursday, friday
Default Iteration             Muddy
Backlog Iteration             CY2020
```

This command modifies the team named "Planning Team" in a named project, setting the iteration for Calendar Year 2020, half 2 which is the parent for short sprints, sets Bugs to be handled-as-tasks and reveals the Epics Backlog (using its display name).

### Example 2

```powershell
$it = Get-VSTeamIteration
$settings = Get-VSTeam -Name "planning team" | Set-VSTeamSetting -BacklogIteration $it -BackLogVisibilites @{'Microsoft.EpicCategory'=$false} -raw

```
The first line finds default iteration for the current project.
The second line has a pipeline of two commands - the first finds the team named "Planning Team" in the current project, and the second sets the iteration which was found in the previous line to be the team's backlog iteration and hides the Epics Backlog (using its reference name). Instead of returning a set of key/value pairs, this version returns the updated settings as a single object in $Settings for later use.


## PARAMETERS

### -BackLogIteration
The new backlog iteration for the team, this can be given the as iteration's Path, ID, GUID-identifier or as an object returned by Get-VSTeamIteration.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -BackLogVisibilites
A hash-table where the keys are backlogs - either by display name like "Epics" or the reference name like "Microsoft.EpicCategory" - and the values are true or false depending on whether the the backlog should be visible or not.. If text is used instead of a Boolean, "False" or "No" will be treated as false (hide) and all other non-empty values will be treated as true (show). Any backlogs not included in the hash-table will be left unchanged.

```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -BugsBehavior
Set to 'asRequirements' , 'asTasks' or 'off' for "Bugs are managed with requirements", "Bugs are managed with tasks" or "Bugs are not managed on backlogs and boards" respectively.

```yaml
Type: String
Parameter Sets: (All)
Aliases:
Accepted values: asRequirements, asTasks, off

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DefaultIteration
The new default iteration for the team, this can be given the iteration's Path, ID, GUID-identifier, or as an object returned by Get-VSTeamIteration
```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Description
A new description for the team.

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

### -NewName
A replacement name for the team.

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

### -ProjectName
The project containing the team to modified.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -RawOutput
If specified, returns the object sent back from the server in response to the set request. If not specified, settings are returned as a series of name/value pairs.

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

### -Team
The name of the Team whose settings should be modified. If not specified, the project's default team is used. The Team can be piped into the command and doing so will override any value set for Projectname.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 0
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -WorkingDays
An updated list of the list of working-days for the team. Note the full list must be given, "saturday" alone removes the other days.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:
Accepted values: monday, tuesday, wednesday, thursday, friday, saturday, sunday

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

[Get-VSTeamSetting](Get-VSTeamSetting.md)
