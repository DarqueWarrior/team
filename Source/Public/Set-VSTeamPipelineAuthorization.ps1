function Set-VSTeamPipelineAuthorization {
   [CmdletBinding(DefaultParameterSetName = 'AuthorizeResource', SupportsShouldProcess = $true, ConfirmImpact = "Medium",
      HelpUri = 'https://methodsandpractices.github.io/vsteam-docs/docs/modules/vsteam/commands/Set-VSTeamPipelineAuthorization')]
   param (
      [Parameter(ParameterSetName = 'AuthorizeResource', Mandatory = $true, ValueFromPipeline = $true, Position = 0)]
      [int[]] $PipelineIds,
      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [vsteam_lib.ProjectValidateAttribute($false)]
      [ArgumentCompleter([vsteam_lib.ProjectCompleter])]
      [string] $ProjectName,
      [Parameter(ParameterSetName = 'AuthorizeResource', Mandatory = $true)]
      [Parameter(ParameterSetName = 'AuthorizeAll', Mandatory = $true)]
      [string]

      $ResourceId,
      [Parameter(ParameterSetName = 'AuthorizeResource', Mandatory = $true)]
      [Parameter(ParameterSetName = 'AuthorizeAll', Mandatory = $true)]
      [string]
      [ValidateSet("Queue", "Endpoint", "Environment", "VariableGroup", "SecureFile", "Repository")]
      $ResourceType,
      [Parameter(ParameterSetName = 'AuthorizeResource', Mandatory = $true)]
      [bool]
      $Authorize,
      [Parameter(ParameterSetName = 'AuthorizeAll', Mandatory = $true)]
      [bool]
      $AuthorizeAll
   )

   process {
      $permPipeBody = @{
         # this part is actually disabling auto approval for pipelines (also future) to use this resource

         allPipelines = @{
            authorized = $AuthorizeAll
         }
         # this part is tragetting specific pipelines that are supposed to be authorized for the resource
         pipelines    = @( )
      }

      if ($PipelineIds) {
         foreach ($id in $PipelineIds) {
            $permPipeBody.pipelines += @{
               id         = $id
               authorized = $Authorize
            }
         }
      }

      $permPipeJsonBody = $permPipeBody | ConvertTo-Json -Compress -Depth 100

      $completeResourceId = $null

      switch ($ResourceType) {
         "Repository" {
            $projectId = (Get-VSTeamProject -Name $ProjectName).id
            $completeResourceId = "$ResourceType/$projectId." + $ResourceId
         }
         Default {
            $completeResourceId = "$ResourceType/" + $ResourceId
         }
      }

      if ($PSCmdlet.ShouldProcess("$ResourceType $ResourceId with Pipeline $PipelineId", $Authorized)) {

         $resp = _callAPI -Method PATCH `
            -ProjectName $ProjectName `
            -Area 'Pipelines' `
            -Resource 'pipelinePermissions' `
            -Id $completeResourceId `
            -Body $permPipeJsonBody `
            -Version $(_getApiVersion Pipelines)

         Write-Output $resp
      }
   }
}
