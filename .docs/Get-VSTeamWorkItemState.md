<!-- #include "./common/header.md" -->

# Get-VSTeamWorkItemState

## SYNOPSIS

<!-- #include "./synopsis/Get-VSTeamWorkItemState.md" -->

## SYNTAX

## Description

Each WorkItem type in each process template has a set of possible states, each of which belongs to a category which represents a stage in the item's lifecycle (Proposed, In-Progress, Completed, Resolved, Removed) and each has a color. Items may have system-defined states and/or custom (user-defined) states. Get-VSTeamWorkItemState lists the available states.

## EXAMPLES

### Example 1

```powershell
Get-VSTeamWorkItemState  -WorkItemType Bug

Order Name      Category   Color  Customization Hidden
----- ----      --------   -----  ------------- ------
1     New       Proposed   b2b2b2 system
2     Approved  Proposed   b2b2b2 system
3     Committed InProgress 007acc system
4     Done      Completed  339933 system
5     Removed   Removed    ffffff system
```

This lists the states for the built in WorkItem type "Bug" in the current project.
Notice that the states all have a customization of system; these states can be hidden but not removed.

### Example 2

```powershell
Get-VSTeamWorkItemState -ProcessTemplate Scrum4 -WorkItemType 'Update'


Order Name      Category   Color  Customization Hidden
----- ----      --------   -----  ------------- ------
1     New       Proposed   b2b2b2 custom
2     Committed InProgress 007acc custom
3     Done      Completed  339933 custom
4     Failed    Removed    ff0000 custom
```

This lists the states for the custom WorkItem type "update" in the custom process "Scrum4".
Notice that the states all have a customization of custom; these states can be removed but not hidden.

### Example 3

```powershell
Get-VSTeamProcess | Get-VSTeamWorkItemType -WorkItemType bug | Get-VSTeamWorkItemState | Sort-object name,processtemplate|  Format-table ProcessTemplate,WorkItemType,Order,name,Color -AutoSize


ProcessTemplate WorkItemType order name      color
--------------- ------------ ----- ----      -----
Agile           Bug              2 Active    007acc
CMMI            Bug              2 Active    007acc
Scrum           Bug              2 Approved  b2b2b2
...
```

This pipeline gets all the process-templates in the first command; in the second it gets the "Bug" WorkItem type in each one, and in the third it gets the states available for all the different versions of Bug. It sorts the results to group the states together - and finally formats the results as a table. (Only the first few rows are shown to save space.)
This shows that in the default "Agile" and "CMMI" templates bugs have a state of "Active" but do not have "Approved", but the reverse is true in the "Scrum" template.


## PARAMETERS

### -ProcessTemplate

The process holding the WorkItem types of interest.

```yaml
Type: String
Parameter Sets: Process
```

### WorkItemType

The WorkItem type whose states should be retrieved.

```yaml
Type: String
Parameter Sets: ByType
```

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS

[Get-VSTeamWorkItemType](Get-VSTeamWorkItemType.md)

[Add-VSTeamWorkItemState](Add-VSTeamWorkItemState.md)

[Hide-VSTeamWorkItemState](Hide-VSTeamWorkItemState.md)

[Show-VSTeamWorkItemState](Show-VSTeamWorkItemState.md)

[Remove-VSTeamWorkItemState](Remove-VSTeamWorkItemState.md)