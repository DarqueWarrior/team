Set-StrictMode -Version Latest

Describe 'VSTeamWorkItemField' {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath
      . "$PSScriptRoot\..\..\..\Source\Public\Get-VSTeamWorkItemType.ps1"

      ## Arrange
      # Set the account to use for testing.
      # A normal user would do this using the Set-VSTeamAccount function.
      [vsteam_lib.Versions]::Account = 'https://dev.azure.com/test'
      Mock _getApiVersion { return '1.0-unitTests' }

      # Prime the process cache with an empty list,
      # So any name will be validated without calling Get-VSTeamProcess
      [vsteam_lib.ProcessTemplateCache]::Update([string[]]@(), 120)


      Mock Get-VSTeamWorkItemType  {
         $wits = Open-SampleFile "BugAndChangeReqLayout.json"
            if ($WorkItemType) { return $wits.where( { $_.name -like $WorkItemType }) }
            else               { return $wits }
      }
      Mock _callApi { return ([pscustomobject]@{Value=@([pscustomobject]@{name='History'},[pscustomobject]@{name='State'})})}
   }

   Context 'Get-VSTeamWorkItemField' {

      It 'should call the correct API and add the correct properties to returned objects' {
         ## Act
        $wif = Get-VSTeamWorkItemField -WorkItemType bug -ProcessTemplate Scrum5

         ## Assert
         Should -Invoke _callApi -Exactly -Scope It -Times 1 -ParameterFilter {
            $url -match '^http.*\.Bug/fields\?\$expand=1&api-version'
         }
         $wif.count | should -BeGreaterThan 1
         $wif[0].psobject.TypeNames| should -contain 'vsteam_lib.WorkitemField'
         $wif[0].WorkItemType      | should -BeExactly 'Bug'
         $wif[0].ProcessTemplate   | should -BeExactly 'Scrum5'
      }
   }
}