function Add-VSTeamPickList  {
   [CmdletBinding(SupportsShouldProcess=$true,ConfirmImpact='High')]
   param(
      [Parameter(Mandatory=$true,Position=0)]
      [string]$Name ,

      [Parameter(Mandatory=$true,Position=1)]
      [object[]]$Items,

      [ValidateSet('integer','string')]
      [string]$Type = 'string',

      [switch]$IsSuggested,

      [switch]$Force
   )

$apiParams = @{
  method     = 'Post'
  area       = 'Work'
  resource   = 'processes/lists'
  version    = _getApiVersion Processes
  ContentType =  "application/json"
  body        = ConvertTo-Json @{
                  name        = $Name
                  isSuggested = ($IsSuggested -as [bool])
                  type        = $Type.ToLower()
                  items       = $items
   }
}
   if ($force -or $PSCmdlet.ShouldProcess($Name,'Create new Picklist')) {
      #Call the REST API
      $resp = _callAPI @apiParams
      [vsteam_lib.PicklistCache]::Invalidate()
      # Apply a Type Name so we can use custom format view and/or custom type extensions
      $resp.psobject.TypeNames.Insert(0,'vsteam_lib.PickList')

      return $resp
   }
}
