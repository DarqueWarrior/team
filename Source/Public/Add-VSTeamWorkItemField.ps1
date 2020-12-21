function Add-VSTeamWorkItemField {
   [CmdletBinding(SupportsShouldProcess=$true,ConfirmImpact='High')]
   param(
      [parameter(ValueFromPipelineByPropertyName=$true)]
      [ArgumentCompleter([vsteam_lib.ProcessTemplateCompleter])]
      $ProcessTemplate = $env:TEAM_PROCESS,

      [parameter(Mandatory = $true,ValueFromPipelineByPropertyName=$true, Position=0)]
      [ArgumentCompleter([vsteam_lib.WorkItemTypeCompleter])]
      $WorkItemType,

      [parameter(Mandatory = $true)]
      [ArgumentCompleter([vsteam_lib.FieldCompleter])]
      [vsteam_lib.FieldTransformAttribute()]
      [Alias('Name','FieldName')]
      $ReferenceName,

      [string]$DefaultValue,
      [switch]$AllowGroups,
      [switch]$ReadOnly,
      [switch]$Required,
      [switch]$Force
   )
   process {
      #Get the workitem type(s) we are updating. We get a system one, make it an inherited one
      if ($WorkItemType.psobject.TypeNames.Contains('vsteam_lib.WorkItemType')) {
         $wit= $WorkItemType
      }
      else {$wit = Get-VSTeamWorkItemType -ProcessTemplate $ProcessTemplate -WorkItemType $WorkItemType}
      $wit = $wit | Unlock-VsteamWorkItemType -Force:$Force
      foreach ($w in $wit) {
         $url = $w.url +"/fields?api-version=" + (_getApiVersion Processes)
         foreach ($r in $ReferenceName) {
            $field   = Get-VSTeamField -ReferenceName $r
            $body    =  @{
                  referenceName = $field.referenceName
                  defaultValue  = $DefaultValue
                  allowGroups   = $AllowGroups -as [bool]
                  required      = $Required    -as [bool]
                  readOnly      = $ReadOnly    -as [bool]
            }
            if ($field.type -eq "boolean") {
               $body.required = $true
               $body.defaultValue = "false" #yes a string!
            }
            if ($Force -or $PSCmdlet.ShouldProcess($WorkItemType, "Add field '$($field.name)' to WorkItem type" )) {
               #Call the REST API
               try {
                  $resp = _callAPI -Url $url -method Post -body (ConvertTo-Json $body)
               }
               catch {
                  $msg = "Failed to Add '{0}' to WorkItem type '{1}' in {2}" -f
                           $field.name, $wit.name, $wit.processTemplate
                  Write-error -Activity Add-VSTeamWorkItemField  -Category InvalidResult -Message $msg
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
