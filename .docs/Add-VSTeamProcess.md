<!-- #include "./common/header.md" -->

# Add-VSTeamProcess

## SYNOPSIS

<!-- #include "./synopsis/Add-VSTeamProcess.md" -->

## SYNTAX

## DESCRIPTION

Add-VSTeamProcess will add a new process template to your organization. Processes define the available WorkItem types and the behaviors (backlog levels) for projects. Existing projects can be switched to a new process, and any enabled process can be used for creating new projects.

## EXAMPLES

### Example 1

```powershell
Add-VSTeamProcess -ParentProcess Basic -ProcessName "Basic J" -Description "New Basic Process"
Confirm
Are you sure you want to perform this action?
Performing the operation "Create New Process" on target "Basic J".
[Y] Yes [A] Yes to All [N] No [L] No to All [S] Suspend [?] Help (default is "Yes"):y
Name    Enabled Default Description
----    ------- ------- -----------
Basic J True    False  New Basic Process
```
Creates a new Process template, derived from the built-in Process named "Basic", and sets its description. The -Force switch was not specified, so the command prompts for confirmation.

### Example 2

```powershell
$s = Get-VSTeamProcess Scrum
'Scrum4', 'Scrum5' | Add-VSTeamProcess -Parent $s -Force -OutVariable Processes 


Name   Enabled Default Description
----   ------- ------- -----------
Scrum4 True    False
Scrum5 True    False   
```
Here the parent template is an object representing an existing process, and multiple names for different variations of the "Scrum" template are created. Note that in addition to being output, the processes are stored in a variable, $Processes, for later use by using the OutVariable common parameter. 


## PARAMETERS

<!-- #include "./params/confirm.md" -->

### -Description

The description of the new Process.

```yaml
Type: String
Required: False
```

<!-- #include "./params/force.md" -->

### -ParentProcess

New Processes must be based on an existing process. This can be one of the built in process names or the name of a user defined process. The names should tab-complete.

```yaml
Type: String
Required: True
```
### -ProcessName

The display-name for the new Process(es).

```yaml
Type: String[]
Aliases: Name
Required: True
Accept pipeline input: true (ByValue)
```

### -ReferenceName

Allows the system-generated name based on the new process's assigned GUID to be overriden. This parameter can usually be omitted, and should be omitted when piping multiple names into the command.  

```yaml
Type: String
Required: False
```

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS

[Get-VSTeamProcess](Get-VSTeamProcess.md)

[Set-VSTeamProcess](Set-VSTeamProcess.md)

[Remove-VSTeamProcess](Remove-VSTeamProcess.md)