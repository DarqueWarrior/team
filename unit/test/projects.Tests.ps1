Set-StrictMode -Version Latest

Get-Module team | Remove-Module -Force
Import-Module $PSScriptRoot\..\..\src\projects.psm1 -Force

InModuleScope projects {
   $env:TEAM_ACCT = 'https://test.visualstudio.com'

   Describe 'Project' {
      . "$PSScriptRoot\mockProjectNameDynamicParam.ps1"

      Context 'Get-VSTeamProject with no parameters' {

         Mock Invoke-RestMethod { return @{value='projects'}}

         It 'Should return projects' {
            Get-VSTeamProject

            # Make sure it was called with the correct URI
            Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter {
               $Uri -eq 'https://test.visualstudio.com/_apis/projects/?api-version=1.0&stateFilter=WellFormed&$top=100&$skip=0'
            }
         }
      }

      Context 'Get-VSTeamProject with top 10' {

         Mock Invoke-RestMethod { return @{value='projects'}}

         It 'Should return top 10 projects' {
            Get-VSTeamProject -top 10

            # Make sure it was called with the correct URI
            Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter { $Uri -eq 'https://test.visualstudio.com/_apis/projects/?api-version=1.0&stateFilter=WellFormed&$top=10&$skip=0' }
         }
      }

      Context 'Get-VSTeamProject with skip 1' {

         Mock Invoke-RestMethod { return @{value='projects'}}

         It 'Should skip first project' {
            Get-VSTeamProject -skip 1

            # Make sure it was called with the correct URI
            Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter { $Uri -eq 'https://test.visualstudio.com/_apis/projects/?api-version=1.0&stateFilter=WellFormed&$top=100&$skip=1' }
         }
      }

      Context 'Get-VSTeamProject with stateFilter All' {

         Mock Invoke-RestMethod { return @{value='projects'}}

         It 'Should return All projects' {
            Get-VSTeamProject -stateFilter 'All'

            # Make sure it was called with the correct URI
            Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter { $Uri -eq 'https://test.visualstudio.com/_apis/projects/?api-version=1.0&stateFilter=All&$top=100&$skip=0' }
         }
      }

      Context 'Get-VSTeamProject with no Capabilities' {

         Mock Invoke-RestMethod { return @{value='projects'}}

         It 'Should return the project' {
            Get-VSTeamProject -ProjectName Test

            # Make sure it was called with the correct URI
            Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter { $Uri -eq 'https://test.visualstudio.com/_apis/projects/Test?api-version=1.0' }
         }
      }

      Context 'Get-VSTeamProject with Capabilities' {

         Mock Invoke-RestMethod { return 'project'}

         It 'Should return the project with capabilities' {
            Get-VSTeamProject -projectId Test -includeCapabilities

            # Make sure it was called with the correct URI
            Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter { $Uri -eq 'https://test.visualstudio.com/_apis/projects/Test?api-version=1.0&includeCapabilities=true' }
         }
      }

      Context 'Update-VSTeamProject with no op' {
         Mock Invoke-RestMethod { return @{id='123-5464-dee43'} } 

         It 'Should call Invoke-RestMethod only once' {
            Update-VSTeamProject -ProjectName Test

            Assert-MockCalled Invoke-RestMethod -Exactly 1
         }
      }

      Context 'Update-VSTeamProject with newName' {

         Mock Invoke-RestMethod { return @{id='123-5464-dee43'} } -ParameterFilter { $Uri -eq 'https://test.visualstudio.com/_apis/projects/Test?api-version=1.0' }
         Mock Invoke-RestMethod { return @{status='inProgress'; url='https://someplace.com'} } -ParameterFilter { $Method -eq 'Patch'}
         Mock _trackProgress
         Mock Invoke-RestMethod { return @{id='123-5464-dee43'} } -ParameterFilter { $Uri -eq 'https://test.visualstudio.com/_apis/projects/Testing123?api-version=1.0' }

         It 'Should change name' {
            Update-VSTeamProject -ProjectName Test -newName Testing123 -Force

            Assert-MockCalled Invoke-RestMethod -Times 1 -ParameterFilter { $Uri -eq 'https://test.visualstudio.com/_apis/projects/Test?api-version=1.0' }
            Assert-MockCalled Invoke-RestMethod -Times 1 -ParameterFilter { $Method -eq 'Patch' -and $Body -eq '{"name": "Testing123"}'}
            Assert-MockCalled Invoke-RestMethod -Times 1 -ParameterFilter { $Uri -eq 'https://test.visualstudio.com/_apis/projects/Testing123?api-version=1.0' }
         }
      }

      Context 'Update-VSTeamProject with newDescription' {

         Mock Invoke-RestMethod { return @{id='123-5464-dee43'} } -ParameterFilter { $Uri -eq 'https://test.visualstudio.com/_apis/projects/Test?api-version=1.0' }
         Mock Invoke-RestMethod { return @{status='inProgress'; url='https://someplace.com'} } -ParameterFilter { $Method -eq 'Patch'}
         Mock _trackProgress

         It 'Should change description' {
            Update-VSTeamProject -ProjectName Test -newDescription Testing123 -Force

            Assert-MockCalled Invoke-RestMethod -Times 2 -ParameterFilter { $Uri -eq 'https://test.visualstudio.com/_apis/projects/Test?api-version=1.0' }
            Assert-MockCalled Invoke-RestMethod -Times 1 -ParameterFilter { $Method -eq 'Patch' -and $Body -eq '{"description": "Testing123"}' }
         }
      }

      Context 'Update-VSTeamProject with new name and description' {

         Mock Invoke-RestMethod { return @{id='123-5464-dee43'} } -ParameterFilter { $Uri -eq 'https://test.visualstudio.com/_apis/projects/Test?api-version=1.0' }
         Mock Invoke-RestMethod { return @{status='inProgress'; url='https://someplace.com'} } -ParameterFilter { $Method -eq 'Patch'}
         Mock _trackProgress
         Mock Invoke-RestMethod { return @{id='123-5464-dee43'} } -ParameterFilter { $Uri -eq 'https://test.visualstudio.com/_apis/projects/Testing123?api-version=1.0' }

         It 'Should not call Invoke-RestMethod' {
            Update-VSTeamProject -ProjectName Test -newName Testing123 -newDescription Testing123 -Force

            Assert-MockCalled Invoke-RestMethod -Times 1 -ParameterFilter { $Uri -eq 'https://test.visualstudio.com/_apis/projects/Test?api-version=1.0' }
            Assert-MockCalled Invoke-RestMethod -Times 1 -ParameterFilter { $Method -eq 'Patch'}
            Assert-MockCalled Invoke-RestMethod -Times 1 -ParameterFilter { $Uri -eq 'https://test.visualstudio.com/_apis/projects/Testing123?api-version=1.0' }
         }
      }

      Context 'Remove-VSTeamProject with Force' {

         Mock Write-Progress
         Mock _trackProgress
         Mock Invoke-RestMethod { return @{id='123-5464-dee43'} } -ParameterFilter { $Uri -eq 'https://test.visualstudio.com/_apis/projects/Test?api-version=1.0' }
         Mock Invoke-RestMethod { return @{status='inProgress'; url='https://someplace.com'} } -ParameterFilter { $Method -eq 'Delete' -and $Uri -eq 'https://test.visualstudio.com/_apis/projects/123-5464-dee43?api-version=1.0'}

         It 'Should not call Invoke-RestMethod' {
            Remove-VSTeamProject -ProjectName Test -Force

            Assert-MockCalled Invoke-RestMethod -Times 1 -ParameterFilter { $Uri -eq 'https://test.visualstudio.com/_apis/projects/Test?api-version=1.0' }
            Assert-MockCalled Invoke-RestMethod -Times 1 -ParameterFilter { $Method -eq 'Delete' -and $Uri -eq 'https://test.visualstudio.com/_apis/projects/123-5464-dee43?api-version=1.0'}
         }
      }

      Context 'Add-VSTeamProject with tfvc' {
         Mock Write-Progress
         # Add Project
         Mock Invoke-RestMethod { return @{status='inProgress'; id='123-5464-dee43'; url='https://someplace.com'} } -ParameterFilter { $Method -eq 'Post' -and $Uri -eq 'https://test.visualstudio.com/_apis/projects/?api-version=1.0'}

         # Track Progress
         Mock Invoke-RestMethod {
            # This $i is in the module. Because we use InModuleScope
            # we can see it
            if ($i -gt 9) {
               return @{status='succeeded'}
            }

            return @{status='inProgress' }
         } -ParameterFilter { $Uri -eq 'https://someplace.com'}

         # Get-VSTeamProject
         Mock Invoke-RestMethod { return @{id='123-5464-dee43'} } -ParameterFilter { $Uri -eq 'https://test.visualstudio.com/_apis/projects/Test?api-version=1.0' }

         It 'Should create project with tfvc' {
            Add-VSTeamProject -ProjectName Test -tfvc

            Assert-MockCalled Invoke-RestMethod -Times 1 -ParameterFilter { $Uri -eq 'https://test.visualstudio.com/_apis/projects/Test?api-version=1.0' }
            Assert-MockCalled Invoke-RestMethod -Times 1 -ParameterFilter { $Method -eq 'Post' -and $Uri -eq 'https://test.visualstudio.com/_apis/projects/?api-version=1.0' -and $Body -eq '{"name": "Test", "description": "", "capabilities": {"versioncontrol": { "sourceControlType": "Tfvc"}, "processTemplate":{"templateTypeId": "6b724908-ef14-45cf-84f8-768b5384da45"}}}'}
         }
      }

      Context 'Add-VSTeamProject with Agile' {

         Mock Invoke-RestMethod { return @{status='inProgress'; id=1; url='https://someplace.com'} } -ParameterFilter { $Method -eq 'Post' -and $Uri -eq 'https://test.visualstudio.com/_apis/projects/?api-version=1.0'}
         Mock _trackProgress
         Mock Invoke-RestMethod { return @{id='123-5464-dee43'} } -ParameterFilter { $Uri -eq 'https://test.visualstudio.com/_apis/projects/Test?api-version=1.0' }

         It 'Should create project with Agile' {
            Add-VSTeamProject -ProjectName Test -processTemplate Agile

            Assert-MockCalled Invoke-RestMethod -Times 1 -ParameterFilter { $Uri -eq 'https://test.visualstudio.com/_apis/projects/Test?api-version=1.0' }
            Assert-MockCalled Invoke-RestMethod -Times 1 -ParameterFilter { $Method -eq 'Post' -and $Uri -eq 'https://test.visualstudio.com/_apis/projects/?api-version=1.0'}
         }
      }

      Context 'Add-VSTeamProject with CMMI' {

         Mock Invoke-RestMethod { return @{status='inProgress'; id=1; url='https://someplace.com'} } -ParameterFilter { $Method -eq 'Post' -and $Uri -eq 'https://test.visualstudio.com/_apis/projects/?api-version=1.0'}
         Mock _trackProgress
         Mock Invoke-RestMethod { return @{id='123-5464-dee43'} } -ParameterFilter { $Uri -eq 'https://test.visualstudio.com/_apis/projects/Test?api-version=1.0' }

         It 'Should create project with CMMI' {
            Add-VSTeamProject -ProjectName Test -processTemplate CMMI

            Assert-MockCalled Invoke-RestMethod -Times 1 -ParameterFilter { $Uri -eq 'https://test.visualstudio.com/_apis/projects/Test?api-version=1.0' }
            Assert-MockCalled Invoke-RestMethod -Times 1 -ParameterFilter { $Method -eq 'Post' -and $Uri -eq 'https://test.visualstudio.com/_apis/projects/?api-version=1.0'}
         }
      }

      Context 'Add-VSTeamProject throws error' {

         Mock Invoke-RestMethod { return @{status='inProgress'; id=1; url='https://someplace.com'} } -ParameterFilter { $Method -eq 'Post' -and $Uri -eq 'https://test.visualstudio.com/_apis/projects/?api-version=1.0'}
         Mock Write-Error
         Mock _trackProgress { throw 'Test error' }
         Mock Invoke-RestMethod { return @{id='123-5464-dee43'} } -ParameterFilter { $Uri -eq 'https://test.visualstudio.com/_apis/projects/Test?api-version=1.0' }

         It 'Should throw' { { Add-VSTeamProject -projectName Test -processTemplate CMMI } | Should throw
         }
      }
   }
}