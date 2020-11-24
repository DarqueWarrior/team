Set-StrictMode -Version Latest

Describe 'VSTeamWorkItemBehavior' {
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

   Context 'Get-VSTeamWorkItemBehavior' {
      BeforeAll {
         ## Arrange
         Mock Get-VSTeamWorkItemType {
            [PSCustomObject]@{name = "Epic"; behaviors = @(
               [PSCustomObject]@{isdefault = $true; behavior = [PSCustomObject]@{
                     id  = 'Microsoft.VSTS.Scrum.EpicBacklogBehavior'
                     url = 'http://dummy.none'
               }}
            )}
         }
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
         $behavior = Get-VSTeamWorkItemBehavior -ProcessTemplate Scrum  -WorkItemType epic

         ## Assert
         Should -Invoke Get-VSTeamWorkItemType -Scope It -ParameterFilter {$Expand -eq 'Behaviors'} -Times 1 -Exactly


         $behavior.ProcessTemplate      | Should -Be      'Scrum'
         $behavior.WorkItemType         | Should -Be      'Epic'
      }
   }

   AfterAll {
      [vsteam_lib.Versions]::Account = 'https://dev.azure.com/test'
   }

}