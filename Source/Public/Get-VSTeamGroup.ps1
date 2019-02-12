function Get-VSTeamGroup {
   [CmdletBinding(DefaultParameterSetName = 'List')]
   param(
      # NOTE: This parameter does not work yet. Once figured out, we can activate again.
      #[Parameter(ParameterSetName = 'List')]
      #[Parameter(ParameterSetName = 'ListByProjectName')]
      #[ValidateSet('Microsoft.IdentityModel.Claims.ClaimsIdentity','Microsoft.TeamFoundation.Identity')]
      #[ValidateSet('vsts')]
      #[string[]] $SubjectTypes,

      [Parameter(ParameterSetName = 'List')]
      [string] $ScopeDescriptor,

      [Parameter(ParameterSetName = 'ByGroupDescriptor', Mandatory = $true)]
      [Alias('GroupDescriptor')]
      [string] $Descriptor
   )

   DynamicParam {
      # Get-VSTeamGroup should never use cache
      [VSTeamProjectCache]::timestamp = -1

      _buildProjectNameDynamicParam -ParameterSetName 'ListByProjectName' -ParameterName 'ProjectName'
   }

   process {
      # Bind the parameter to a friendly variable
      $ProjectName = $PSBoundParameters["ProjectName"]

      if ($ProjectName)
      {
         $project = Get-VSTeamProject -Name $ProjectName
         $ScopeDescriptor = Get-VSTeamDescriptor -StorageKey $project.id
      }

      if ($Descriptor) {
         # Call the REST API
         $resp = _callAPI -Area 'graph/groups' -id $Descriptor `
            -Version $([VSTeamVersions]::Graph) `
            -SubDomain 'vssps'

         # Storing the object before you return it cleaned up the pipeline.
         # When I just write the object from the constructor each property
         # seemed to be written
         $group = [VSTeamGroup]::new($resp)

         Write-Output $group
      }
      else {

         $queryString = @{}
         if ($ScopeDescriptor) {
            $queryString.scopeDescriptor = $ScopeDescriptor
         }

         #if ($SubjectTypes -and $SubjectTypes.Length -gt 0)
         #{
         #   $queryString.subjectTypes = $SubjectTypes -join ','
         #}

         try {
            # Call the REST API
            $resp = _callAPI -Area 'graph' -id 'groups' `
               -Version $([VSTeamVersions]::Graph) `
               -QueryString $queryString `
               -SubDomain 'vssps'
            
            $objs = @()

            foreach ($item in $resp.value) {
               $objs += [VSTeamGroup]::new($item)
            }

            Write-Output $objs
         }
         catch {
            # I catch because using -ErrorAction Stop on the Invoke-RestMethod
            # was still running the foreach after and reporting useless errors.
            # This casuses the first error to terminate this execution.
            _handleException $_
         }
      }
   }
}