
function Show-VsteamWorkItemState {
   [CmdletBinding(SupportsShouldProcess=$true,ConfirmImpact='High')]
   param(
      [parameter(ValueFromPipelineByPropertyName=$true)]
      [vsteam_lib.ProcessTemplateValidateAttribute()]
      [ArgumentCompleter([vsteam_lib.ProcessTemplateCompleter])]
      $ProcessTemplate =  $env:TEAM_PROCESS,

      [parameter(Mandatory = $true,ValueFromPipelineByPropertyName=$true)]
      [ArgumentCompleter([vsteam_lib.WorkItemTypeCompleter])]
      $WorkItemType,

      [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=0)]
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

      #Filter matching types to only those with a matching state - to have an inherited state they must be unlocked already.
      $wit = $wit | Where-Object {foreach ($n in $name) {if ($_.states.where({$_.name -like $n -and $_.customizationType -eq 'inherited'})) {$true} }}
      if (-not $wit) {Write-Warning "Found no workitem types matching '$WorkItemType' with a hidden state matching '$name'."}
      foreach ($w in $wit){
         foreach ($n in $Name) {
            $state = $w.states.Where({$_.Name -like $n -and $_.customizationType -eq 'inherited' })
            foreach ($s in $state) {
               if ($Force -or $PSCmdlet.ShouldProcess("'$($w.name)' in process template '$ProcessTemplate'", "Show WorkItem state '$($s.name)'")) {
                  $url = "{0}/states/{1}?api-version={2}" -f $w.url, $s.id, (_getApiVersion Processes)
                  $null = _callAPI -Url $url -method Delete  #no result to send back

                  $sysState =  $w.states.where(({$_.Name -eq $s.name -and $_.customizationType -eq 'system' })) | Select-Object -First 1
                  $sysState.PSObject.TypeNames.Insert(0, 'vsteam_lib.WorkItemState')
                  Add-Member -InputObject $Sysstate -MemberType AliasProperty -Name WorkItemType    -Value "name"
                  Add-Member -InputObject $sysState -MemberType NoteProperty  -Name ProcessTemplate -Value $w.ProcessTemplate

                  Write-Output $sysState
               }
            }
         }
      }
   }
}
