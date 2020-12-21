function Get-VSTeamWorkItemField {
   [CmdletBinding()]
   param(
      [parameter(ValueFromPipelineByPropertyName=$true)]
      [vsteam_lib.ProcessTemplateValidateAttribute()]
      [ArgumentCompleter([vsteam_lib.ProcessTemplateCompleter])]
      $ProcessTemplate = $env:TEAM_PROCESS,

      [parameter(Mandatory = $true,ValueFromPipelineByPropertyName=$true, Position=0)]
      [ArgumentCompleter([vsteam_lib.WorkItemTypeCompleter])]
      $WorkItemType,

      [parameter(Position=1)]
      [ArgumentCompleter([vsteam_lib.FieldCompleter])]
      [vsteam_lib.FieldTransformAttribute()]
      [Alias('Name','FieldName')]
      $ReferenceName = '*'

   )
   process {
      if ($WorkItemType.psobject.TypeNames.Contains('vsteam_lib.WorkItemType')) {
         $wit= $WorkItemType
      }
      else {$wit = Get-VSTeamWorkItemType -ProcessTemplate $ProcessTemplate -WorkItemType $WorkItemType}
      foreach ($w in $wit)    {
         #no expand option, so have to  Call the REST API to get the fields
         #Call with referencename if it looks like a valid name, or without if it looks like a wildcard.
         if ($ReferenceName.psobject.Properties["referenceName"]) {
            $ReferenceName = $ReferenceName.referenceName
         }
         if ($ReferenceName -match '\w\.\w' -and $ReferenceName-notmatch '\*|\?') {
            $url = '{0}/fields/{1}?$expand=1&api-version={2}' -f $w.url, $ReferenceName, (_getApiVersion Processes)
            try {
               $resp = _callAPI -Url $url
            }
            catch {
               $msg = $_.ErrorDetails.Message
               #This is the message code for "field does not exist"
               if ($msg -notmatch "VS402645") {
                  Write-error -Activity Get-VSTeamWorkItemField  -Category InvalidResult -Message $msg
               }
               Continue
            }
         }
         else {
            $url = $w.url + '/fields?$expand=1&api-version=' + (_getApiVersion Processes)
            $resp = _callAPI -Url $url | Select-Object -ExpandProperty value |
               Where-object { $_.name -like $ReferenceName -or $_.ReferenceName -like $ReferenceName}
         }
         foreach ($r in $resp) {
            # Apply a Type Name so we can use custom format view and/or custom type extensions
            # and add members to make it easier if piped into something which takes values by property name
            $r.psobject.TypeNames.Insert(0,'vsteam_lib.WorkitemField')
            Add-Member -InputObject $r -MemberType NoteProperty -Name WorkItemType    -Value $w.name
            Add-Member -InputObject $r -MemberType NoteProperty  -Name ProcessTemplate -value $w.processTemplate

            Write-Output $r
         }
      }
   }
}
