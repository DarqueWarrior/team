Set-StrictMode -Version Latest

# Loading System.Web avoids issues finding System.Web.HttpUtility
Add-Type -AssemblyName 'System.Web'

InModuleScope buildDefinitions {
   $VSTeamVersionTable.Account = 'https://test.visualstudio.com'

   $results = [PSCustomObject]@{
      value = [PSCustomObject]@{
         id         = 42
         name       = 'builddef'
         queue      = [PSCustomObject]@{ name = 'Default' }
         _links     = [PSCustomObject]@{}
         variables  = [PSCustomObject]@{}
         repository = [PSCustomObject]@{}
         project    = [PSCustomObject]@{ name = 'project' }
         authoredBy = [PSCustomObject]@{ id = 1; name = 'test'; uniqueName = 'test'; displayName = 'Test' }
      }
   }

   Describe 'BuildDefinitions' {
      # Mock the call to Get-Projects by the dynamic parameter for ProjectName
      Mock Invoke-RestMethod { return @() } -ParameterFilter {
         $Uri -like "*_apis/projects*" 
      }
   
      . "$PSScriptRoot\mockProjectNameDynamicParamNoPSet.ps1"

      Context 'Show-VSTeamBuildDefinition by ID' {
         Mock Show-Browser { }
         
         it 'should return url for mine' {
            Show-VSTeamBuildDefinition -projectName project -Id 15

            Assert-MockCalled Show-Browser -Exactly -Scope It -Times 1 -ParameterFilter {
               $url -eq 'https://test.visualstudio.com/project/_build/index?definitionId=15'
            }
         }
      }

      Context 'Show-VSTeamBuildDefinition Mine' {
         Mock Show-Browser { }
         
         it 'should return url for mine' {
            Show-VSTeamBuildDefinition -projectName project -Type Mine

            Assert-MockCalled Show-Browser -Exactly -Scope It -Times 1 -ParameterFilter {
               $url -eq 'https://test.visualstudio.com/project/_build/index?_a=mine&path=%5c'
            }
         }
      }

      Context 'Show-VSTeamBuildDefinition XAML' {
         Mock Show-Browser { }
         
         it 'should return url for XAML' {
            Show-VSTeamBuildDefinition -projectName project -Type XAML

            Assert-MockCalled Show-Browser -Exactly -Scope It -Times 1 -ParameterFilter {
               $url -eq 'https://test.visualstudio.com/project/_build/xaml&path=%5c'
            }
         }
      }

      Context 'Show-VSTeamBuildDefinition Queued' {
         Mock Show-Browser { }

         it 'should return url for Queued' {
            Show-VSTeamBuildDefinition -projectName project -Type Queued

            Assert-MockCalled Show-Browser -Exactly -Scope It -Times 1 -ParameterFilter {
               $url -eq 'https://test.visualstudio.com/project/_build/index?_a=queued&path=%5c'
            }
         }
      }

      Context 'Show-VSTeamBuildDefinition Mine with path' {
         Mock Show-Browser { }

         it 'should return url for mine' {
            Show-VSTeamBuildDefinition -projectName project -path '\test'

            Assert-MockCalled Show-Browser -Exactly -Scope It -Times 1 -ParameterFilter {
               $url -like 'https://test.visualstudio.com/project/_Build/index?_a=allDefinitions&path=%5Ctest'
            }
         }
      }

      Context 'Show-VSTeamBuildDefinition Mine with path missing \' {
         Mock Show-Browser { }

         it 'should return url for mine with \ added' {
            Show-VSTeamBuildDefinition -projectName project -path 'test'

            Assert-MockCalled Show-Browser -Exactly -Scope It -Times 1 -ParameterFilter {
               $url -like 'https://test.visualstudio.com/project/_Build/index?_a=allDefinitions&path=%5Ctest'
            }
         }
      }

      Context 'Get-VSTeamBuildDefinition with no parameters' {
         Mock _useWindowsAuthenticationOnPremise { return $true }
         Mock Invoke-RestMethod {
            return $results 
         }

         It 'should return build definitions' {
            Get-VSTeamBuildDefinition -projectName project

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter { 
               $Uri -eq "https://test.visualstudio.com/project/_apis/build/definitions/?api-version=$($VSTeamVersionTable.Build)&type=All"
            }
         }
      }

      Context 'Get-VSTeamBuildDefinition with type parameter' {
         Mock Invoke-RestMethod {
            return $results 
         }

         It 'should return build definitions by type' {
            Get-VSTeamBuildDefinition -projectName project -type build

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Uri -eq "https://test.visualstudio.com/project/_apis/build/definitions/?api-version=$($VSTeamVersionTable.Build)&type=build"
            }
         }
      }

      Context 'Get-VSTeamBuildDefinition with filter parameter' {
         Mock Invoke-RestMethod { return $results }

         It 'should return build definitions by filter' {
            Get-VSTeamBuildDefinition -projectName project -filter 'click*'

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Uri -like "*https://test.visualstudio.com/project/_apis/build/definitions/*" -and
               $Uri -like "*api-version=$($VSTeamVersionTable.Build)*" -and
               $Uri -like "*name=click*" -and
               $Uri -like "*type=All*"
            }
         }
      }

      Context 'Get-VSTeamBuildDefinition with both parameters' {
         Mock Invoke-RestMethod { return $results }

         It 'should return build definitions by filter' {
            Get-VSTeamBuildDefinition -projectName project -filter 'click*' -type build

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Uri -like "*https://test.visualstudio.com/project/_apis/build/definitions/*" -and
               $Uri -like "*api-version=$($VSTeamVersionTable.Build)*" -and
               $Uri -like "*name=click*" -and
               $Uri -like "*type=build*"
            }
         }
      }

      Context 'Add-VSTeamBuildDefinition' {
         Mock Invoke-RestMethod { return $results }

         it 'Should add build' {
            Add-VSTeamBuildDefinition -projectName project -inFile 'builddef.json'

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Method -eq 'Post' -and
               $InFile -eq 'builddef.json' -and
               $Uri -eq "https://test.visualstudio.com/project/_apis/build/definitions/?api-version=$($VSTeamVersionTable.Build)"
            }
         }
      }

      Context 'Get-VSTeamBuildDefinition by ID' {
         Mock Invoke-RestMethod { return @{
               id         = 0
               name       = ''
               queue      = @{}
               _links     = @{}
               project    = @{}
               variables  = @{}
               repository = @{}
               authoredBy = @{ id = 0; uniqueName = ''; displayName = ''; name = '' }
            }}

         It 'should return build definition' {
            Get-VSTeamBuildDefinition -projectName project -id 15

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Uri -eq "https://test.visualstudio.com/project/_apis/build/definitions/15?api-version=$($VSTeamVersionTable.Build)"
            }
         }
      }

      Context 'Get-VSTeamBuildDefinition by ID local auth' {
         Mock _useWindowsAuthenticationOnPremise { return $true }
         Mock Invoke-RestMethod { return [PSCustomObject]@{
               id         = 0
               name       = ''
               queue      = [PSCustomObject]@{}
               _links     = [PSCustomObject]@{}
               project    = [PSCustomObject]@{}
               variables  = [PSCustomObject]@{}
               repository = [PSCustomObject]@{}
               authoredBy = [PSCustomObject]@{ id = 0; uniqueName = ''; displayName = ''; name = '' }
            }}

         It 'should return build definition' {
            Get-VSTeamBuildDefinition -projectName project -id 15

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Uri -eq "https://test.visualstudio.com/project/_apis/build/definitions/15?api-version=$($VSTeamVersionTable.Build)"
            }
         }
      }

      Context 'Get-VSTeamBuildDefinition with revision parameter' {
         Mock Invoke-RestMethod { return @{
               id         = 0
               name       = ''
               queue      = @{}
               _links     = @{}
               project    = @{}
               authoredBy = @{ id = 0; uniqueName = ''; displayName = ''; name = '' }
            }}

         It 'should return build definitions by revision' {
            Get-VSTeamBuildDefinition -projectName project -id 16 -revision 1

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Uri -eq "https://test.visualstudio.com/project/_apis/build/definitions/16?api-version=$($VSTeamVersionTable.Build)&revision=1"
            }
         }
      }

      Context 'Remove-VSTeamBuildDefinition' {
         Mock Invoke-RestMethod { return $results }

         It 'should delete build definition' {
            Remove-VSTeamBuildDefinition -projectName project -id 2 -Force

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Method -eq 'Delete' -and 
               $Uri -eq "https://test.visualstudio.com/project/_apis/build/definitions/2?api-version=$($VSTeamVersionTable.Build)"
            }
         }
      }

      Context 'Update-VSTeamBuildDefinition' {
         Mock Invoke-RestMethod { return $results }

         It 'should update build definition' {
            Update-VSTeamBuildDefinition -projectName project -id 2 -inFile 'builddef.json' -Force

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Method -eq 'Put' -and
               $InFile -eq 'builddef.json' -and
               $Uri -eq "https://test.visualstudio.com/project/_apis/build/definitions/2?api-version=$($VSTeamVersionTable.Build)"
            }
         }
      }

      # Make sure these test run last as the need differnt 
      # $VSTeamVersionTable.Account values
      Context 'Get-VSTeamBuildDefinition with no account' {
         $VSTeamVersionTable.Account = $null

         It 'should return build definitions' {
            { Get-VSTeamBuildDefinition -projectName project } | Should Throw
         }
      }

      Context 'Add-VSTeamBuildDefinition on TFS local Auth' {
         Mock Invoke-RestMethod { return $results }
         Mock _useWindowsAuthenticationOnPremise { return $true }
         $VSTeamVersionTable.Account = 'http://localhost:8080/tfs/defaultcollection'

         it 'Should add build' {
            Add-VSTeamBuildDefinition -projectName project -inFile 'builddef.json'

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Method -eq 'Post' -and
               $InFile -eq 'builddef.json' -and
               $Uri -eq "http://localhost:8080/tfs/defaultcollection/project/_apis/build/definitions/?api-version=$($VSTeamVersionTable.Build)"
            }
         }
      }

      Context 'Remove-VSTeamBuildDefinition on TFS local Auth' {
         Mock Invoke-RestMethod { return $results }
         Mock _useWindowsAuthenticationOnPremise { return $true }
         $VSTeamVersionTable.Account = 'http://localhost:8080/tfs/defaultcollection'

         Remove-VSTeamBuildDefinition -projectName project -id 2 -Force
         
         It 'should delete build definition' {
            Assert-MockCalled Invoke-RestMethod -Exactly -Scope Context -Times 1 -ParameterFilter {
               $Method -eq 'Delete' -and 
               $Uri -eq "http://localhost:8080/tfs/defaultcollection/project/_apis/build/definitions/2?api-version=$($VSTeamVersionTable.Build)"
            }
         }
      }

      Context 'Update-VSTeamBuildDefinition on TFS local Auth' {
         Mock Invoke-RestMethod { return $results }
         Mock _useWindowsAuthenticationOnPremise { return $true }
         $VSTeamVersionTable.Account = 'http://localhost:8080/tfs/defaultcollection'

         Update-VSTeamBuildDefinition -projectName project -id 2 -inFile 'builddef.json' -Force
         
         It 'should update build definition' {
            Assert-MockCalled Invoke-RestMethod -Exactly -Scope Context -Times 1 -ParameterFilter {
               $Method -eq 'Put' -and
               $InFile -eq 'builddef.json' -and
               $Uri -eq "http://localhost:8080/tfs/defaultcollection/project/_apis/build/definitions/2?api-version=$($VSTeamVersionTable.Build)"
            }
         }
      }
   }
}