
function Remove-VsteamWorkItemState {
   [CmdletBinding(SupportsShouldProcess=$true,ConfirmImpact='High')]
   param(
      [parameter(ValueFromPipelineByPropertyName=$true)]
      [vsteam_lib.ProcessTemplateValidateAttribute()]
      [ArgumentCompleter([vsteam_lib.ProcessTemplateCompleter])]
      $ProcessTemplate = $env:TEAM_PROCESS,

      [parameter(Mandatory = $true,ValueFromPipelineByPropertyName=$true)]
      [ArgumentCompleter([vsteam_lib.WorkItemTypeCompleter])]
      $WorkItemType,

      [Parameter(ValueFromPipelineByPropertyName=$true,Position=0)]
      $Name,

      [Switch]$Force
   )
   Process {
      $wit = $null
      #If $workItemtype contains an object, use it (if it was expanded) to avoid calling the API again
      if ($WorkItemType.psobject.TypeNames.Contains('vsteam_lib.WorkItemType')) {
         if ($WorkItemType.psobject.Properties['states']) {
            $wit = $WorkItemType
         }
         else {
            $WorkItemType = $workItemType.name
            $ProcessTemplate = $WorkItemType.ProcessTemplate
         }
      }
      if (-not $wit) {$wit = Get-VSTeamWorkItemType -ProcessTemplate $ProcessTemplate -WorkItemType  $WorkItemType -Expand states}

      #Filter matching types to only those with a matching state - to have a custom state they must be unlocked already.
      $wit = $wit | Where-Object {foreach ($n in $name) {if ($_.states.where({$_.name -like $n -and $_.customizationType -eq 'custom'})) {$true} }}

      if (-not $wit) {Write-Warning "Found no workitem types matching '$WorkItemType' with a custom state matching '$name'."}
      # May have more than one workitem type and the Name of the state might be an array or wildcard ,
      # loop through wildcards and through names, get matching states(s) and loop through those.
      foreach ($w in $wit){
         foreach ($n in $Name) {
            $state   = $w.states| Where-Object {$_.Name -like $n -and $_.customizationType -eq 'custom'}
            foreach ($s in $state) {
               if ($Force -or $PSCmdlet.ShouldProcess("$($w.name) in process template '$ProcessTemplate'", "Remove state '$($state.name)' from WorkItem type")) {
                  $url = "{0}/states/{1}?api-version={2}" -f $w.url, $s.id, (_getApiVersion Processes)
                  #Call the REST API - no result to send back for a delete
                  $null = _callAPI -Url $url -method Delete
               }
            }
         }
      }
   }
}
