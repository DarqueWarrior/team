
function Get-VSTeamWorkItemBehavior {
   [CmdletBinding()]
   param (
      [Parameter( ValueFromPipelineByPropertyName=$true)]
      [vsteam_lib.ProcessTemplateValidateAttribute()]
      [ArgumentCompleter([vsteam_lib.ProcessTemplateCompleter])]
      $ProcessTemplate = $env:TEAM_PROCESS,

      [parameter(Mandatory = $true,ValueFromPipelineByPropertyName=$true, Position=1 )]
      [ArgumentCompleter([vsteam_lib.WorkItemTypeCompleter])]
      [string]$WorkItemType
   )
   process {
      $expandedItemTypes = Get-VSTeamWorkItemType -ProcessTemplate $ProcessTemplate -WorkItemType $WorkItemType -Expand Behaviors
      foreach ($wit in $expandedItemTypes) {
         $behaviors = $wit.behaviors
         if (-not $behaviors) {Write-Warning "$($wit.name) has no behaviors." }
         else { 
            foreach ($b in $behaviors) {
               $b.psobject.TypeNames.Insert(0,'vsteam_lib.WorkItembehavior')
               Add-Member -InputObject $b -MemberType ScriptProperty -Name BehaviorID      -Value {$this.behavior.id}
               Add-Member -InputObject $b -MemberType NoteProperty   -Name WorkItemType    -Value $wit.name
               Add-Member -InputObject $b -MemberType NoteProperty   -Name ProcessTemplate -Value $ProcessTemplate 
            }

            Write-Output $behaviors
        }
      }
   }
}