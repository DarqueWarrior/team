Set-StrictMode -Version Latest

Describe 'VSTeamProcessBehavior' {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath
      . "$PSScriptRoot\..\..\..\Source\Public\Get-VSTeamProcess.ps1"
      . "$PSScriptRoot\..\..\..\Source\Public\Get-VSTeamProcessBehavior.ps1"
      ## Arrange
      # Set the account to use for testing. A normal user would do this
      # using the Set-VSTeamAccount function.
      [vsteam_lib.Versions]::Account = 'https://dev.azure.com/test'
      Mock _getApiVersion     { return '1.0-unitTests' }
      Mock _getDefaultProject { return "MockProject"}
   }

   Context 'Set-VSTeamProcessBehavior' {
      BeforeAll {
         ## Arrange
         Mock _callAPi {return [pscustomobject]@{name="Dummy"}} -ParameterFilter {$method -eq "put"}
         Mock Get-VSTeamProcess { return @(
              [PSCustomObject]@{
                  Name = "Scrum"
                  URL  = "https://dummy.none/_apis/work/processes/6b724908-ef14-45cf-84f8-768b5384da45"
               }
            )
         }
         Mock Get-VSTeamProcessBehavior { return [PSCustomObject]@{
            Name = "Test"
            url = "https://dummy.none/_apis/work/processes/6b724908-ef14-45cf-84f8-768b5384da45/behaviors/TestReferenceName" }
         }
         [vsteam_lib.ProcessTemplateCache]::Invalidate()
      }

      It 'Calls the right API to add a process behavior' {
         ## Act
         $behavior = Set-VSTeamProcessBehavior -ProcessTemplate Scrum -Name "Test" -Color Blue -NewName "NewName" -Force

         ## Assert
         Should -Invoke _callapi -Scope It -ParameterFilter {
                $method -eq 'Put' -and
                $url     -match "https://dummy.none/_apis/work/processes/6b724908-ef14-45cf-84f8-768b5384da45/behaviors/TestReferenceName" -and
                $body   -match '"name":\s*"NewName"' -and
                $body   -match '"color":\s*"0000ff"' #Green translated
         } -Times 1 -Exactly
         $behavior.psobject.Typenames   | Should -Contain 'vsteam_lib.Processbehavior'
         $behavior.ProcessTemplate      | Should -Be      'Scrum'
      }
   }

   AfterAll {
      [vsteam_lib.Versions]::Account = 'https://dev.azure.com/test'
   }

}