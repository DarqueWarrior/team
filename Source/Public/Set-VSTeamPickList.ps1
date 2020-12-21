function Set-VSTeamPickList  {
   [CmdletBinding(SupportsShouldProcess=$true,ConfirmImpact='High')]
   param(
      [ArgumentCompleter([vsteam_lib.PicklistCompleter])]
      [vsteam_lib.PickListTransformAttribute()]
      [Parameter(ValueFromPipelineByPropertyName=$true, position=0)]
      [Alias('Name','ID')]
      $PicklistID,

      [object[]]$NewItems,

      [ValidateSet('double','integer','string')]
      [string]$Type ,

      [switch]$RemoveOldItems,

      [switch]$IsSuggested,

      [switch]$Force
   )
   process {
      $Picklist = Get-VSTeamPickList -PicklistID $PicklistID
      if (-not $Picklist) {
         Write-warning "'$PicklistID' does not appear to be the name of a picklist." ; return
      }
      elseif ($Picklist.count -gt 1) {
         Write-warning "'$PicklistID' gives more than one picklist." ; return
      }
      $url = "$($Picklist.url)?api-version=" + (_getApiVersion Processes)

      $body  = @{    }
      if ($PSBoundParameters.ContainsKey('IsSuggested')) {
         $body['isSuggested']  = ($IsSuggested -as [bool])
      }
      if ($Type) {
         $body['type']  =  $Type.ToLower()
      }
      if ($RemoveOldItems -and $NewItems) {
         $body['items'] =  $NewItems
      }
      elseif( $NewItems) {
         $body['items'] =  @() + $Picklist.items
         foreach ($i in $NewItems.Where({$_ -notin $Picklist.items})) {
            $body['items'] += $i
         }
      }
      if ($force -or $PSCmdlet.ShouldProcess($Picklist.Name,'Update Picklist')){
         #Call the REST API
         $resp = _callAPI -Url $url -method PUT -body (ConvertTo-Json $body)
         $resp.psobject.TypeNames.Insert(0,'vsteam_lib.PickList')

         return $resp
      }
   }
}

