Set-StrictMode -Version Latest

Describe 'VSTeamDefaultProject' {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath
      . "$PSScriptRoot\_testInitialize.ps1" Get-VSTeamProcess
      Mock _getInstance { return 'https://dev.azure.com/test' }
      Mock Get-VSTeamProcess { return @() }
   }

   Context 'Set-VSTeamDefaultProject' {
      AfterAll {
         $Global:PSDefaultParameterValues.Remove("*-vsteam*:projectName")
      }

      It 'should set default project' {
         Set-VSTeamDefaultProject 'DefaultProject'

         $Global:PSDefaultParameterValues['*-vsteam*:projectName'] | Should -Be 'DefaultProject'
      }

      It 'should update default project' {
         $Global:PSDefaultParameterValues['*-vsteam*:projectName'] = 'DefaultProject'

         Set-VSTeamDefaultProject -Project 'NextProject'

         $Global:PSDefaultParameterValues['*-vsteam*:projectName'] | Should -Be 'NextProject'
      }
   }

   Context 'Set-VSTeamDefaultProject on Non Windows' {
      BeforeAll {
         Mock _isOnWindows { return $false } -Verifiable
      }

      AfterAll {
         $Global:PSDefaultParameterValues.Remove("*-vsteam*:projectName")
      }

      It 'should set default project' {
         Set-VSTeamDefaultProject 'MyProject'

         Should -InvokeVerifiable
         $Global:PSDefaultParameterValues['*-vsteam*:projectName'] | Should -Be 'MyProject'
      }
   }

   Context 'Set-VSTeamDefaultProject As Admin on Windows' {
      BeforeAll {
         Mock _isOnWindows { return $true }
         Mock _testAdministrator { return $true } -Verifiable
      }

      AfterAll {
         $Global:PSDefaultParameterValues.Remove("*-vsteam*:projectName")
      }

      It 'should set default project' {
         Set-VSTeamDefaultProject 'MyProject'

         Should -InvokeVerifiable
         $Global:PSDefaultParameterValues['*-vsteam*:projectName'] | Should -Be 'MyProject'
      }
   }
}