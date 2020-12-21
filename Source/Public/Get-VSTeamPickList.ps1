function Get-VSTeamPickList{
   [CmdletBinding()]
   param (
      [ArgumentCompleter([vsteam_lib.PicklistCompleter])]
      [vsteam_lib.PickListTransformAttribute()]
      [Parameter(ValueFromPipeline=$true, position=0)]
      [Alias('Name','ID')]
      $PicklistID = "*"
   )
   begin   {
      $resp = @()
   }
   process {
      foreach ($p in $PicklistID) {
         #if we got an object, use its ID. If we got a name (not a wildcard) tranform it to an ID
         if ($p.psobject.Properties['id']) {
               $p = $p.id
         }
         if ($p -notmatch "\?|\*") {
            try {
               $resp += _callAPI -NoProject -area "work" -resource 'processes/lists' -id $P
            }
            catch {
               Write-error -Activity Get-VSTeamPickList -Category InvalidResult -Message "failure deleting picklist with ID $p."
            }
         }
        else {
            $resp += (_callAPI -NoProject -area "work" -resource 'processes/lists').value |
                  Where-Object Name -like $p
         }
      }
   }
   end {
      foreach ($r in $resp) {
         $r.psobject.TypeNames.Insert(0,'vsteam_lib.PickList')
      }

      return $resp
   }
}
