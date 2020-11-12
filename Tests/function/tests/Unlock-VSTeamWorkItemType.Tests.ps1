Set-StrictMode -Version Latest

Describe 'VSTeamWorkItemType' {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath

      ## Arrange
      # Set the account to use for testing. A normal user would do this
      # using the Set-VSTeamAccount function.
      Mock _getInstance { return 'https://dev.azure.com/test' }
      Mock _getApiVersion { return '1.0-unitTests' }
      Mock _callApi -ParameterFilter { $Method -eq 'Post' } -MockWith {
         return ([psCustomObject]@{name = 'Dummy' })
      }
   }

   Context 'Update WorkItem Types' {


      It 'Returns custom WorkItem Types untouched.' {

         $wit = [psCustomObject]@{
            name          = 'Gub'
            customization = 'custom'
            icon          = 'icon_book'
            color         = 'ff0000'
            isDisabled    =  $false
            description   = 'Test Item'
            url           = 'http://bogus.none/workItemTypes/99';
         }
         $x = $wit | Unlock-VSTeamWorkItemType -Force

         Should -Invoke _callApi -Exactly -Times 0 -Scope It
         $x.customization | should -BeExactly $wit.customization
         $x.url | should -BeExactly $wit.url
      }

      It 'Posts changes for system WorkItem Types' {
         $wit =   [psCustomObject]@{
            name          = 'Bug'
            customization = 'system'
            referenceName = 'Microsoft.VSTS.WorkItemTypes.Bug'
            icon          = 'icon_insect'
            color         = 'cc293d'
            isDisabled    =  $false
            description   = 'A divergence...'
            url           = 'http://bogus.none/workItemTypes/98'
         }

         $x = $wit | Unlock-VSTeamWorkItemType -Force
         Should -Invoke _callApi -Exactly -Times 1 -Scope It -ParameterFilter {
            $Url    -like     '*workitemTypes?api-version=*'           -and  #found expected item
            $Body   -match    '"inheritsFrom":\s+"Microsoft.VSTS.WorkItemTypes.Bug"' -and
            $Method -eq       'Post'
         }
         $x.psobject.TypeNames | Should -Contain 'vsteam_lib.WorkItemType'
         $x.name               | Should -Be 'Dummy'
      }
   }
}
