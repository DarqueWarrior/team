function Get-VSTeamWiql {
   [CmdletBinding(DefaultParameterSetName = 'ByID',
      HelpUri = 'https://methodsandpractices.github.io/vsteam-docs/docs/modules/vsteam/commands/Get-VSTeamWiql')]
   param(
      [vsteam_lib.QueryTransformToIDAttribute()]
      [ArgumentCompleter([vsteam_lib.QueryCompleter])]
      [Parameter(ParameterSetName = 'ByID', Mandatory = $true, Position = 0)]
      [string] $Id,

      [Parameter(ParameterSetName = 'ByQuery', Mandatory = $true)]
      [string] $Query,

      [string] $Team,

      [Parameter(Mandatory = $false, Position = 2)]
      [vsteam_lib.ProjectValidateAttribute($false)]
      [ArgumentCompleter([vsteam_lib.ProjectCompleter])]
      $ProjectName,

      [int] $Top = 100,
      [Switch] $TimePrecision,
      [Switch] $Expand
   )
   process {
      # build paramters for _callAPI
      $params = @{
         ProjectName = $ProjectName
         Area        = 'wit'
         Resource    = 'wiql'
         Version     = [vsteam_lib.Versions]::Core
         QueryString = @{
            '$top'        = $Top
            timePrecision = $TimePrecision
         }
      }

      if ($Query) {
         $params['body'] = @{query = $Query } | ConvertTo-Json -Depth 100
         $params['method'] = 'POST'
         $params['ContentType'] = 'application/json'
      }
      else {
         $params['id'] = $Id
      }

      if ($Team) {
         $params['Team'] = $Team
      }

      $resp = _callAPI  @params

      #expand only when at least one workitem has been found
      if ($Expand && $resp.workItems.Count -gt 0) {
         # Handle queries for work item links also allow for the tests not Setting the query result type.
         if ($resp.psobject.Properties['queryResultType'] -and $resp.queryResultType -eq 'workItemLink') {
            Add-Member -InputObject $resp -MemberType NoteProperty -Name Workitems -Value @()
            $Ids = $resp.workItemRelations.Target.id
         }
         else {
            $Ids = $resp.workItems.id
         }

         # splitting id array by 200, since a maximum of 200 ids are allowed per call
         $countIds = $Ids.Count
         $resp.workItems = for ($beginRange = 0; $beginRange -lt $countIds; $beginRange += 200) {

            $endRange = 1
            $workItemIds = @()
            #for more than one work item being found, line below would return $endrange = 0 for one woritem
            #in the accessed array it would result to $Ids[0..0] which is not valid
            if ($countIds -gt 1) {
               # in case strict mode is on,pick lesser of  0..199 and 0..count-1
               $endRange = [math]::Min(($beginRange + 199), ($countIds - 1))
               $workItemIds = $Ids[$beginRange..$endRange]
            }else {
               $workItemIds = $Ids
            }

            # if query contains "*" don't specify fields, otherwise use fields returned.
            if ($Query -match "\*") {
               Get-VSTeamWorkItem -Id $workItemIds
            }
            else {
               Get-VSTeamWorkItem -Id $workItemIds -Fields $resp.columns.referenceName
            }
         }
      }

      _applyTypesToWiql -item $resp

      return $resp
   }
}