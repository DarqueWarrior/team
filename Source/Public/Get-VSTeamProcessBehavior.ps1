
function Get-VSTeamProcessBehavior {
   [CmdletBinding()]
   param (
      [Parameter(ValueFromPipelineByPropertyName=$true,Position=1)]
      [vsteam_lib.ProcessTemplateValidateAttribute()]
      [ArgumentCompleter([vsteam_lib.ProcessTemplateCompleter])]
      $ProcessTemplate = $env:TEAM_PROCESS
   )
   Process {
      $wit = Get-VSTeamWorkItemType -ProcessTemplate $ProcessTemplate -Expand Behaviors
      if (-not $wit) {
         Write-Warning "Could not get WorkItem types for Process '$ProcessTemplate'." ; return
      }
      # could use $url = _getProcessTemplateUrl $ProcessTemplate, but quicker to use the URL from any WorkItem type object
      else { $url = $wit[0].url -replace '/workitemTypes/.*$', ''}

      $url = $url +'/behaviors?$expand=combinedFields&api-version=' + (_getApiVersion Processes)
      $resp =$resp = _callApi -url $url

      $resp = $resp.value | Sort-Object -Property @{e="Rank"; Descending=$true},
                        @{e={$_.inherits.behaviorRefName};Descending=$true}

      foreach ($r in $resp) {
            # Apply a Type Name so we can use custom format view and custom type extensions
            # and add the processTemplate name so it can become a parameter when the object is piped into other functions
            $r.psobject.TypeNames.Insert(0,'vsteam_lib.Processbehavior')
            $linkedWits = $wit.where({$_.behaviors.behavior.id -eq $r.referenceName}).name -Join ', '
            Add-Member -InputObject $r -MemberType NoteProperty -Name LinkedWorkItemTypes -Value $linkedWits
            Add-Member -InputObject $r -MemberType NoteProperty -Name ProcessTemplate     -Value $ProcessTemplate
      }

      return $resp
   }
}
