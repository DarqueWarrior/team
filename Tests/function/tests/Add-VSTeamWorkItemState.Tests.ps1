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
      $bug = @{
         name            = 'Bug'
         customization   = 'System'
         color           = 'CC293D'
         description     = 'Describes a divergence between required and actual behavior, and tracks the work done to correct the defect and verify the correction.'
         icon            = 'Icon_Insect'
         isDisabled      =  $false
         referenceName   = 'Microsoft.VSTS.WorkItemTypes.Bug'
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
               customizationType  = 'system'
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
               id                 = '0c926c15-68f7-467f-96c9-a26a19e9d718'
               name               = 'Done'
               color              = '339933'
               stateCategory      = 'Completed'
               order              = 4
               url                = 'https://dummy.none/workItemTypes/Microsoft.VSTS.WorkItemTypes.Bug/states/0c926c15-68f7-467f-96c9-a26a19e9d718'
               customizationType  = 'system'
            }
            [PSCustomObject]@{
               id                 = '0293a2ce-2a42-4d0e-bbbf-d2237efa0db8'
               name               = 'Removed'
               color              = 'ffffff'
               stateCategory      = 'Removed'
               order              = 5
               url                = 'https://dummy.none/workItemTypes/Microsoft.VSTS.WorkItemTypes.Bug/states/0293a2ce-2a42-4d0e-bbbf-d2237efa0db8'
               customizationType  = 'system'
            }
         )
      }
      Mock Get-VSTeamProcess { return @(
               [PSCustomObject]@{
                  Name = 'Scrum2'
                  URL  = 'https://dummy.none/_apis/work/processes/6b724908-ef14-45cf-84f8-768b5384da45'
               }
            )
         }
      Mock Get-VSTeamWorkItemType {return $bug }

      Mock _callAPI       -ParameterFilter { $Url -match    'states' } {
         return [PSCustomObject]@{
                  id                 = '00000'
                  name               = 'Postponed'
                  color              = '0000ff'
                  stateCategory      = 'Removed'
                  order              =  4
                  url                = 'https://dummy.none/workItemTypes/Microsoft.VSTS.WorkItemTypes.Bug/states/00000'
                  customizationType  = 'custom'
               }
      }
      Mock _callAPI       -ParameterFilter { $Url -NotMatch 'states' -and $body -notmatch  'inheritsFrom' } {return $null}

      # replaced by unlock Mock _callAPI       -ParameterFilter {$body -match    'inheritsFrom' } {return $bug }
      Mock Unlock-VSTeamWorkItemType {return $WorkItemType }
      [vsteam_lib.ProcessTemplateCache]::Invalidate()
   }

   Context 'Add-VsteamWorkItemState' {


      It 'should call the REST API to add a state, updating system types as needed' {
         ## Act
         $state =  Add-VsteamWorkItemState -WorkItemType bug -Color Blue -Name postponed -ProcessTemplate Scrum2 -order 4 -Force

         ## Assert
         Should -Invoke _callAPI -Scope It  -Times 1 -Exactly -ParameterFilter {
               $Body -match  '"stateCategory"\s*:\s*"InProgress"' -and
               $Body -match  '"name"\s*:\s*"postponed"'           -and
               $Body -match  '"color"\s*:\s*"0+ff"'               -and
               $Body -match  '"order"\s*:\s*4'
         }

         $state.psobject.Typenames | Should -Contain 'vsteam_lib.WorkItemState'
         $state.ProcessTemplate    | Should -Be      'Scrum2'
         $state.WorkItemType       | Should -Be      'Bug'
      }
   }
   AfterAll {
         [vsteam_lib.Versions]::Account = ""
   }
}

