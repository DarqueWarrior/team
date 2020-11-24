<!-- #include "./common/header.md" -->

# Get-VSTeamSetting

## SYNOPSIS

<!-- #include "./synopsis/Get-VSTeamSetting.md" -->

## SYNTAX

## Description

Returns the settings either for the default team in a project, or for a named team if one is specified. The command can either return all settings as a single object or return a single setting.

## EXAMPLES

### Example 1

```powershell
Get-VSTeamSetting

backlogIteration      : @{id=00000000-0000-0000-0000-000000000000; name=MyProject; path=;
   url=https://dev.azure.com/MyOrg/00000000-0000-0000-0000-000000000000/_apis/wit/classificationNodes/Iterations}
bugsBehavior          : asRequirements
workingDays           : {monday, tuesday, wednesday, thursday…}
backlogVisibilities   : @{Microsoft.EpicCategory=False; Microsoft.FeatureCategory=True; Microsoft.RequirementCategory=True}
defaultIteration      : @{id=00000000-0000-0000-0000-000000000000; name=Sprint 1; path=\Sprint 1;
   url=https://dev.azure.com/MyOrg/00000000-0000-0000-0000-000000000000/_apis/wit/classificationNodes/Iterations/Sprint%201}
defaultIterationMacro : @currentIteration
url                   : https://dev.azure.com/MyOrg/00000000-0000-0000-0000-000000000000/00000000-0000-0000-0000-000000000000/_apis/work/teamsettings
_links                : @{self=; project=; team=; teamIterations=; teamFieldValues=; classificationNode=System.Object[]}
```

Getting the settings for the default team in the current project returns a single object with all the information.

### Example 2

```powershell
Get-VSTeamSetting -ProjectName MyProject -Team 'planners' -BackLogVisibilites

Name                          Value
----                          -----
Custom.Changes                False
Microsoft.EpicCategory        False
Microsoft.FeatureCategory      True
Microsoft.RequirementCategory  True
```

This version of the command specifies the project and team and gets the BackLog Visibilites, including any that have been added to the process template as custom behaviors.

### Example 3

```powershell
Get-VSTeamSetting -ProjectName MyProject  -BackLogIteration

Name Path                    StructureType HasChildren Id
---- ----                    ------------- ----------- --
I3   \MyProject\Iteration\I3 iteration     True        16
```
In this case only the Backlog iteration is returned.

## PARAMETERS

### -BackLogIteration
If specified, only the backlog-iteration information is returned.

```yaml
Type: SwitchParameter
Parameter Sets: BackLogIteration
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -BackLogVisibilites
If specified, only a list of the Backlogs (system-defined and added as custom process-behaviors) will be returned with "true" or "false" for their visibility state. Note that it is possible to set a custom backlog as visible without any WorkItem type being associated with it, and it will be filtered out of the GUI interface while in that state.

```yaml
Type: SwitchParameter
Parameter Sets: BackLogVisibilites
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -BugsBehavior
If specified, the command will return a value of 'asRequirements' , 'asTasks' or 'off' for "Bugs are managed with requirements", "Bugs are managed with tasks" or "Bugs are not managed on backlogs and boards" respectively.

```yaml
Type: SwitchParameter
Parameter Sets: BugsBehavior
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DefaultIteration
If specified, only the default-iteration information is returned.
```yaml
Type: SwitchParameter
Parameter Sets: DefaultIteration
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ProjectName
The name of the project whose team settings are required.

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

### -Team
The name of the team whose settings should be returned, if no team is specified the project's default team is used.

```yaml
Type: String
Parameter Sets: (All)
Aliases: Name

Required: False
Position: 0
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -WorkingDays
If specified, returns only the list of working-days for the team.

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

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS

[Set-VSTeamSetting](Set-VSTeamSetting.md)

[Get-VSTeam](Get-VSTeam.md)
