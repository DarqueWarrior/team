<!-- #include "./common/header.md" -->

# Set-VSTeamPipelineAuthorization

## SYNOPSIS

<!-- #include "./synopsis/Set-VSTeamPipelineAuthorization.md" -->

## SYNTAX

## DESCRIPTION

<!-- #include "./synopsis/Set-VSTeamPipelineAuthorization.md" -->

## EXAMPLES

### Example 1

```powershell
Set-VSTeamPipelineAuthorization -PipelineIds 1 -ResourceId 34 -ResourceType Queue -Authorize $true
```
Authorizes the pipeline to access the resource 34 of type Queue (Agent Pool).

### Example 2

```powershell
Set-VSTeamPipelineAuthorization -PipelineIds 1 -ResourceId $resourceId -ResourceType VariableGroup -Authorize $false
```
Removes authorization from the pipeline to access the resource with id $resourceId of type VariableGroup.

### Example 3

```powershell
Set-VSTeamPipelineAuthorization -PipelineIds @(1,2,3) -ResourceId 34 -ResourceType Queue -Authorize $true
```
Authorizes the pipelines 1, 2 and 3 to access the resource 34 of type Queue (Agent Pool).

### Example 4
```powershell
Set-VSTeamPipelineAuthorization -ResourceId $resourceId -ResourceType Repository -AuthorizeAll $true
```
Authorize all pipelines to access the resource with id $resourceId of type Repository.

## PARAMETERS

### -Authorize
Allows given pipelines to use the named resource

```yaml
Type: Boolean
Parameter Sets: AuthorizeResource
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -AuthorizeAll
Removes any authorization restrictions for the given resource

```yaml
Type: Boolean
Parameter Sets: AuthorizeAll
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PipelineIds
List of pipeline Ids to authorize

```yaml
Type: Int32[]
Parameter Sets: AuthorizeResource
Aliases:

Required: True
Position: 0
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -ResourceId
Resource which the pipelines are authorized to use.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ResourceType
Resource type to authorize the pipeline on

```yaml
Type: String
Parameter Sets: (All)
Aliases:
Accepted values: Queue, Endpoint, Environment, VariableGroup, SecureFile, Repository

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

<!-- #include "./params/projectName.md" -->

## INPUTS

### System.Int32[]

## OUTPUTS

### System.Object

## NOTES
<!-- #include "./common/prerequisites.md" -->

## RELATED LINKS

<!-- #include "./common/related.md" -->
