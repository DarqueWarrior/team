<!-- #include "./common/header.md" -->

# Get-VSTeamWorkItemType

## SYNOPSIS

<!-- #include "./synopsis/Get-VSTeamWorkItemType.md" -->

## SYNTAX

## Description

<!-- #include "./synopsis/Get-VSTeamWorkItemType.md" -->

## EXAMPLES

### Example 1

```powershell
Get-VSTeamWorkItemType -ProjectName test -WorkItemType 'Code Review Response'
```

This command gets a single WorkItem type from the named project.

### Example 2

```powershell
Get-VSTeamWorkItemType -ProcessTemplate Basic
```

This command gets a list of the WorkItem types available to projects which use the 'Basic' Template.

### Example 3

```powershell
Get-VSTeamProcess scr* | Get-VSTeamWorkItemType -WorkItemType pro* | Format-Table name,processTemplate

name                 ProcessTemplate
----                 ---------------
Product Backlog Item Scrum
Product Backlog Item Scrum2
Product Backlog Item Scrum4
```

The first command in the pipeline gets the process templates with names which match SCR*, in this example
these are "Scrum", "Scrum2" and "Scrum4". The second command finds WorkItem types in those processes
which match "pro*", (each process has a "Product Backlog item" WorkItem type) and the third command
shows a table of type-name and the process-template which has that type.


## PARAMETERS

### -Expand

If specified, the WorkItem type information returned will have behavior, layout and/or state information attached, depending on the value of the parameter.

```yaml
Type: String[]
Parameter Sets: Process
Accepted values: 'behaviors','layout','states'
```

### -NotHidden

Excludes WorkItem Types which are marked as hidden.

```yaml
Type: SwitchParameter
Required: false
Position: Named
Accept pipeline input: false
Parameter Sets: (All)
```

<!-- #include "./params/projectName.md" -->

### -ProcessTemplate

The Process template holding the WorkItem type(s) of interest.
Note that if ProcessTemplate is specified it is still possible to provide a ProjectName parameter, but it will be ignored.

```yaml
Type: String
Parameter Sets: Process
```

### WorkItemType
The WorkItem type whose details should be retrieved (wild cards are supported).

```yaml
Type: String
Parameter Sets: ByType
```

## INPUTS

### System.String

## OUTPUTS

### System.Object

## NOTES

The JSON returned has empty named items i.e.
"": "To Do"
This causes issues with the ConvertFrom-Json CmdLet.  Therefore, all "": are replaced with "_end":


## RELATED LINKS

[Add-VSTeamWorkItemType](Add-VSTeamWorkItemType.md)

[Set-VSTeamWorkItemType](Set-VSTeamWorkItemType.md)

[Remove-VSTeamWorkItemType](Remove-VSTeamWorkItemType.md)