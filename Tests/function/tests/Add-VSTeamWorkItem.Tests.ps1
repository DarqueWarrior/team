Set-StrictMode -Version Latest

Describe 'VSTeamWorkItem' {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath
      . "$PSScriptRoot\..\..\..\Source\Public\Get-VSTeamWorkItemType.ps1"

      Mock _getInstance { return 'https://dev.azure.com/test' }
      Mock Invoke-RestMethod { Open-SampleFile 'Get-VSTeamWorkItem-Id16.json' }
      Mock _getApiVersion { return '1.0-unitTests' } -ParameterFilter { $Service -eq 'Core' }
   }

   Context 'Add-VSTeamWorkItem' {
      It 'Without Default Project should add work item' {
         ## Arrange
         $Global:PSDefaultParameterValues.Remove("*-vsteam*:projectName")

         ## Act
         Add-VSTeamWorkItem -ProjectName test -WorkItemType Task -Title Test

         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Method -eq 'Post' -and
            $Body -like '`[*' -and # Make sure the body is an array
            $Body -like '*`]' -and # Make sure the body is an array
            $ContentType -eq 'application/json-patch+json' -and
            $Uri -eq "https://dev.azure.com/test/test/_apis/wit/workitems/`$Task?api-version=$(_getApiVersion Core)"
         }
      }

      It 'With Default Project should add work item' {
         ## Arrange
         $Global:PSDefaultParameterValues["*-vsteam*:projectName"] = 'test'

         ## Act
         Add-VSTeamWorkItem -ProjectName test -WorkItemType Task -Title Test1 -Description Testing

         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Method -eq 'Post' -and
            $Body -like '`[*' -and # Make sure the body is an array
            $Body -like '*Test1*' -and
            $Body -like '*Testing*' -and
            $Body -like '*/fields/System.Title*' -and
            $Body -like '*/fields/System.Description*' -and
            $Body -like '*`]' -and # Make sure the body is an array
            $ContentType -eq 'application/json-patch+json' -and
            $Uri -eq "https://dev.azure.com/test/test/_apis/wit/workitems/`$Task?api-version=$(_getApiVersion Core)"
         }
      }

      It 'With Default Project should add work item with parent' {
         ## Arrange
         $Global:PSDefaultParameterValues["*-vsteam*:projectName"] = 'test'

         ## Act
         Add-VSTeamWorkItem -ProjectName test -WorkItemType Task -Title Test1 -Description Testing -ParentId 25

         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Method -eq 'Post' -and
            $Body -like '`[*' -and # Make sure the body is an array
            $Body -like '*Test1*' -and
            $Body -like '*Testing*' -and
            $Body -like '*/fields/System.Title*' -and
            $Body -like '*/fields/System.Description*' -and
            $Body -like '*/relations/-*' -and
            $Body -like '*_apis/wit/workitems/25*' -and
            $Body -like '*System.LinkTypes.Hierarchy-Reverse*' -and
            $Body -like '*`]' -and # Make sure the body is an array
            $ContentType -eq 'application/json-patch+json' -and
            $Uri -eq "https://dev.azure.com/test/test/_apis/wit/workitems/`$Task?api-version=$(_getApiVersion Core)"
         }
      }

      It 'With Default Project should add work item only with additional properties and parent id' {
         ## Arrange
         $Global:PSDefaultParameterValues["*-vsteam*:projectName"] = 'test'
         $additionalFields = @{"System.Tags" = "TestTag"; "System.AreaPath" = "Project\\MyPath" }

         ## Act
         Add-VSTeamWorkItem -ProjectName test -WorkItemType Task -Title Test1 -Description Testing -ParentId 25 -AdditionalFields $additionalFields

         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Method -eq 'Post' -and
            $Body -like '`[*' -and # Make sure the body is an array
            $Body -like '*Test1*' -and
            $Body -like '*Testing*' -and
            $Body -like '*/fields/System.Title*' -and
            $Body -like '*/fields/System.Description*' -and
            $Body -like '*/relations/-*' -and
            $Body -like '*_apis/wit/workitems/25*' -and
            $Body -like '*/fields/System.Tags*' -and
            $Body -like '*/fields/System.AreaPath*' -and
            $Body -like '*`]' -and # Make sure the body is an array
            $ContentType -eq 'application/json-patch+json' -and
            $Uri -eq "https://dev.azure.com/test/test/_apis/wit/workitems/`$Task?api-version=$(_getApiVersion Core)"
         }
      }

      It 'With Default Project should add work item only with additional properties' {
         ## Arrange
         $Global:PSDefaultParameterValues["*-vsteam*:projectName"] = 'test'
         $additionalFields = @{"System.Tags" = "TestTag"; "System.AreaPath" = "Project\\MyPath" }

         ## Act
         Add-VSTeamWorkItem -ProjectName test -WorkItemType Task -Title Test1 -AdditionalFields $additionalFields

         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Method -eq 'Post' -and
            $Body -like '`[*' -and # Make sure the body is an array
            $Body -like '*Test1*' -and
            $Body -like '*/fields/System.Title*' -and
            $Body -like '*/fields/System.Tags*' -and
            $Body -like '*/fields/System.AreaPath*' -and
            $Body -like '*`]' -and # Make sure the body is an array
            $ContentType -eq 'application/json-patch+json' -and
            $Uri -eq "https://dev.azure.com/test/test/_apis/wit/workitems/`$Task?api-version=$(_getApiVersion Core)"
         }
      }

      It 'With Default Project should throw exception when adding existing parameters to additional properties and parent id' {
         ## Arrange
         $Global:PSDefaultParameterValues["*-vsteam*:projectName"] = 'test'
         $additionalFields = @{"System.Title" = "Test1"; "System.AreaPath" = "Project\\TestPath" }

         ## Act / Assert
         { Add-VSTeamWorkItem -ProjectName test `
               -WorkItemType Task `
               -Title Test1 `
               -Description Testing `
               -ParentId 25 `
               -AdditionalFields $additionalFields } | Should -Throw
      }
   }
}
