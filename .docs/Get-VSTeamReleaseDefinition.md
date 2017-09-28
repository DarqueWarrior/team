#include "./common/header.md"

# Get-VSTeamReleaseDefinition

## SYNOPSIS
#include "./synopsis/Get-VSTeamReleaseDefinition.md"

## SYNTAX

### List (Default)
```
Get-VSTeamReleaseDefinition [-ProjectName] <String> [-Expand <String>]
```

### ByID
```
Get-VSTeamReleaseDefinition [-ProjectName] <String> [-Id <Int32[]>]
```

## DESCRIPTION
The Get-VSTeamReleaseDefinition function gets the release definitions for a team
project.

The project name is a Dynamic Parameter which may not be displayed
in the syntax above but is mandatory.

With just a project name, this function gets all of the release definitions
for that team project.

You can also specify a particular release defintion
by ID.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
PS C:\> Get-VSTeamReleaseDefinition -ProjectName demo | Format-List *
```

This command gets a list of all release definitions in the demo project.
The
pipeline operator (|) passes the data to the Format-List cmdlet, which
displays all available properties (*) of the release defintion objects.

## PARAMETERS

#include "./params/projectName.md"

### -Expand
Specifies which property should be expanded in the list of Release
Definition (environments, artifacts, none).

```yaml
Type: String
Parameter Sets: List
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Id
Specifies one or more release definitions by ID.

To specify multiple IDs, use commas to separate the IDs.

To find the ID of a release defintion, type Get-VSTeamReleaseDefinition.

```yaml
Type: Int32[]
Parameter Sets: ByID
Aliases: ReleaseDefinitionID

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

## INPUTS

### Int[]

## OUTPUTS

### Team.ReleaseDefinition

## NOTES

## RELATED LINKS

[Add-VSTeamAccount](Add-VSTeamAccount.md)
[Set-VSTeamDefaultProject](Set-VSTeamDefaultProject.md)
[Add-VSTeamReleaseDefinition](Add-VSTeamReleaseDefinition.md)
[Remove-VSTeamReleaseDefinition](Remove-VSTeamReleaseDefinition.md)