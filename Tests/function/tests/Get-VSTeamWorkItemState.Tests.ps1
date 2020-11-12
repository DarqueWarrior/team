Set-StrictMode -Version Latest

Describe 'VSTeamWorkItemState' {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath
      . "$PSScriptRoot\..\..\..\Source\Public\Get-VSTeamProcess.ps1"
      . "$PSScriptRoot\..\..\..\Source\Public\Get-VSTeamWorkItemType.ps1"
      ## Arrange
      # Set the account to use for testing. A normal user would do this
      # using the Set-VSTeamAccount function.
      [vsteam_lib.Versions]::Account = 'https://dev.azure.com/test'
      Mock _getApiVersion     { return '1.0-unitTests' } -ParameterFilter { $Service -eq 'Processes' }
      Mock _getDefaultProject { return "MockProject"}
   }

   Context 'Get-VSTeamWorkItemState' {
      BeforeAll {
         ## Arrange
         Mock Get-VSTeamWorkItemType { Open-SampleFile 'bug.json'| add-member -NotePropertyName "ProcessTemplate" -NotePropertyValue "Scrum" -PassThru}
         Mock Get-VSTeamProcess { return @(
              [PSCustomObject]@{
                  Name = "Scrum"
                  URL  = "https://dummy.none/_apis/work/processes/6b724908-ef14-45cf-84f8-768b5384da45"
               }
            )
         }
         [vsteam_lib.ProcessTemplateCache]::Invalidate()
      }

      It 'should get states and add WorkItem type and ProcessTemplate to them' {
         ## Act
         $states = Get-VSTeamWorkItemState -WorkItemType bug -ProcessTemplate Scrum

         ## Assert
         Should -Invoke Get-VSTeamWorkItemType -Scope It -ParameterFilter {$Expand -eq 'States'} -Times 1 -Exactly
         $states.count                 | Should -Be 4
         $states[0].psobject.Typenames | Should -Contain 'vsteam_lib.WorkItemState'
         $states[0].ProcessTemplate    | Should -Be      'Scrum'
         $states[0].WorkItemType       | Should -Be      'Bug'
      }
   }

   AfterAll {
         [vsteam_lib.Versions]::Account = ""
   }

}