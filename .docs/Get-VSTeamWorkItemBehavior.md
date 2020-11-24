<!-- #include "./common/header.md" -->

# Get-VSTeamWorkItemBehavior

## SYNOPSIS

<!-- #include "./synopsis/Get-VSTeamWorkItemBehavior.md" -->

## SYNTAX

## Description

In the user interface, WorkItems are shown on boards. The API refers to them as WorkItem and process behaviours.

In settings for a project based on the "Scrum" process template, for example, under team configuration "Epics", "Features" and/or "Backlog items" can be selected as "Backlog Navigation Levels" to display, and a fourth board "Tasks" is always used for displaying Sprints.  Bugs can either be displayed either on the Tasks board (as part of the "Iteration backlog" in a sprint) or on the Backlog Items board (as part of the "requirement backlog"). Iteration and Requirement are two categories of backlog which only have one board. The third category, Portfolio backlogs contains Epics, Features and user-defined boards/behaviors

As well as bugs, other built-in WorkItem types are tied to a particular board, the Epic type is always on the Epics board, the Feature type on Features, the Task type on Tasks and the Product BackLog item Type on Backlog items. (In Agile-based templates, the board for the requirement backlog is named "Stories" and the WorkItems type is User Story, CMMI-Based ones call their requirements backlog "Requirements" and the WorkItem type a Requirement and templates based on Basic use a board named "Issues" and the Issue workItem type ).

Other WorkItem types -in particular, custom-defined ones - are available to add to any of these boards. So, a new WorkItem type named "Change" might appear with tasks, with requirements, with features, or on a portfolio board of its own. When two or more WorkItem types are available on the same board, one type is selected as the default for new items added to the board.

Get-VSTeamProcessBehavior lists the boards available in the process template. And Get-VSTeamWorkItemBehavior shows the boards a WorkItem type can appear on and whether it is the default for that board.

## EXAMPLES

### Example 1

```powershell
Get-VSTeamWorkItemBehavior -WorkItemType Epic


WorkItem Type Behavior ID                              Is Default
------------- -----------                              ----------
Epic          Microsoft.VSTS.Scrum.EpicBacklogBehavior True
```

This shows the "Epic" type has the "Scrum.EpicBacklogBehavior" - in other words it is on the "Epics" board of the scrum process, because the current project's process template is, or is derived from, "Scrum"


### Example 2

```powershell
Get-VSTeamWorkItemBehavior -ProcessTemplate Scrum5 *


WARNING: Bug has no behaviors.
WARNING: Impediment has no behaviors.
WARNING: Test Case has no behaviors.
WARNING: Test Plan has no behaviors.
WARNING: Test Suite has no behaviors.
WorkItem Type        Behavior ID                                 Is Default
-------------        -----------                                 ----------
Product Backlog Item System.RequirementBacklogBehavior           True
Feature              Microsoft.VSTS.Scrum.FeatureBacklogBehavior True
Task                 System.TaskBacklogBehavior                  True
Epic                 Microsoft.VSTS.Scrum.EpicBacklogBehavior    True
```

This shows the all the WorkItem types in the template named scrum 5. "Bug", "Impediment" and the three "Test" types have no associated behavior (of these only Impediment can be assigned to one). Task and Product backlog Item are assigned to the iteration and requirements backlogs. And Feature and Epic are assigned to portfolio backlogs inherited from the Scrum Process Template.

## PARAMETERS


### -ProcessTemplate

The Process Template containing the WorkItem types of interest; if no Template is specified, the template for the current Project will be used. The value of this parameter should tab complete.

```yaml
Type: String
Parameter Sets: Process
```

### -WorkItemType

The WorkItem type(s) whose details should be retrieved (wild cards are supported).

```yaml
Type: String
Parameter Sets: Process
```

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS

[Set-VSTeamWorkItemBehavior](Set-VSTeamWorkItemBehavior.md)

[Get-VSTeamProcessBehavior](Get-VSTeamProcessBehavior.md)

[Get-VSTeamWorkItemType](Get-VSTeamWorkItemType.md)