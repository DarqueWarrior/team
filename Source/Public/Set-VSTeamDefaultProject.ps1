function Set-VSTeamDefaultProject {
   [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseDeclaredVarsMoreThanAssignments", "")]
   [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "Low")]
   param(
      [switch] $Force,

      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [vsteam_lib.ProjectValidateAttribute($false)]
      [ArgumentCompleter([vsteam_lib.ProjectCompleter])]
      [string] $Project
   )
   DynamicParam {
      _buildLevelDynamicParam
   }

   begin {
      if (_isOnWindows) {
         $Level = $PSBoundParameters['Level']
      }
   }

   process {
      if ($Force -or $pscmdlet.ShouldProcess($Project, "Set-VSTeamDefaultProject")) {
         #Set at the process level, for any OS
         $env:TEAM_PROJECT = $Project
         [vsteam_lib.Versions]::DefaultProject = $Project

         $env:TEAM_PROCESS = [vsteam_lib.Versions]::DefaultProcess = Get-VSTeamProcess  -ExpandProjects |
               Where-Object Projects -Contains $Project | Select-Object -ExpandProperty Name

         if  ((_isOnWindows) -and $Level -and $level -ne "Process") {
            [System.Environment]::SetEnvironmentVariable("TEAM_PROJECT", $Project, $Level)
         }

         # Note: ProjectName Parameters should be given a default value of [vsteam_lib.Versions]::DefaultProject instead of globally forcing it this way.
         $Global:PSDefaultParameterValues["*-vsteam*:projectName"] = $Project
      }
   }
}
