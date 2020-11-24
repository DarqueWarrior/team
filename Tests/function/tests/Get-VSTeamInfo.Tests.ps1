Set-StrictMode -Version Latest

Describe 'VSTeamInfo' {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath
   }

   Context 'Get-VSTeamInfo' {
      AfterAll {
         $Global:PSDefaultParameterValues.Remove("*-vsteam*:projectName")
         [vsteam_lib.Versions]::Account = ''
      }

      It 'should return account and default project' {
         [vsteam_lib.Versions]::Account = "mydemos"
         $Global:PSDefaultParameterValues['*-vsteam*:projectName'] = 'TestProject'

         ## Act
         $info = Get-VSTeamInfo

         ## Assert
         $info.Account | Should -Be "mydemos"
         $info.DefaultProject | Should -Be "TestProject"
      }
   }
}