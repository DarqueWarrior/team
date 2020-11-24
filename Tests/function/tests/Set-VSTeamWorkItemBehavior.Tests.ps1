Set-StrictMode -Version Latest

Describe 'VSTeamWorkItemBehavior' {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath
      . "$PSScriptRoot\..\..\..\Source\Public\Get-VSTeamProcess.ps1"
      . "$PSScriptRoot\..\..\..\Source\Public\Get-VSTeamWorkItemType.ps1"
      . "$PSScriptRoot\..\..\..\Source\Public\Get-VSTeamProcessBehavior.ps1"
      ## Arrange
      # Set the account to use for testing. A normal user would do this
      # using the Set-VSTeamAccount function.
      [vsteam_lib.Versions]::Account = 'https://dev.azure.com/test'
      Mock _getApiVersion     { return '1.0-unitTests' } -ParameterFilter { $Service -eq 'Processes' }
      Mock _getDefaultProject { return "MockProject"}
   }

   Context 'Set-VSTeamWorkItemBehavior' {
      BeforeAll {
         ## Arrange
         Mock _callApi { return  [PSCustomObject]@{isdefault = $false; behavior = [PSCustomObject]@{
                     id  = 'Microsoft.VSTS.Scrum.EpicBacklogBehavior'
                     url = 'http://dummy.none'
         }}}
         Mock Write-Warning {}
         Mock Get-VSTeamWorkItemType  -ParameterFilter { $WorkItemType -eq 'Custom' } {
            [PSCustomObject]@{name = 'Custom'; url = 'http://dummy.none/workItemTypes/Microsoft.VSTS.WorkItemTypes.Custom/'; behaviors = @()}
         }
         Mock Get-VSTeamWorkItemType  -ParameterFilter { $WorkItemType -eq 'Epic' } {
            [PSCustomObject]@{name = 'Epic';   url = 'http://dummy.none/workItemTypes/Microsoft.VSTS.WorkItemTypes.Epic';  behaviors = @(
               [PSCustomObject]@{isdefault = $true; behavior = [PSCustomObject]@{
                     id  = 'Microsoft.VSTS.Scrum.EpicBacklogBehavior'
                     url = 'http://dummy.none'
               }}
            )}
         }
         Mock Get-VSTeamProcess { return @(
              [PSCustomObject]@{
                  Name = 'Scrum'
                  URL  = 'https://dummy.none/_apis/work/processes/6b724908-ef14-45cf-84f8-768b5384da45'
               }
            )
         }
         Mock Get-VSTeamProcessBehavior { return [PSCustomObject]@{
                  name          = 'Epics'
                  referenceName = 'Microsoft.VSTS.Scrum.EpicBacklogBehavior'
                  rank          = 40
         }}

         [vsteam_lib.ProcessTemplateCache]::Invalidate()
      }

      It 'should raise a warning when trying to clear an empty behavior' {
         ## Act
         Set-VSTeamWorkItemBehavior -ProcessTemplate Scrum  -WorkItemType Custom -Remove -Force

         ## Assert
         Should -Invoke Get-VSTeamWorkItemType    -Scope It -Exactly -Times 1  -ParameterFilter {$Expand -eq 'Behaviors'}
         Should -Invoke Get-VSTeamProcessBehavior -Scope It -Exactly -Times 0 #not called on remove
         Should -Invoke Write-Warning             -Scope It -Exactly -Times 1
      }
      It 'should call the correct api to clear a behavior' {
         ## Act
         Set-VSTeamWorkItemBehavior -ProcessTemplate Scrum  -WorkItemType Epic -Remove  -Force

         ## Assert
         Should -Invoke Get-VSTeamWorkItemType    -Scope It -Exactly -Times 1  -ParameterFilter {$Expand -eq 'Behaviors'}
         Should -Invoke Get-VSTeamProcessBehavior -Scope It -Exactly -Times 0  #not called on remove
         Should -Invoke Write-Warning             -Scope It -Exactly -Times 0 # no warning this time
         Should -Invoke _callApi                  -Scope It -Exactly -Times 1  -ParameterFilter {
               $method -eq   'Delete'
               $url    -like '*/workitemtypesbehaviors/Microsoft.VSTS.WorkItemTypes.Epic/behaviors/Microsoft.VSTS.Scrum.EpicBacklogBehavior*'}
      }
      It 'should warn on double adding the same behavior' {
         ## Act
         Set-VSTeamWorkItemBehavior -ProcessTemplate Scrum  -WorkItemType EPIC -Behavior "Epics"  -Force

         ## Assert
         Should -Invoke Get-VSTeamWorkItemType    -Scope It -Exactly -Times 1  -ParameterFilter {$Expand -eq 'Behaviors'}
         Should -Invoke Get-VSTeamProcessBehavior -Scope It -Exactly -Times 1  #called on add
         Should -Invoke Write-Warning             -Scope It -Exactly -Times 1 # warning that it can't change default

      }
      It 'should call the correct api to add a behavior and return the correct object' {
         ## Act
         $behavior = Set-VSTeamWorkItemBehavior -ProcessTemplate Scrum  -WorkItemType Custom -Behavior "Epics"  -Force

         ## Assert
         Should -Invoke Get-VSTeamWorkItemType    -Scope It -Exactly -Times 1  -ParameterFilter {$Expand -eq 'Behaviors'}
         Should -Invoke Get-VSTeamProcessBehavior -Scope It -Exactly -Times 1  #called on add
         Should -Invoke Write-Warning             -Scope It -Exactly -Times 0 # no warning this this time
         Should -Invoke _callApi                  -Scope It -Exactly -Times 1 {
               $method -eq   'Delete'
               $url    -like '*/workitemtypesbehaviors/Microsoft.VSTS.WorkItemTypes.Custom/behaviors/Microsoft.VSTS.Scrum.EpicBacklogBehavior*'}
         $behavior.ProcessTemplate    | Should -BeExactly 'Scrum'
         $behavior.WorkItemType       | Should -BeExactly 'Custom'
         $behavior.Behavior           | Should -BeExactly 'Microsoft.VSTS.Scrum.EpicBacklogBehavior'
         $behavior.psobject.Typenames | Should -Contain   'vsteam_lib.WorkItembehavior'
      }

   }

   AfterAll {
      [vsteam_lib.Versions]::Account = 'https://dev.azure.com/test'
   }

}

<#
$behavior.psobject.Typenames   | Should -Contain 'vsteam_lib.WorkItembehavior'
         $behavior.ProcessTemplate      | Should -Be      'Scrum'
         $behavior.WorkItemType         | Should -Be      'Epic'
#>