function Get-VsteamWorkItemState {
   [CmdletBinding()]
   param(
      [parameter(ValueFromPipelineByPropertyName=$true)]
      [vsteam_lib.ProcessTemplateValidateAttribute()]
      [ArgumentCompleter([vsteam_lib.ProcessTemplateCompleter])]
      $ProcessTemplate = $env:TEAM_PROCESS,

      [parameter(Mandatory = $true,ValueFromPipelineByPropertyName=$true, Position=1)]
      [ArgumentCompleter([vsteam_lib.WorkItemTypeCompleter])]
      $WorkItemType
   )
   process {
      $wit = $null
      #If $workItemtype contains an object, use it if it was expanded to avoid calling the API again
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
      foreach ($w in $wit) {
         $resp = $w.States | Sort-Object -Property Order
         foreach ($r in $resp) {
            $r.psobject.TypeNames.Insert(0,'vsteam_lib.WorkItemState')
            Add-Member -InputObject $r -MemberType NoteProperty -Name ProcessTemplate -Value $w.ProcessTemplate
            Add-Member -InputObject $r -MemberType NoteProperty -Name WorkItemType    -Value $w.name
         }
         Write-Output $resp
      }
   }
}
