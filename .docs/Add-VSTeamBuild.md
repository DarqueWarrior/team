#include "./common/header.md"

# Add-VSTeamBuild

## SYNOPSIS
#include "./synopsis/Add-VSTeamBuild.md"

## SYNTAX

### ByName (Default)
```
Add-VSTeamBuild [-ProjectName] <String> [-BuildDefinitionName <String>] [-QueueName <String>]
```

### ByID
```
Add-VSTeamBuild [-ProjectName] <String> [-BuildDefinitionId <Int32>] [-QueueName <String>]
```

## DESCRIPTION
Add-VSTeamBuild will queue a new build.

You can override the queue in the build defintion by using the QueueName
parameter.

To have the BuildDefinition and QueueNames tab complete you must set a default
project by calling Set-VSTeamDefaultProject before you call Add-VSTeamBuild.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
PS C:\> Set-VSTeamDefaultProject Demo
PS C:\> Add-VSTeamBuild -BuildDefinition Demo-CI

Build Definition Build Number  Status     Result
---------------- ------------  ------     ------
Demo-CI           Demo-CI-45   notStarted
```

This example sets the default project so you can tab complete the BuildDefinition parameter.

## PARAMETERS

#include "./params/projectName.md"

### -BuildDefinitionName
The name of the build defintion to use to queue to build.

```yaml
Type: String
Parameter Sets: ByName
Aliases: BuildDefinition

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -QueueName
The name of the queue to use for this build.

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -BuildDefinitionId
The Id of the build defintion to use to queue to build.

```yaml
Type: Int32
Parameter Sets: ByID
Aliases: Id

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

## INPUTS

### System.String
Build Defintion Name

### System.String
Queue Name

## OUTPUTS

## NOTES
BuildDefinition and QueueName are dynamic parameters and use the default 
project value to query their validate set. 

If you do not set the default project by called Set-VSTeamDefaultProject before
calling Add-VSTeamBuild you will have to type in the names.

## RELATED LINKS