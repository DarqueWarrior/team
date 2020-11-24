function Remove-VSTeamWorkItemType {
   [CmdletBinding(DefaultParameterSetName='LeaveAlone',SupportsShouldProcess=$true,ConfirmImpact='High')]
   param(
      [parameter(Mandatory = $true,ValueFromPipelineByPropertyName=$true)]
      [vsteam_lib.ProcessTemplateValidateAttribute()]
      [ArgumentCompleter([vsteam_lib.ProcessTemplateCompleter])]
      $ProcessTemplate,

      [parameter(Mandatory = $true,ValueFromPipelineByPropertyName=$true,Position=0)]
      [ArgumentCompleter([vsteam_lib.WorkItemTypeCompleter])]
      [Alias('Name')]
      $WorkItemType,

      [switch]$Force
   )
   process {
      #Get the existing workitem-type definition. Drop out if can't be found or if it is a system type
      $wit  = Get-VSTeamWorkItemType -ProcessTemplate $ProcessTemplate -WorkItemType $WorkItemType |
               Where-Object -Property customization -NE 'System'
      if (-not $wit) {Write-Warning "'$workitemType' does not match a user defined Workitem type." ; return}

      foreach ($w in $wit) {
         $url  = "$($w.url)?api-version=" + (_getApiVersion Processes)
         if ($Force -or $PSCmdlet.ShouldProcess($w.name,"Modify $ProcessTemplate : delete definition of Workitem type.") ) {
            # Call the rest API - nothing to return, if this is the current process invalidate the cache of WorkItemTypeNames.
            $null =  _callapi -Url $url -method  Delete

            if ($env:TEAM_PROCESS -eq $ProcessTemplate) {[vsteam_lib.WorkItemTypeCache]::Invalidate()}
         }
      }
   }
}