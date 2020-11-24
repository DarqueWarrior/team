Function Set-VSTeamSetting {
   [CmdletBinding(SupportsShouldProcess=$True)]
   param(
      [Parameter(Mandatory = $True, Position = 1)]
      [vsteam_lib.ProjectValidateAttribute($false)]
      [ArgumentCompleter([vsteam_lib.ProjectCompleter])]
      $ProjectName,

      [Parameter(Mandatory = $false, Position = 0, ValueFromPipeline=$true)]
      $Team,

      [ValidateSet('asRequirements' , 'asTasks', 'off')]
      [string]
      $BugsBehavior,

      [hashtable]
      $BackLogVisibilites,

      $BacklogIteration,

      $DefaultIteration,

      [ValidateSet('monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday', 'sunday')]
      [string[]]
      $WorkingDays,

      [string]
      $NewName,

      [string]
      $Description,

      [switch]
      $Force,

      [switch]
      $RawOutput
   )
   process {
      #We can't use valueFromPipelineByPropertyName because $PSDefaultParameterValues forces the current project into
      #$projectname. So instead Pipe the whole object into team and then get the projectname and team name from it.
      if ($Team.psobject.properties.name -contains 'ProjectName') {$ProjectName = $Team.ProjectName}
      if ($Team.psobject.properties.name -contains 'Name')        {$Team        = $Team.Name}

      $params = @{method      = 'Patch'
                  version     = _getApiVersion Processes
      }

      if ($NewName -or $Description) {
         $body = @{}
         if ($NewName) {$body['name'] = $NewName}
         if ($Description) {$body['description'] = $Description}
         $params +=  @{
            Area     = 'projects'
            Resource = "$ProjectName/teams"
            id       = $Team
            body     = ConvertTo-Json $body
         }

         if ($force -or $PSCmdlet.ShouldContinue($Team,'Change name and/or description of team.')){
            $resp = _callapi @params
            Write-Output [vsteam_lib.Team]::new($resp, $ProjectName)
         }
      }

      #see https://docs.microsoft.com/en-us/rest/api/azure/devops/core/projects/update?view=azure-devops-rest-6.1
      # for making a team the default project team.
      #can't see where to set team area.

      $body = @{}
      #Resolve default and backlog interations. If they are digits look up that ID
      #If they were or just came back as an obkect with an identifier GUID, use it.
      #if we haven't got a GUID yet treat what we have as a path and try to get that
      if ($DefaultIteration -match "^\d+$" ) {
          $DefaultIteration = Get-VSTeamIteration -projectname $ProjectName -id $DefaultIteration
      }
      if ($DefaultIteration -and 'identifier' -in $DefaultIteration.psobject.Properties.name) {
          $DefaultIteration = $DefaultIteration.Identifier.Guid
      }
      if ($DefaultIteration -and $DefaultIteration -notmatch "[0-9A-F]{8}-([0-9A-F]{4}-){3}[0-9A-F]{12}") {
         $i = Get-VSTeamIteration -Path $DefaultIteration -ProjectName $ProjectName
         if (-not $i) {Write-Warning "$DefaultIteration not found" ; return }
         else {$DefaultIteration = $i.Identifier.Guid}
      }
      if ($BacklogIteration -match "^\d+$" ) {
          $BacklogIteration = Get-VSTeamIteration -projectname $ProjectName -id $BacklogIteration
      }
      if ($BacklogIteration -and 'identifier' -in $BacklogIteration.psobject.Properties.name) {
          $BacklogIteration = $BacklogIteration.Identifier.Guid
      }
      if ($BacklogIteration -and $BacklogIteration -notmatch "[0-9A-F]{8}-([0-9A-F]{4}-){3}[0-9A-F]{12}") {
         $i = Get-VSTeamIteration -Path $BacklogIteration -ProjectName $ProjectName
         if (-not $i) {Write-Warning "$BacklogIteration not found" ; return }
         else {$BacklogIteration = $i.Identifier.Guid}
      }
      if ($BackLogVisibilites) {
         $visibilites  = @{}
         # Validate Names & translate from "Backlog items" to 'Microsoft.RequirementCategory' etc. Ensure values are boolean.
         $bhash = @{}
         $backlogConfig =  _callapi -ProjectName $ProjectName -area work -resource 'backlogconfiguration'
         @($backlogConfig.portfolioBacklogs) + $backlogConfig.requirementBacklog |
            ForEach-Object {$bhash[$_.name] = $_.id}

         foreach ($k in $BackLogVisibilites.Keys) {
            if     ($bhash.ContainsValue($k)) {$Visibilites[$k]         = $BackLogVisibilites[$k] -notmatch "false|No" }
            elseif ($bhash.ContainsKey($k))   {$Visibilites[$bhash[$k]] = $BackLogVisibilites[$k] -notmatch "false|No" }
            else  {
               Write-Warning ("$K is not a valid backlog for the project '$ProjectName'. Valid backlogs are" + ($bhash.Values -join ', ') + '.')
               return
            }
         }
         $body['backlogVisibilities'] = $visibilites
      }
      if ($BacklogIteration) {$body['backlogIteration']  = $BacklogIteration}
      if ($DefaultIteration) {$body['defaultIteration']  = $DefaultIteration}
      if ($BugsBehavior)     {$body['bugsBehavior']      = $BugsBehavior}
      if ($WorkingDays)      {$body['workingDays']       = $WorkingDays }

      if ($body.Count -eq 0 ) {return }

      if ($Team) {
         $params["Team"]     = $Team
      }
      $params['area']        ='work'
      $params['resource']    ='teamsettings'
      $params['projectName'] = $ProjectName
      $params['body']        = ConvertTo-Json $body

      if ($force -or $PSCmdlet.ShouldProcess($Team,'Change settings for team.')){
         $resp = _callAPI @params

         if ($RawOutput) {return $resp}
         else {
            $resp.backlogVisibilities.psobject.properties | Select-Object Name, @{n='Value';e={if($_.value) {'Visible'} else{'Hidden'}} }  |
               Write-Output
            [PSCustomObject]@{Name = 'Bug display mode';  Value =  $resp.bugsBehavior}
            [PSCustomObject]@{Name = 'Working Days';   ;  Value = ($resp.workingDays -join ', ')}
            [PSCustomObject]@{Name = 'Default Iteration'; Value =  $resp.defaultIteration.name}
            [PSCustomObject]@{Name = 'Backlog Iteration'; Value =  $resp.BacklogIteration.name}
         }
      }
   }
}
