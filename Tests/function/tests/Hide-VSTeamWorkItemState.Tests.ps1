Set-StrictMode -Version Latest

Describe 'VSTeamWorkItemState' {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath
      . "$PSScriptRoot\..\..\..\Source\Public\Get-VSTeamProcess.ps1"
      . "$PSScriptRoot\..\..\..\Source\Public\Get-VSTeamWorkItemType.ps1"
      . "$PSScriptRoot\..\..\..\Source\Public\Unlock-VSTeamWorkItemType.ps1"
      ## Arrange
      # Set the account to use for testing. A normal user would do this
      # using the Set-VSTeamAccount function.
      [vsteam_lib.Versions]::Account = 'https://dev.azure.com/test'
      Mock _getApiVersion { return '1.0-unitTests' } -ParameterFilter { $Service -eq 'Processes' }

      Mock _callAPI       -ParameterFilter { $Url -match 'states' } {
         return [PSCustomObject]@{
                  id                 = '7b7e3e8c-e500-40b6-ad56-d59b8d64d757'
                  name               = 'New'
                  color              = 'b2b2b2'
                  stateCategory      = 'Proposed'
                  order              = 1
                  url                = 'https://dummy.none/workItemTypes/Microsoft.VSTS.WorkItemTypes.Bug/states/7b7e3e8c-e500-40b6-ad56-d59b8d64d757'
                  customizationType  = 'inherited'
                  hidden             = $true
               }
      }
      Mock _callAPI       { return $null}

      Mock Unlock-VSTeamWorkItemType {return $WorkItemType }
   }

   Context 'Hide-VsteamWorkItemState' {
      BeforeAll {
         #Different version of bug with states set for this test
         $bug = @{
            name            = 'Bug'
            customization   = 'System'
            color           = 'CC293D'
            description     = 'Describes a divergence between required and actual behavior, and tracks the work done to correct the defect and verify the correction.'
            icon            = 'Icon_Insect'
            isDisabled      =  $false
            referenceName   = 'Microsoft.VSTS.WorkItemTypes.Bug'
            url             = 'https://dummy.none/workItemTypes/Microsoft.VSTS.WorkItemTypes.Bug'
            ProcessTemplate = 'Scrum2'
            states          = @(
               [PSCustomObject]@{
                  id                 = '7b7e3e8c-e500-40b6-ad56-d59b8d64d757'
                  name               = 'New'
                  color              = 'b2b2b2'
                  stateCategory      = 'Proposed'
                  order              = 1
                  url                = 'https://dummy.none/workItemTypes/Microsoft.VSTS.WorkItemTypes.Bug/states/7b7e3e8c-e500-40b6-ad56-d59b8d64d757'
                  customizationType  = 'system'
               },
               [PSCustomObject]@{
                  id                 = '02cca570-0896-4a30-aff1-87ccffc68ce0'
                  name               = 'Approved'
                  color              = 'b2b2b2'
                  stateCategory      = 'Proposed'
                  order              = 2
                  url                = 'https://dummy.none/workItemTypes/Microsoft.VSTS.WorkItemTypes.Bug/states/02cca570-0896-4a30-aff1-87ccffc68ce0'
                  customizationType  = 'inherited'
               }
               [PSCustomObject]@{
                  id                 = 'abb54c86-d03a-44fe-8216-309d3c712296'
                  name               = 'Committed'
                  color              = '007acc'
                  stateCategory      = 'InProgress'
                  order              = 3
                  url                = 'https://dummy.none/workItemTypes/Microsoft.VSTS.WorkItemTypes.Bug/states/abb54c86-d03a-44fe-8216-309d3c712296'
                  customizationType  = 'system'
               }
               [PSCustomObject]@{
                  id                 = '000000'
                  name               = 'Postponed'
                  color              = '0000ff'
                  stateCategory      = 'InProgress'
                  order              = 4
                  url                = 'https://dummy.none/workItemTypes/Microsoft.VSTS.WorkItemTypes.Bug/states/00000'
                  customizationType  = 'Custom'
               }
               [PSCustomObject]@{
                  id                 = '0c926c15-68f7-467f-96c9-a26a19e9d718'
                  name               = 'Done'
                  color              = '339933'
                  stateCategory      = 'Completed'
                  order              = 5
                  url                = 'https://dummy.none/workItemTypes/Microsoft.VSTS.WorkItemTypes.Bug/states/0c926c15-68f7-467f-96c9-a26a19e9d718'
                  customizationType  = 'system'
               }
               [PSCustomObject]@{
                  id                 = '0293a2ce-2a42-4d0e-bbbf-d2237efa0db8'
                  name               = 'Removed'
                  color              = 'ffffff'
                  stateCategory      = 'Removed'
                  order              = 6
                  url                = 'https://dummy.none/workItemTypes/Microsoft.VSTS.WorkItemTypes.Bug/states/0293a2ce-2a42-4d0e-bbbf-d2237efa0db8'
                  customizationType  = 'system'
               }
            )
         }
         Mock Get-VSTeamWorkItemType {return $bug }
         Mock Get-VSTeamProcess { return @(
               [PSCustomObject]@{
                  Name = 'Scrum2'
                  URL  = 'https://dummy.none/_apis/work/processes/6b724908-ef14-45cf-84f8-768b5384da45'
               }
            )
         }
         [vsteam_lib.ProcessTemplateCache]::Invalidate()
         Mock Write-Warning {}
      }

      It 'should warn for states which have already been hidden' {
         ## Act
         $state = Hide-VsteamWorkItemState -WorkItemType bug -Name Resolved -ProcessTemplate Scrum2 -Force

         ## Assert
         Should -Invoke Get-VSTeamWorkItemType   -ParameterFilter {
            $Expand       -eq "States" -and
            $WorkItemType -eq "Bug"
         }  -Scope It                 -Times 1 -Exactly
         Should -Invoke Write-Warning -Times 1 -Exactly
         Should -invoke _callAPI      -Times 0 -Exactly
         $State | Should -BeNullOrEmpty
      }
      It 'should call the REST API with the PUT method and the correct URL to hide a system WorkItem state' {
         ## Act
         $state = Hide-VsteamWorkItemState -WorkItemType bug -Name New -ProcessTemplate Scrum2 -Force

         ## Assert

         Should -Invoke Get-VSTeamWorkItemType -ParameterFilter {
            $Expand       -eq "States" -and
            $WorkItemType -eq "Bug"
         } -Scope It                   -Times 1 -Exactly
         Should -Invoke _callAPI               -ParameterFilter {
               $method -eq  'PUT' -and
               $url -match "WorkItemTypes\.Bug/states/7b7e3e8c-e500-40b6-ad56-d59b8d64d757\?api-version=" -and
               $body -match '"hidden"\s*:\s*true'
         } -Scope It                    -Times 1 -Exactly
         Should -Invoke Write-Warning -Times 0 -Exactly
         $state.Psobject.typenames  | Should -Contain 'vsteam_lib.WorkItemState'
         $state.ProcessTemplate     | should -be      'Scrum2'
         $state.WorkItemType        | should -be      'bug'
      }
   }

   AfterAll {
         [vsteam_lib.Versions]::Account = ""
   }

}

