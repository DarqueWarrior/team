Set-StrictMode -Version Latest

Describe 'VSTeamProject' {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath
      . "$baseFolder/Source/Public/Get-VSTeamProject.ps1"
      . "$baseFolder/Source/Public/Get-VSTeamProcess.ps1"

      # Get-VSTeamProject to return project after creation
      Mock Invoke-RestMethod { Open-SampleFile 'Get-VSTeamProject-NamePeopleTracker.json' } -ParameterFilter {
         $Uri -eq "https://dev.azure.com/test/_apis/projects/Test?api-version=$(_getApiVersion Core)"
      }

      Mock Start-Sleep
      [vsteam_lib.Versions]::Account = 'https://dev.azure.com/test'
      Mock _getApiVersion { return '1.0-unitTests' }
      Mock _callApi { Open-SampleFile 'Get-VSTeamProcess.json' } -ParameterFilter { $area -eq 'work' -and $resource -eq 'processes' }

      # Get-VSTeamProject for cache
      Mock Invoke-RestMethod { return [pscustomobject]@{value=@()} } -ParameterFilter {
         $Uri -like "*stateFilter=WellFormed*"
      }
   }

   Context 'Add-VSTeamProject' {
      BeforeAll {
         Mock Write-Progress

         # Add Project
         Mock Invoke-RestMethod { return @{status = 'inProgress'; id = '123-5464-dee43'; url = 'https://someplace.com' } } -ParameterFilter {
            $Method -eq 'POST' -and
            $Uri -eq "https://dev.azure.com/test/_apis/projects?api-version=$(_getApiVersion Core)"
         }

         # Track Progress
         Mock Invoke-RestMethod {
            # This $i is in the module. Because we use InModuleScope
            # we can see it
            if ($i -gt 9) {
               return @{status = 'succeeded' }
            }

            return @{status = 'inProgress' }
         } -ParameterFilter {
            $Uri -eq 'https://someplace.com'
         }
      }

      It 'with tfvc should create project with tfvc' {
         Add-VSTeamProject -Name Test -tfvc

         Should -Invoke Invoke-RestMethod -Times 1 -Scope It  -ParameterFilter {
            $Uri -eq "https://dev.azure.com/test/_apis/projects/Test?api-version=$(_getApiVersion Core)"
         }

         Should -Invoke Invoke-RestMethod -Times 1 -Scope It  -ParameterFilter {
            $Method -eq 'Post' -and
            $Uri -eq "https://dev.azure.com/test/_apis/projects?api-version=$(_getApiVersion Core)" -and
            $Body -like '*"name":*"Test"*' -and
            $Body -like '*"templateTypeId":*6b724908-ef14-45cf-84f8-768b5384da45*' -and
            $Body -like '*"sourceControlType":*"Tfvc"*'
         }
      }
   }

   Context 'Add-VSTeamProject with Agile' {
      BeforeAll {
         Mock Invoke-RestMethod { return @{status = 'inProgress'; id = 1; url = 'https://someplace.com' } } -ParameterFilter { $Method -eq 'Post' -and $Uri -eq "https://dev.azure.com/test/_apis/projects?api-version=$(_getApiVersion Core)" }
         Mock _trackProjectProgress

         [vsteam_lib.ProcessTemplateCache]::Invalidate()
      }

      It 'Should create project with Agile' {
         Add-VSTeamProject -ProjectName Test -processTemplate Agile

         Should -Invoke Invoke-RestMethod -Times 1 -ParameterFilter { $Uri -eq "https://dev.azure.com/test/_apis/projects/Test?api-version=$(_getApiVersion Core)" }
         Should -Invoke Invoke-RestMethod -Times 1 -ParameterFilter { $Method -eq 'Post' -and $Uri -eq "https://dev.azure.com/test/_apis/projects?api-version=$(_getApiVersion Core)" }
      }
   }

   Context 'Add-VSTeamProject with CMMI' {
      BeforeAll {
         Mock Invoke-RestMethod { return @{status = 'inProgress'; id = 1; url = 'https://someplace.com' } } -ParameterFilter { $Method -eq 'Post' -and $Uri -eq "https://dev.azure.com/test/_apis/projects?api-version=$(_getApiVersion Core)" }
         Mock _trackProjectProgress
         Mock Get-VSTeamProcess { return [PSCustomObject]@{
               name   = 'CMMI'
               id     = 1
               Typeid = '00000000-0000-0000-0000-000000000002'
            }
         }
         [vsteam_lib.ProcessTemplateCache]::Invalidate()
      }

      It 'Should create project with CMMI' {
         Add-VSTeamProject -ProjectName Test -processTemplate CMMI

         Should -Invoke Invoke-RestMethod -Times 1 -ParameterFilter { $Uri -eq "https://dev.azure.com/test/_apis/projects/Test?api-version=$(_getApiVersion Core)" }
         Should -Invoke Invoke-RestMethod -Times 1 -ParameterFilter { $Method -eq 'Post' -and $Uri -eq "https://dev.azure.com/test/_apis/projects?api-version=$(_getApiVersion Core)" }
      }
   }

   Context 'Add-VSTeamProject throws error' {
      BeforeAll {
         Mock Invoke-RestMethod { return @{status = 'inProgress'; id = 1; url = 'https://someplace.com' } } -ParameterFilter { $Method -eq 'Post' -and $Uri -eq "https://dev.azure.com/test/_apis/projects?api-version=$(_getApiVersion Core)" }
         Mock Write-Error
         Mock _trackProjectProgress { throw 'Test error' }
      }

      It '_trackProjectProgress errors should throw' {
         { Add-VSTeamProject -projectName Test -processTemplate CMMI } | Should -Throw
      }
   }

   AfterAll {
      [vsteam_lib.Versions]::Account = 'https://dev.azure.com/test'
   }

}
