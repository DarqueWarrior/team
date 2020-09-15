function Show-VSTeamApproval {
   [CmdletBinding(HelpUri='https://methodsandpractices.github.io/vsteam-docs/modules/vsteam/Show-VSTeamApproval')]
   param(
      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [Alias('Id')]
      [int] $ReleaseDefinitionId,

      [Parameter(Mandatory = $true, Position = 0, ValueFromPipelineByPropertyName = $true)]
      [vsteam_lib.ProjectValidateAttribute($false)]
      [ArgumentCompleter([vsteam_lib.ProjectCompleter])]
      [string] $ProjectName
   )

   process {
      Show-Browser "$(_getInstance)/$ProjectName/_release?releaseId=$ReleaseDefinitionId"
   }
}
