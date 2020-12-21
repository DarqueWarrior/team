function Add-VSTeamField {
   [CmdletBinding(DefaultParameterSetName='NoPicklist',SupportsShouldProcess=$true,ConfirmImpact='High')]
   Param(
      [Parameter(Mandatory=$true,Position=0)]
      [string]$Name,

      [string]$ReferenceName,

      [ValidateSet('boolean','dateTime','double', 'html','identity','integer','string')]
      [string]$Type = 'string',

      [ValidateSet('workItem','workItemLink','workItemTypeExtension','tree','none')]
      $Usage='workItem',

      [string]$Description,

      [ArgumentCompleter([vsteam_lib.PicklistCompleter])]
      [vsteam_lib.PickListTransformAttribute()]
      [Parameter(ValueFromPipelineByPropertyName=$true, ParameterSetName='WithPickList',Mandatory=$true )]
      $PicklistID,

      [Parameter(ParameterSetName='WithPickList')]
      [switch]$IsPickListSuggested,

      [switch]$NoSort,

      [switch]$NotQueryable,

      [switch]$ReadOnly,

      [switch]$Force
   )
   process {
      $body =  @{'name'     = $Name
               'type'     = $Type.ToLower()
               'usage'    = $usage.ToLower()
               'readOnly' = $ReadOnly -as [bool] }
      if ($PSBoundParameters.ContainsKey('PicklistID') ) {
         if ($PicklistID.psobject.members.name -contains "id") {$PicklistID=$PicklistID.id}
         if ($PicklistID  -notmatch "[0-9A-F]{8}-([0-9A-F]{4}-){3}[0-9A-F]{12}"  ) {
            Write-Warning "$PicklistID does not appear to be a valid picklist" ; return
         }
         if ($PicklistID -is [array]) {
               $body['picklistId']    = $PicklistID[0]
         }
         else {$body['picklistId']    = $PicklistID}
         $body['isPicklist']          = $true
         $body['isPicklistSuggested'] = $IsPickListSuggested -as [bool]
      }
      if ($PSBoundParameters.ContainsKey('Description')) {
            $body['description'] = $Description

      }
      if ($PSBoundParameters.ContainsKey('ReferenceName')) {
            $body['referenceName'] = $ReferenceName
      }
      if ($PSBoundParameters.ContainsKey('NotQueryable')) {
            $body['isQueryable'] = -not $NotQueryable
      }
      if ($PSBoundParameters.ContainsKey('NoSort') ) {
            $body['canSortBy'] = -not  $NoSort
      }
      $apiParams = @{
            method      = 'Post'
            area        = 'wit'
            resource    = 'fields'
            version     = _getApiVersion Processes
            body        = ConvertTo-Json $body
      }
      if ($Force -or $PSCmdlet.ShouldProcess($Name,'Add field') ) {
         #call the REST API
         $resp = _callAPI @apiParams

         $resp.psobject.TypeNames.Insert(0,'vsteam_lib.Field')
         [vsteam_lib.FieldCache]::Invalidate()

         return $resp
      }
   }
}
