using namespace System.Management.Automation

class ProcessValidateAttribute : ValidateArgumentsAttribute {
   [void] Validate(
      [object] $arguments,
      [EngineIntrinsics] $EngineIntrinsics) {

      #Do not fail on null or empty, leave that to other validation conditions
      if ([string]::IsNullOrEmpty($arguments)) {return}

      if (_hasProcessTemplateCacheExpired) {
         [VSTeamProcessCache]::processes = _getProcesses
         [VSTeamProcessCache]::timestamp = (Get-Date).Minute
      }

      if (($null -ne [VSTeamProcessCache]::processes) -and (-not ($arguments -in [VSTeamProcessCache]::processes))) {
         throw [ValidationMetadataException]::new(
            "'$arguments' is not a valid process. Valid processes are: '" +
            ([VSTeamProcessCache]::processes -join "', '") + "'")
      }
   }
}