Set-StrictMode -Version Latest

Describe 'VSTeamWiql' {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath
      . "$baseFolder/Source/Public/Get-VSTeamWorkItem.ps1"

      Mock _getInstance { return 'https://dev.azure.com/test' }
   }

   Context 'Get-VSTeamWiql' {
      BeforeAll {
         Mock Invoke-RestMethod { Open-SampleFile 'Get-VSTeamWiql.json' }

         # function is mocked because it is used when switch 'Expanded' is being used.
         Mock Get-VSTeamWorkItem { Open-SampleFile 'Get-VSTeamWorkItem-Id.json' }

         $Global:PSDefaultParameterValues.Remove("*-vsteam*:projectName")

         $wiqlQuery = "Select [System.Id], [System.Title], [System.State] From WorkItems"
      }

      It 'Get work items with custom WIQL query' {
         Get-VSTeamWiql -ProjectName "test" -Team "test team" -Query $wiqlQuery

         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Method -eq 'Post' -and
            $Body -like '`{*' -and # Make sure the body is an object
            $Body -like "*[System.Id]*" -and
            $Body -like "*[System.Title]*" -and
            $Body -like "*[System.State]*" -and
            $Body -like '*`}' -and # Make sure the body is an object
            $ContentType -eq 'application/json' -and
            $Uri -eq "https://dev.azure.com/test/test/test team/_apis/wit/wiql?api-version=$(_getApiVersion Core)&`$top=100"
         }
      }

      It 'Get work items with custom WIQL query with -Top 250' {
         Get-VSTeamWiql -ProjectName "test" -Team "test team" -Query $wiqlQuery -Top 250

         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Method -eq 'Post' -and
            $Body -like '`{*' -and # Make sure the body is an object
            $Body -like "*[System.Id]*" -and
            $Body -like "*[System.Title]*" -and
            $Body -like "*[System.State]*" -and
            $Body -like '*`}' -and # Make sure the body is an object
            $ContentType -eq 'application/json' -and
            $Uri -eq "https://dev.azure.com/test/test/test team/_apis/wit/wiql?api-version=$(_getApiVersion Core)&`$top=250"
         }
      }

      It 'Get work items with custom WIQL query with -Top 0' {
         Get-VSTeamWiql -ProjectName "test" -Team "test team" -Query $wiqlQuery -Top 0

         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Method -eq 'Post' -and
            $Body -like '`{*' -and # Make sure the body is an object
            $Body -like "*[System.Id]*" -and
            $Body -like "*[System.Title]*" -and
            $Body -like "*[System.State]*" -and
            $Body -like '*`}' -and # Make sure the body is an object
            $ContentType -eq 'application/json' -and
            $Uri -eq "https://dev.azure.com/test/test/test team/_apis/wit/wiql?api-version=$(_getApiVersion Core)"
         }
      }

      It 'Get work items with custom WIQL query with expanded work items' {
         Get-VSTeamWiql -ProjectName "test" -Team "test team" -Query $wiqlQuery -Expand

         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Method -eq 'Post' -and
            $Body -like '`{*' -and # Make sure the body is an object
            $Body -like "*[System.Id]*" -and
            $Body -like "*[System.Title]*" -and
            $Body -like "*[System.State]*" -and
            $Body -like '*`}' -and # Make sure the body is an object
            $ContentType -eq 'application/json' -and
            $Uri -eq "https://dev.azure.com/test/test/test team/_apis/wit/wiql?api-version=$(_getApiVersion Core)&`$top=100"
         }
      }

      It 'Get work items with custom WIQL query with time precision' {
         Get-VSTeamWiql -ProjectName "test" -Team "test team" -Query $wiqlQuery -TimePrecision

         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Method -eq 'Post' -and
            $Body -like '`{*' -and # Make sure the body is an object
            $Body -like "*[System.Id]*" -and
            $Body -like "*[System.Title]*" -and
            $Body -like "*[System.State]*" -and
            $Body -like '*`}' -and # Make sure the body is an object
            $ContentType -eq 'application/json' -and
            $Uri -like "*timePrecision=True*" -and
            $Uri -like "*`$top=100*" -and
            $Uri -like "https://dev.azure.com/test/test/test team/_apis/wit/wiql?api-version=$(_getApiVersion Core)*"
         }
      }

      It 'Get work items with query ID query' {
         Get-VSTeamWiql -ProjectName "test" -Team "test team" -Id 1

         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -eq "https://dev.azure.com/test/test/test team/_apis/wit/wiql/1?api-version=$(_getApiVersion Core)&`$top=100"
         }
      }

      It 'Get work items with query ID query with expanded work items' {
         Get-VSTeamWiql -ProjectName "test" -Team "test team" -Id 1 -Expand

         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -eq "https://dev.azure.com/test/test/test team/_apis/wit/wiql/1?api-version=$(_getApiVersion Core)&`$top=100"
         }
      }

      It 'Get work items with query that returns only 1 work item and Expand' {
         Mock Invoke-RestMethod { Write-Host $args; Open-SampleFile 'Get-VSTeamWiql-OneWorkItem.json' }

         Get-VSTeamWiql -ProjectName "test" -Team "test team" -Id 1 -Expand

         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -eq "https://dev.azure.com/test/test/test team/_apis/wit/wiql/1?api-version=$(_getApiVersion Core)&`$top=100"
         }
      }
   }
}