function Remove-VSTeamWorkItemField {
   [CmdletBinding(SupportsShouldProcess=$True,ConfirmImpact='High')]
   param(
      [parameter(ValueFromPipelineByPropertyName=$true)]
      [vsteam_lib.ProcessTemplateValidateAttribute()]
      [ArgumentCompleter([vsteam_lib.ProcessTemplateCompleter])]
      $ProcessTemplate = $env:TEAM_PROCESS,

      [parameter(Mandatory = $true,ValueFromPipelineByPropertyName=$true, Position=0)]
      [ArgumentCompleter([vsteam_lib.WorkItemTypeCompleter])]
      $WorkItemType,

      [parameter(Mandatory = $true,ValueFromPipelineByPropertyName=$true)]
      [ArgumentCompleter([vsteam_lib.FieldCompleter])]
      [vsteam_lib.FieldTransformAttribute()]
      [Alias('Name','FieldName')]
      $referenceName

   )
   process {
      if ($WorkItemType.psobject.TypeNames.Contains('vsteam_lib.WorkItemType')) {
            $wit= $WorkItemType
      }
      else {$wit = Get-VSTeamWorkItemType -ProcessTemplate $ProcessTemplate -WorkItemType $WorkItemType}
      foreach ($w in $wit) {
         foreach ($r in $ReferenceName) {
            if ($r.psobject.Properties["referenceName"]) {
                $r = $r.referenceName
            }
            $url = '{0}/fields/{1}?api-version={2}' -f $w.url, $r,  (_getApiVersion Processes)
            if ($Force -or $PSCmdlet.ShouldProcess($WorkItemType, "Remove field '$r' from WorkItem type" )) {
               #Call the REST API
               try {
                  $null = _callAPI -Url $url -method Delete -body (ConvertTo-Json $body)
               }
               catch {
                  $msg = "Failed to update Delete '{0}' from Workitem type '{1}' in {2}" -f
                           $field.name, $wit.name, $ProcessTemplate
                  Write-error -Activity Remove-VSTeamWorkItemField  -Category InvalidResult -Message $msg
                  continue
               }
            }
         }
      }
   }
}
