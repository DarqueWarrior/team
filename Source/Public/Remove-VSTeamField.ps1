function Remove-VSTeamField {
   [CmdletBinding(SupportsShouldProcess=$true,ConfirmImpact='High')]
   param(
      [Parameter(ValueFromPipeline=$true,Position=0,Mandatory=$true)]
      [ArgumentCompleter([vsteam_lib.FieldCompleter])]
      [vsteam_lib.FieldTransformAttribute()]
      [Alias('Name')]
      $ReferenceName,

      [switch]$Force
   )
   process {
      foreach ($r in $ReferenceName){
         if ($r.psobject.Members.Name -contains "ReferenceName") {
               $r = $r.ReferenceName
         }
         if ($force -or $PSCmdlet.ShouldProcess($r,"DELETE Field")) {
            $null =  _callAPI -method Delete  -area wit -resource fields -id $r -version (_getApiVersion Processes)
            [vsteam_lib.FieldCache]::Invalidate()
         }
      }
   }
}
