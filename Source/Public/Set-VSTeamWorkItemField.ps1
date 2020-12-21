function Set-VSTeamWorkItemField {
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
      $referenceName,

      [string[]]$AllowedValues,
      [string]$DefaultValue,
      [switch]$AllowGroups,
      [switch]$ReadOnly,
      [switch]$Required,
      [switch]$Force
   )
   process {
      if ($WorkItemType.psobject.TypeNames.Contains('vsteam_lib.WorkItemType')) {
            $wit= $WorkItemType
      }
      else {$wit = Get-VSTeamWorkItemType -ProcessTemplate $ProcessTemplate -WorkItemType $WorkItemType}
      $wit = $wit | Unlock-VSTeamWorkItemType -Force:$Force
      foreach ($w in $wit) {
         foreach ($r in $ReferenceName) {
            $field = Get-VSTeamWorkItemField -ProcessTemplate $ProcessTemplate -WorkItemType $wit -ReferenceName $r
            $url = '{0}/fields/{1}?api-version={2}' -f $w.url, $field.ReferenceName,  (_getApiVersion Processes)
            $body    =  @{
               referenceName = $field.referenceName
               name = $field.Name
            }
            if ($PSBoundParameters.ContainsKey('required')) {
                  $body['required']      = $Required    -as [bool]
            }
            else {$body['required']      = $field.required}
            if ($PSBoundParameters.ContainsKey('AllowedValues')) {
                  $body['allowedValues']  =  @()+ $AllowedValues
            }
            else {$body['allowedValues']  = $field.allowedValues}
            if ($PSBoundParameters.ContainsKey('$DefaultValue')) {
                  $body['defaultValue']  = $DefaultValue
            }
            elseif ($field.psobject.properties['defaultValue']) {
               $body['defaultValue']  = $field.defaultValue
            }

            if ($PSBoundParameters.ContainsKey('allowGroups')) {
                  $body['allowGroups']   = $AllowGroups -as [bool]
             }
            elseif ($field.psobject.properties['allowGroups']) {
                  $body['allowGroups']   = $field.allow -as [bool]
            }

            if ($PSBoundParameters.ContainsKey('readOnly')) {
                  $body['readOnly']      = $ReadOnly    -as [bool]
            }
            elseif ($field.psobject.properties['readOnly']) {
                  $body['readOnly']   = $field.readOnly
            }

            if ($Force -or $PSCmdlet.ShouldProcess($field.name, "In WorkItem type '$($w.name)' modify field" )) {
               #Call the REST API
               try {
                  $resp = _callAPI -Url $url -method Patch -body (ConvertTo-Json $body)
               }
               catch {
                  $msg = "Failed to update field '{0}' of Workitem '1' in {2}" -f
                           $field.name, $wit.name, $ProcessTemplate
                  Write-error -Activity Get-VSTeamWorkItemField  -Category InvalidResult -Message $msg
                  continue
               }
               # Apply a Type Name so we can use custom format view and/or custom type extensions
               # and add members to make it easier if piped into something which takes values by property name
               $resp.psobject.TypeNames.Insert(0,'vsteam_lib.WorkitemField')
               Add-Member -InputObject $resp -MemberType NoteProperty  -Name WorkItemType    -Value $w.name
               Add-Member -InputObject $resp -MemberType NoteProperty  -Name ProcessTemplate -value $w.processTemplate

               Write-Output $resp
            }
         }
      }
   }
}
