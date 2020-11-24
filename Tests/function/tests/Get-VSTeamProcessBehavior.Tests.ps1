Set-StrictMode -Version Latest

Describe 'VSTeamProcessBehavior' {
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

   Context 'Get-VSTeamProcessBehavior' {
      BeforeAll {
         ## Arrange
         Mock Get-VSTeamWorkItemType { Open-SampleFile 'workitemsWithBehaviors.json'   }
         Mock _callAPi {Open-SampleFile 'processesBehaviors.json'  }
         Mock Get-VSTeamProcess { return @(
              [PSCustomObject]@{
                  Name = "Scrum"
                  URL  = "https://dummy.none/_apis/work/processes/6b724908-ef14-45cf-84f8-768b5384da45"
               }
            )
         }
         [vsteam_lib.ProcessTemplateCache]::Invalidate()
      }

      It 'should get behaviors and set their type correctly' {
         ## Act
         $behaviors = Get-VSTeamProcessBehavior -ProcessTemplate Scrum

         ## Assert
         Should -Invoke Get-VSTeamWorkItemType -Scope It -ParameterFilter {$Expand -eq 'Behaviors'} -Times 1 -Exactly
         Should -Invoke _callapi -Scope It -ParameterFilter {$url -like '*/behaviors?$expand=combinedFields*'} -Times 1 -Exactly
         $behaviors.count                   | Should -Be 6
         $behaviors[0].psobject.Typenames   | Should -Contain 'vsteam_lib.Processbehavior'
         $behaviors[0].ProcessTemplate      | Should -Be      'Scrum'

      }
   }

   AfterAll {
      [vsteam_lib.Versions]::Account = 'https://dev.azure.com/test'
   }

}