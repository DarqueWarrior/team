function Get-VSTeamField {
   [CmdletBinding()]
   param(
      [Parameter(ValueFromPipeline=$true,Position=0)]
      [ArgumentCompleter([vsteam_lib.FieldCompleter])]
      [vsteam_lib.FieldTransformAttribute()]
      [Alias('Name')]
      $ReferenceName = "*"
   )
   process {
      $resp = @()
      foreach ($r in $ReferenceName){
         if ($r.psobject.Members.Name -contains "ReferenceName") {
               $r = $r.ReferenceName
         }
         if ($r -match '\w\.\w' -and $r -notmatch '\*|\?') {
            $resp +=  _callAPI -area wit -resource fields -id $r
         }
         else {
            $resp += _callAPI -area wit -resource fields | Select-Object -ExpandProperty value |
               Where-object { $_.name -like $r -or $_.ReferenceName -like $r}
         }
      }

      foreach ($r in $resp) {
            # Apply a Type Name so we can use custom format view and/or custom type extensions
            # and add members to make it easier if piped into something which takes values by property name
            $r.psobject.TypeNames.Insert(0,'vsteam_lib.Field')
      }

      return $resp
   }
}
