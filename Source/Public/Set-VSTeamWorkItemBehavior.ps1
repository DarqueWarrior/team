function Set-VSTeamWorkItemBehavior {
   [CmdletBinding(DefaultParameterSetName='AddOrSet',SupportsShouldProcess=$true,ConfirmImpact='High')]
   param(
      [parameter(ValueFromPipelineByPropertyName=$true)]
      [vsteam_lib.ProcessTemplateValidateAttribute()]
      [ArgumentCompleter([vsteam_lib.ProcessTemplateCompleter])]
      $ProcessTemplate = $env:TEAM_PROCESS,

      [parameter(Mandatory = $true,ValueFromPipelineByPropertyName=$true, Position=0)]
      [ArgumentCompleter([vsteam_lib.WorkItemTypeCompleter])]
      [string]$WorkItemType,

      [parameter(Mandatory =$true, ParameterSetName='AddOrSet')]
      [string]$Behavior,

      [parameter(ParameterSetName='AddOrSet')]
      [switch]$IsDefault,

      [parameter(Mandatory =$true, ParameterSetName='Delete')]
      [switch]$Remove,

      [switch]$Force
   )
   process {
      foreach ($p in $ProcessTemplate) {
         #Get real backlog behaviors - skip those with a rank of 0
         if (-not $remove) {
            $processbehaviors = Get-VSTeamProcessBehavior -ProcessTemplate $p | Where-Object Rank -gt 0
            #Allow either the name or feature name
            if ($Behavior -in $processbehaviors.name) {
               $Behavior = $processbehaviors.Where({$_.name -eq $Behavior}).referencename
            }
            if ($Behavior -notin $processbehaviors.referencename) {
               Write-Warning ("$Behavior is not a valid behavior name. Possible names are '" + ($processbehaviors.name -join "', '") + "'") ; return
            }
         }
         $wit = Get-VSTeamWorkitemType -ProcessTemplate $p -WorkItemType $WorkItemType -Expand behaviors
         foreach ($w in $wit) {
            $url = ($w.url -replace '/workItemTypes/' , '/workitemtypesbehaviors/')
            if     ($Remove -and $w.behaviors.Count -eq 0  ) {Write-Warning  "Nothing to do for $($w.name)!" ; continue}
            elseif ($Remove) {
               foreach ($b in $w.behaviors) {
                  if ($force -or $PSCmdlet.ShouldProcess($w.name,'Remove behavior from WorkItem Type')) {
                     _callAPI -method Delete -Url ("$url/behaviors/{0}?api-version={1}" -f $b.behavior.id, (_getApiVersion Processes))
                  }
               }
               continue
            }
            if     ($w.behaviors.count -gt 0 -and  $w.behaviors.behavior.id -contains $Behavior) {
               Write-Warning "'$($w.name)' is already assigned to $Behavior!. To change the default, remove and re-add it." ; continue
            }
            elseif ($w.behaviors.count -gt 0 ) {
               Write-Warning ("'$($w.name)' is already assigned to $($w.behaviors.behavior.id) remove it before assigning to another type") ; continue
            }

            $params = @{
               method      = "Post"
               url         = "$url/behaviors?api-version=" + (_getApiVersion Processes)
               body        = ConvertTo-JSON @{
                  behavior  = @{id= $Behavior}
                  isDefault = $IsDefault -as [bool]
                  id        = $w.referenceName
               }
            }
            if ($Force -or $PSCmdlet.ShouldProcess($w.name,"Modify $p to update behavior of workitem type") ) {
               try   {
                  $resp = _callapi @params -ErrorAction stop
                  $r = [PSCustomObject][ordered]@{ ProcessTemplate = $p;
                                                   WorkItemType    = $w.name
                                                   Behavior        = $resp.behavior.id
                                                   IsDefault       = $resp.isdefault  }
                  $r.PSObject.TypeNames.Insert(0, 'vsteam_lib.WorkItembehavior')

                  Write-Output $r
               }
               catch { Write-Warning "$($w.name) exists, but failed to update. It may not be possible to change this type."}
            }
         }
      }
   }
}
