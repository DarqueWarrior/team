function Add-VSTeamWorkItemState {
   [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'High')]
   param(
      [parameter(ValueFromPipelineByPropertyName = $true)]
      [vsteam_lib.ProcessTemplateValidateAttribute()]
      [ArgumentCompleter([vsteam_lib.ProcessTemplateCompleter])]
      $ProcessTemplate = $env:TEAM_PROCESS,

      [parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true, Position = 0)]
      [ArgumentCompleter([vsteam_lib.WorkItemTypeCompleter])]
      $WorkItemType,

      [parameter(Mandatory = $true, Position = 1)]
      [string]$Name,

      [ValidateSet('Proposed', 'InProgress', 'Resolved', 'Completed', 'Removed')]
      [string]$StateCategory = 'InProgress',

      [ArgumentCompleter([vsteam_lib.ColorCompleter])]
      [vsteam_lib.ColorTransformToHexAttribute()]
      [string]$Color = '7f7f7f',

      [int]$Order,

      [switch]$Force
   )
   process {

      $wit = $null
      #If $workItemtype contains an object, use it to avoid calling the API again
      if ($WorkItemType.psobject.TypeNames.Contains('vsteam_lib.WorkItemType')) {
         $wit = $WorkItemType
      }
      if (-not $wit) {$wit = Get-VSTeamWorkItemType -ProcessTemplate $ProcessTemplate -WorkItemType  $WorkItemType}
      $wit = $wit | Unlock-VSTeamWorkItemType -Force:$Force
      if (-not $wit) {
            Write-Warning "There were no suitable WorkItem types to update"; return
      }
      foreach ($w in $wit) {
         if ($Force -or $PSCmdlet.ShouldProcess("$($w.name) in process template '$($w.ProcessTemplate)'", "Add new state '$name' to WorkItem type")) {

            $url = $w.url + '/states?api-version=' + (_getApiVersion Processes)

            $body = @{
               'stateCategory' = $StateCategory
               'name'          = $Name
               'color'         = $Color
            }

            if ($PSBoundParameters.ContainsKey('Order')) {
               $body['order']  = $Order
            }

            $resp = _callAPI -Url $url -method Post -ContentType "application/json" -body (ConvertTo-Json $body)

            $resp.psobject.TypeNames.Insert(0, 'vsteam_lib.WorkItemState')
            Add-Member -InputObject $resp -MemberType NoteProperty -Name ProcessTemplate -Value $w.ProcessTemplate
            Add-Member -InputObject $resp -MemberType NoteProperty -Name WorkItemType    -Value $w.name

            Write-Output $resp
         }
      }
   }
}