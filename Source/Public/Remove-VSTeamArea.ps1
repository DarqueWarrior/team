function Remove-VSTeamArea {
   [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "High",
    HelpUri='https://methodsandpractices.github.io/vsteam-docs/modules/vsteam/Remove-VSTeamArea')]
   param(
      [Parameter(Mandatory = $true)]
      [int] $ReClassifyId,

      [Parameter(Mandatory = $true)]
      [string] $Path,

      [Parameter(Mandatory = $true, Position = 0, ValueFromPipelineByPropertyName = $true)]
      [vsteam_lib.ProjectValidateAttribute($false)]
      [ArgumentCompleter([vsteam_lib.ProjectCompleter])]
      [string] $ProjectName,

      [switch] $Force
   )

   process {
      if ($force -or $pscmdlet.ShouldProcess($Path, "Delete area")) {
         $null = Remove-VSTeamClassificationNode -ProjectName $ProjectName `
            -StructureGroup 'areas' `
            -Path $Path `
            -ReClassifyId $ReClassifyId `
            -Force
      }
   }
}