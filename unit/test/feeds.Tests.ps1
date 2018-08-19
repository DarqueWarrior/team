Set-StrictMode -Version Latest

InModuleScope feeds {
   [VSTeamVersions]::Account = 'https://test.visualstudio.com'
   
   $results = Get-Content "$PSScriptRoot\sampleFiles\feeds.json" -Raw | ConvertFrom-Json

   Describe 'Feeds' {
      # Mock the call to Get-Projects by the dynamic parameter for ProjectName
      Mock Invoke-RestMethod { return @() } -ParameterFilter {
         $Uri -like "*_apis/projects*" 
      }
   
      Context 'Get-VSTeamFeed with no parameters' {
         [VSTeamVersions]::Packaging = '4.0'
         Mock Invoke-RestMethod { return $results }

         it 'Should return all the Feeds' {
            Get-VSTeamFeed

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Uri -eq "https://test.feeds.visualstudio.com/_apis/packaging/feeds/?api-version=$([VSTeamVersions]::packaging)"
            }
         }
      }

      Context 'Get-VSTeamFeed with id parameter' {
         [VSTeamVersions]::Packaging = '4.0'
         Mock Invoke-RestMethod { return $results.value[0] }

         it 'Should return all the Feeds' {
            Get-VSTeamFeed -id '00000000-0000-0000-0000-000000000000'

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Uri -eq "https://test.feeds.visualstudio.com/_apis/packaging/feeds/00000000-0000-0000-0000-000000000000?api-version=$([VSTeamVersions]::packaging)"
            }
         }
      }

      Context 'Get-VSTeamFeed on TFS'{
         [VSTeamVersions]::Packaging = ''
         
         it 'Should throw' {
            { Get-VSTeamFeed } | Should throw
         }
      }      
   }
}