function Set-VSTeamWorkItemType {
   [CmdletBinding(DefaultParameterSetName='LeaveAlone',SupportsShouldProcess=$true,ConfirmImpact='High')]
   param(
      [parameter(ValueFromPipelineByPropertyName=$true)]
      [vsteam_lib.ProcessTemplateValidateAttribute()]
      [ArgumentCompleter([vsteam_lib.ProcessTemplateCompleter])]
      $ProcessTemplate = $env:TEAM_PROCESS,

      [parameter(Mandatory = $true,ValueFromPipelineByPropertyName=$true, Position=0)]
      [ArgumentCompleter([vsteam_lib.WorkItemTypeCompleter])]
      [Alias('Name')]
      $WorkItemType,

      [string] $Description,

      [ArgumentCompleter([vsteam_lib.ColorCompleter])]
      [vsteam_lib.ColorTransformToHexAttribute()]
      $Color,

      [vsteam_lib.IconTransformAttribute()]
      [ArgumentCompleter([vsteam_lib.IconCompleter])]
      [string]$Icon ,

      [parameter(ParameterSetName='Hide', Mandatory = $true)]
      [switch]$Disabled,
      [parameter(ParameterSetName='Show', Mandatory = $true)]
      [switch]$Enabled,

      [switch]$Force
   )
   process {
      $wit = $null
      #If $workItemtype contains an object, use it. Otherwise get matching ones.
      if ($WorkItemType.psobject.TypeNames.Contains('vsteam_lib.WorkItemType')) {
         $wit = $WorkItemType
      }
      else {
         $wit = Get-VSTeamWorkItemType -ProcessTemplate $ProcessTemplate -WorkItemType $WorkItemType
      }
      #Bail out if we found no type, or we can't change system types to inherited ones.
      $wit = $wit | Unlock-VSTeamWorkItemType -Force:$Force
      if (-not $wit) {Write-Warning "There are no suitable Workitem types to update." ; return}
      foreach ($w in $wit)   {
         $url  = $w.url + "?api-version=" + (_getApiVersion Processes)

         #region set up the contents to go in the JSON body
         $body = @{} #note. "Changing" some options to their current value has caused errors but those below seem OK...
         if ($Icon -and $Icon -ne $w.icon) {
                  $body['icon']        = $Icon
         }
         else {   $body['icon']        = $w.icon}

         if ($Color -match '^[\da-f]{6}$' -and $color -ne $w.color) {
                  $body['color']       = $Color
         }
         else {   $body['color']       = $w.color}

         if ($Description -and $Description -ne $w.description) {
                  $body['description'] = $Description
         }
         else {   $body['description'] = $w.description }

         if ($Disabled -and -not $w.isDisabled) {
                  $body['isDisabled']  = $true
         }
         elseif($Enabled    -and $w.isDisabled) {
                  $body['isDisabled']  = $false }
         else {   $body['isDisabled']  = $w.isDisabled }
         #endregion

         if ($Force -or $PSCmdlet.ShouldProcess($w.Name,"Modify $ProcessTemplate, to update definition of workitem type") ) {
            #Call the REST API - don't stop if one item in a long list fails.
            try   {
               $resp = _callapi -Url $url -method  Patch  -ContentType "application/json" -body (ConvertTo-Json $body) -ErrorAction stop
            }
            catch { Write-Warning "Failed to update $($w.name) in $($w.processTemplate). It may not be possible to change this type." ; continue}

            # Apply a Type Name so we can use custom format view and/or custom type extensions and
            # add workitemType & processTemplate properties (which become a parameters when the object is piped into other functions).
            _applyTypesWorkItemType -item $resp
            Add-Member -InputObject $resp -MemberType AliasProperty -Name WorkItemType    -Value "name"
            Add-Member -InputObject $resp -MemberType NoteProperty  -Name ProcessTemplate -Value $w.ProcessTemplate

            Write-Output $resp
         }
      }
   }
}
