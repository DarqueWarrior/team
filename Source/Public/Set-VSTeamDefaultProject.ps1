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
      $dp = New-Object System.Management.Automation.RuntimeDefinedParameterDictionary

      # Only add these options on Windows Machines
      if (_isOnWindows) {
         $ParameterName = 'Level'
         # Create the collection of attributes
         $AttributeCollection = New-Object System.Collections.ObjectModel.Collection[System.Attribute]
         # Create and set the parameters' attributes
         $ParameterAttribute = New-Object System.Management.Automation.ParameterAttribute
         $ParameterAttribute.Mandatory = $false
         $ParameterAttribute.HelpMessage = "On Windows machines allows you to store the default project at the process, user or machine level. Not available on other platforms."
         # Add the attributes to the attributes collection
         $AttributeCollection.Add($ParameterAttribute)
         # Generate and set the ValidateSet
         if (_testAdministrator) {
            $arrSet = "Process", "User", "Machine"
         }
         else {
            $arrSet = "Process", "User"
         }
         $ValidateSetAttribute = New-Object System.Management.Automation.ValidateSetAttribute($arrSet)
         # Add the ValidateSet to the attributes collection
         $AttributeCollection.Add($ValidateSetAttribute)
         # Create and return the dynamic parameter
         $RuntimeParameter = New-Object System.Management.Automation.RuntimeDefinedParameter($ParameterName, [string], $AttributeCollection)
         $dp.Add($ParameterName, $RuntimeParameter)
      }

      return $dp
   }

   begin {
      if (_isOnWindows) {
         $Level = $PSBoundParameters[$ParameterName]
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
