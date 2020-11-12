
function Hide-VsteamWorkItemState {
   [CmdletBinding(SupportsShouldProcess=$true,ConfirmImpact='High')]
   param(
      [parameter(ValueFromPipelineByPropertyName=$true)]
      [vsteam_lib.ProcessTemplateValidateAttribute()]
      [ArgumentCompleter([vsteam_lib.ProcessTemplateCompleter])]
      $ProcessTemplate = $env:TEAM_PROCESS,

      [parameter(Mandatory = $true,ValueFromPipelineByPropertyName=$true, Position=0)]
      [ArgumentCompleter([vsteam_lib.WorkItemTypeCompleter])]
      $WorkItemType,

      [Parameter(ValueFromPipeline=$true,Mandatory=$true,ValueFromPipelineByPropertyName=$true,position=0)]
      $Name,

      [Switch]$Force
   )
   process {
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
      #Filter matching types to only those with a matching state - and ensure they are unlocked

      $wit = $wit | Where-Object {foreach ($n in $name) {if ($_.states.where({$_.name -like $n -and $_.customizationType -eq 'system'})) {$true} }} |
                     Unlock-VSTeamWorkItemType -Force:$Force -Expand states
      if (-not $wit) {Write-Warning "Found no suitable WorkItem Types with a system state matching '$name'." ; return}
      foreach ($w in $wit){
         foreach ($n in $Name) {
            $state = $w.states| Where-Object {$_.Name -like $n -and $_.customizationType -eq 'system'}
            foreach ($s in $state) {
               # Hidden states have a second version to "hide behind" so check that doesn't exist for each found state
               if ($resp.states| Where-Object {$_.Name -eq $s.Name -and $_.hidden}) {
                  Write-Warning "'$($s.name)' is already hidden for the WorkItem type '$($w.name)'."
               }
               elseif ($Force -or $PSCmdlet.ShouldProcess("'$($w.name)' in process template '$ProcessTemplate'", "Hide WorkItem state '$($s.name)'")) {
                  $url  = "{0}/states/{1}?api-version={2}" -f $w.url, $s.id, (_getApiVersion Processes)
                  #Call the rest API
                  $resp = _callAPI -method Put -Url $url -body '{"hidden":true}'

                  # Apply a Type Name so we can use custom format view and/or custom type extensions
                  #and members so it pipes nicely into other functions
                  $resp.psobject.TypeNames.Insert(0,'vsteam_lib.WorkItemState')
                  Add-Member -InputObject $resp -MemberType NoteProperty -Name ProcessTemplate -Value $w.ProcessTemplate
                  Add-Member -InputObject $resp -MemberType NoteProperty -Name WorkItemType    -Value $w.name

                  Write-Output $resp
               }
            }
         }
      }
   }
}
