<!-- #include "./common/header.md" -->

# Get-VSTeamProcess

## SYNOPSIS

<!-- #include "./synopsis/Get-VSTeamProcess.md" -->

## SYNTAX

## DESCRIPTION

The list of Process Templates can be filtered by name  (which may include Wildcard). You can also get a single Process Template by id

You must call Set-VSTeamAccount before calling this function.

## EXAMPLES

### Example 1

```powershell
Get-VSTeamProcess
```

This will return all the Process Templates

### Example 2

```powershell
Get-VSTeamProcess | Format-Wide
```

This will return the Process Templates only showing their name

### Example 3

```powershell
Get-VSTeamProcess *scrum*
```

This will return all process templates with names containing "scrum",
in other words, the default "Scrum" template and custom ones with
names like "Custom Scrum", "Scrum for Contoso" will all be returned.

### Example 4

```powershell
Get-VSTeamProcess  -ExpandProjects | where Projects -Contains "MyProject"

Name  Enabled Default Description
----  ------- ------- -----------
Scrum True    False   This template is for teams who follow the Scrum framework.
```

This gets the processes with their associated projects and filters the list
to the one which contains a particular project, the "Scrum" template in this example.

## PARAMETERS

<!-- #include "./params/ProcessName.md" -->

### Id

The id of the Process Template to return.

```yaml
Type: String
Parameter Sets: ByID
Aliases: ProcessID
```

### ExpandProjects

Gets the projects associated with the process, and sets the .Projects property of the Process item to be a list of project-names.

```yaml
Type: SwitchParameter
Required: false
Position: Named
Accept pipeline input: false
Parameter Sets: (All)
```

## INPUTS

## OUTPUTS

## NOTES

<!-- #include "./common/prerequisites.md" -->

## RELATED LINKS

<!-- #include "./common/related.md" -->

[Add-VSTeamProcess](Add-VSTeamProcess.md)

[Set-VSTeamProcess](Add-VSTeamProcess.md)

[Remove-VSTeamProcess](Remove-VSTeamProcess.md)