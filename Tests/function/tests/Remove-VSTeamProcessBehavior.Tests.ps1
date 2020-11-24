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

   Context 'Remove-VSTeamProcessBehavior' {
      BeforeAll {
         ## Arrange
         Mock _callAPi {return $null} -ParameterFilter {$method -eq "delete"}
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
         Remove-VSTeamProcessBehavior -ProcessTemplate Scrum -Name "Test" -Force

         ## Assert
         Should -Invoke _callapi -Scope It -ParameterFilter {
                $method -eq 'delete' -and
                $url     -match "https://dummy.none/_apis/work/processes/6b724908-ef14-45cf-84f8-768b5384da45/behaviors/TestReferenceName" -and
                $body   -eq $null
         } -Times 1 -Exactly
      }
   }

   AfterAll {
      [vsteam_lib.Versions]::Account = 'https://dev.azure.com/test'
   }

}