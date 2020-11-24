Set-StrictMode -Version Latest

Describe 'VSTeamProcessBehavior' {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath
      . "$PSScriptRoot\..\..\..\Source\Public\Get-VSTeamProcess.ps1"
      ## Arrange
      # Set the account to use for testing. A normal user would do this
      # using the Set-VSTeamAccount function.
      [vsteam_lib.Versions]::Account = 'https://dev.azure.com/test'
      Mock _getApiVersion     { return '1.0-unitTests' }
      Mock _getDefaultProject { return "MockProject"}
   }

   Context 'Add-VSTeamProcessBehavior' {
      BeforeAll {
         ## Arrange
         Mock _callAPi {return [pscustomobject]@{name="Dummy"}} -ParameterFilter {$method -eq "post"}
         Mock _callAPi {return @{value=@{name="Dummy"}}}
         Mock Get-VSTeamProcess { return @(
              [PSCustomObject]@{
                  Name = "Scrum"
                  URL  = "https://dummy.none/_apis/work/processes/6b724908-ef14-45cf-84f8-768b5384da45"
               }
            )
         }
         Mock _getProcessTemplateUrl { return "https://dummy.none/_apis/work/processes/6b724908-ef14-45cf-84f8-768b5384da45" }
         [vsteam_lib.ProcessTemplateCache]::Invalidate()
      }

      It 'Calls the right API to add a process behavior' {
         ## Act
         $behavior = Add-VSTeamProcessBehavior -ProcessTemplate Scrum -Name "Test" -Color Green

         ## Assert
         Should -Invoke _callapi -Scope It -ParameterFilter {
                $method -eq 'Post' -and
                $url     -match "https://dummy.none/_apis/work/processes/6b724908-ef14-45cf-84f8-768b5384da45/behaviors" -and
                $body   -match '"inherits":\s*"System.PortfolioBacklogBehavior"' -and
                $body   -match '"name":\s*"Test"' -and
                $body   -match '"color":\s*"008000"' #Green translated
         } -Times 1 -Exactly
         Should -Invoke _callapi -Scope It -ParameterFilter {$method -ne 'Post' -and $body -eq $null} -Times 1 -Exactly
         $behavior.psobject.Typenames   | Should -Contain 'vsteam_lib.Processbehavior'
         $behavior.ProcessTemplate      | Should -Be      'Scrum'
      }
   }

   AfterAll {
      [vsteam_lib.Versions]::Account = 'https://dev.azure.com/test'
   }

}