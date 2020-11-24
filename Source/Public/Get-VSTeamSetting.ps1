Function Get-VSTeamSetting {
   [CmdletBinding(DefaultParameterSetName="Default")]
   Param (

      [Parameter(Mandatory = $True, Position = 1)]
      [vsteam_lib.ProjectValidateAttribute($false)]
      [ArgumentCompleter([vsteam_lib.ProjectCompleter])]
      $ProjectName,

      [Parameter(Mandatory = $false, Position = 0, ValueFromPipelineByPropertyName=$true)]
      [Alias('Name')]
      [string]$Team,

      [Parameter(ParameterSetName="DefaultIteration")]
      [switch]$DefaultIteration,

      [Parameter(ParameterSetName="BackLogIteration")]
      [switch]$BackLogIteration,

      [Parameter(ParameterSetName="BackLogVisibilites")]
      [switch]$BackLogVisibilites,

      [Parameter(ParameterSetName="BugsBehavior")]
      [switch]$BugsBehavior,

      [Parameter(ParameterSetName="WorkingDays")]
      [switch]$WorkingDays
   )
   process {
      $params = @{Area            ='work'
                  Resource        ='teamsettings'
                  ProjectName     = $ProjectName
      }
      if ($Team) {$params["Team"] = $Team}

      $settings = _callapi @params
      switch ($true) {
         $BacklogIteration   {
                           if ($settings.backlogIteration.psobject.properties.name -contains "url"){
                              $resp = _callAPI -url $settings.backlogIteration.url

                              return [vsteam_lib.ClassificationNode]::new($resp, $ProjectName)
                           }
         }
         $DefaultIteration   {
                           if ($settings.defaultIteration.psobject.properties.name -contains "url"){
                              $resp = _callAPI -url $settings.defaultIteration.url

                              return [vsteam_lib.ClassificationNode]::new($resp, $ProjectName)
                            }
         }
         $BackLogVisibilites {
                              $settings.backlogVisibilities.psobject.properties | Select-Object name, value   |
                              Write-Output
         }
         $BugsBehavior       {return $settings.bugsBehavior }
         $WorkingDays        {return $settings.workingDays  }
         default             {return $settings }
      }
   }
}
