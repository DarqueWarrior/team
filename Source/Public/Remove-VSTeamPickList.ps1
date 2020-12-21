function Remove-VSTeamPickList  {
   [CmdletBinding(SupportsShouldProcess=$true,ConfirmImpact='High')]
   param(
      [ArgumentCompleter([vsteam_lib.PicklistCompleter])]
      [vsteam_lib.PickListTransformAttribute()]
      [Parameter(ValueFromPipelineByPropertyName=$true, position=0)]
      [Alias('Name','ID')]
      $PicklistID,

      [switch]$Force

   )
   process {
      foreach ($id in $PicklistID) {
         $Picklist = Get-VSTeamPickList -PicklistID $id
         if (-not $Picklist) {
            Write-warning "'$PicklistID' does not appear to be the name of a picklist." ; return
         }
         $url = "$($Picklist.url)?api-version=" + (_getApiVersion Processes)

         if ($force -or $PSCmdlet.ShouldProcess($Picklist.Name,'DELETE Picklist')){
               #Call the REST API
               $null = _callAPI -method Delete -Url $url
               [vsteam_lib.PickListCache]::Invalidate()
         }
      }
   }
}

