function Get-VSTeamWorkItemType {
   [CmdletBinding(DefaultParameterSetName = 'List',
    HelpUri='https://methodsandpractices.github.io/vsteam-docs/docs/modules/vsteam/commands/Get-VSTeamWorkItemType')]
   param(
      [Parameter(ParameterSetName = 'List',  Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [parameter(ParameterSetName='Process', Mandatory = $false)]
      [vsteam_lib.ProjectValidateAttribute($false)]
      [ArgumentCompleter([vsteam_lib.ProjectCompleter])]
      [string] $ProjectName,

      [parameter(ParameterSetName='Process' , ValueFromPipelineByPropertyName = $true)]
      [vsteam_lib.ProcessTemplateValidateAttribute()]
      [ArgumentCompleter([vsteam_lib.ProcessTemplateCompleter])]
      $ProcessTemplate = $env:TEAM_PROCESS,

      [Parameter(Position=0, ValueFromPipelineByPropertyName = $true)]
      [ArgumentCompleter([vsteam_lib.WorkItemTypeCompleter])]
      [string[]] $WorkItemType = '*',

      [parameter(ParameterSetName='Process',ValueFromPipelineByPropertyName=$true)]
      [ValidateSet('behaviors','layout','states')]
      [string[]]$Expand,

      [Parameter(ParameterSetName = 'List')]
      [switch]$NotHidden
   )

   process {
      <# Call the REST API in one of 2 ways;
        if processTemplate  was passed as a parameter (not populated as a default),
        then call as work/processes/workitemtypes (this API doesn't take a workitem ID & returns multiple values)
        otherwise call as wit/workitemtypes  (JSON needs special conversion & contains mutliple  values)
        DON'T validate the $workitemType and call with wit/workitemtypes/WorkItemTypeName -
        instead allow wildcards and filter down the results. The workitem(s) will be in $resp after the IF / ELSE
      #>
      $commonArgs = @{
         ProjectName = $ProjectName
         Area        = 'wit'
         Resource    = 'workitemtypes'
         Version     = $(_getApiVersion Core)
      }
      if (-not $PSBoundParameters.ContainsKey("ProcessTemplate") -and -not $Expand) {
         $resp = _callAPI @commonArgs

         # This call returns JSON with "": which causes the ConvertFrom-Json to fail.
         # To replace all the "": with "_end":
         $resp = $resp.Replace('"":', '"_end":') | ConvertFrom-Json | Select-Object -ExpandProperty Value

         #Find Workitem-Types that are hidden in this project
         #(they may be visible in others using the same process template)
         $commonArgs.Resource = 'workitemtypecategories'
         $resp2  = _callAPI @commonArgs
         if (-not $resp2) {$hidden = @() }
         else             {$hidden = $resp2.value.where({$_.referencename -eq "Microsoft.HiddenCategory"}).workitemtypes.name}

         #Add a property named "hidden" to workitem types, so we can filter pick-lists to visible itmes only later.
         foreach ($item in $resp) {
            Add-Member -InputObject $item  -MemberType NoteProperty -Name "Hidden" -Value ($item.name -in $hidden)
         }
         if ($NotHidden.IsPresent) {
            $result = $resp | Where-Object -not Hidden
         }
         else {
            $result = $resp
         }
         if ($ProjectName -eq $env:TEAM_PROJECT -and $env:TEAM_PROCESS) {$ProcessTemplate = $env:TEAM_PROCESS}
         if ($ProcessTemplate) {
            $result | Add-Member -MemberType NoteProperty  -Name "ProcessTemplate" -Value $ProcessTemplate
         }
      }
      else {
         $result = @()
         foreach ($pt in $ProcessTemplate) {
            $url = _getProcessTemplateUrl $pt
            if (-not $url) {Write-Warning "Could not find the Process for '$pt" ; continuye}
            else           { $url += "/workitemtypes?api-version=" + (_getApiVersion Processes)}
            if ($Expand) { $resp = _callAPI -Url $url -QueryString @{'$expand' = ($Expand -Join ',').ToLower() }    }
            else         { $resp = _callapi -Url $url }
            $resp.value | Add-Member -MemberType NoteProperty  -Name "ProcessTemplate" -Value $pt
            $result += $resp.value
         }
      }
      <# Apply a Type Name so we can use custom format view and custom type extensions
         add an alias so that workitemType can become a parameter when the object is piped into other functions
         and the processTemplate name (if there is one) for the same reason.
         And finally return the items, filtered to any name we given
      #>
      foreach ($item in $result) {
         _applyTypesWorkItemType -item $item
         Add-Member    -InputObject $item -MemberType AliasProperty -Name "WorkItemType"    -Value "name"
      }
      #Allow the $WorkItemType to contain wild cards AND multiple items, by converting to regex
      $regex = "^" + ($WorkItemType -replace '\*','.*' -replace '\?','.' -join '$|^') + '$'
      return ($result | Where-Object -Property Name -match $regex)
   }
}