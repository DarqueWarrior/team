Set-StrictMode -Version Latest

Describe 'VSTeamWorkItemType' {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath
      . "$PSScriptRoot\..\..\..\Source\Public\Get-VSTeamProcess.ps1"

      $Global:PSDefaultParameterValues.Remove("*-vsteam*:projectName")

      ## Arrange
      # Set the account to use for testing. A normal user would do this
      # using the Set-VSTeamAccount function.
      Mock _getInstance { return 'https://dev.azure.com/test' }
      Mock _getApiVersion { return '1.0-unitTests' } 
      Mock Get-VSTeamProcess {
         $processes = @(
            [PSCustomObject]@{Name = "Scrum"; url = 'http://bogus.none/1'; ID = "6b724908-ef14-45cf-84f8-768b5384da45" },
            [PSCustomObject]@{Name = "Basic"; url = 'http://bogus.none/2'; ID = "b8a3a935-7e91-48b8-a94c-606d37c3e9f2" },
            [PSCustomObject]@{Name = "CMMI"; url = 'http://bogus.none/3'; ID = "27450541-8e31-4150-9947-dc59f998fc01" },
            [PSCustomObject]@{Name = "Agile"; url = 'http://bogus.none/4'; ID = "adcc42ab-9882-485e-a3ed-7678f01f66bc" },
            [PSCustomObject]@{Name = "Scrum With Space"; url = 'http://bogus.none/5'; ID = "12345678-0000-0000-0000-000000000000" }
         )
         if ($name) { return $processes.where( { $_.name -like $name }) }
         else { return $processes }  
      }
      [vsteam_lib.ProcessTemplateCache]::Invalidate()
   }

   Context 'Get-VSTeamWorkItemType' {
      BeforeAll {
         Mock Invoke-RestMethod { Get-Content "$sampleFiles\get-vsteamworkitemtype.json" -Raw  } ##<<This file doesn't properly read as JSON!!!
         Mock Invoke-RestMethod { Open-SampleFile 'bug.json' -Json } -ParameterFilter {
            $Uri -like "*bug*" 
         }
         Mock Invoke-RestMethod { ( Get-Content "$sampleFiles\get-vsteamworkitemtype.json" -Raw ).Replace('"":', '"_end":') | ConvertFrom-Json  } -ParameterFilter {
            $Uri -like "*processes*" 
         }
         Mock Invoke-RestMethod {@() } -ParameterFilter {
            $Uri -like "*workitemtypecategories*" 
         }
       
      }

      It 'should return all work item types when called with project only' {
         ## Act
         $wit = Get-VSTeamWorkItemType -ProjectName VSTeamWorkItemType

         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -eq "https://dev.azure.com/test/VSTeamWorkItemType/_apis/wit/workitemtypes?api-version=$(_getApiVersion Core)"
         }
         $wit.count | should -BeGreaterThan 1
      }


      It 'should return 1 work item type when called with type & default project ' {
         ## Arrange
         $Global:PSDefaultParameterValues["*-vsteam*:projectName"] = 'VSTeamWorkItemType'

         ## Act
         $wit = Get-VSTeamWorkItemType -WorkItemType bug

         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -eq "https://dev.azure.com/test/VSTeamWorkItemType/_apis/wit/workitemtypes?api-version=$(_getApiVersion Core)"
         }
         $wit.count | Should -BeExactly 1
      }

      It 'should return 1 work item type when by with type & explicit project ' {
         ## Arrange
         $Global:PSDefaultParameterValues.Remove("*-vsteam*:projectName")

         ## Act
         $wit = Get-VSTeamWorkItemType -ProjectName VSTeamWorkItemType -WorkItemType bug

         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -eq "https://dev.azure.com/test/VSTeamWorkItemType/_apis/wit/workitemtypes?api-version=$(_getApiVersion Core)"
         }
         $wit.count | should -BeExactly 1
      }

      It 'should return all work item types when with processTemplate' {
         ## Act   
         $wit = Get-VSTeamWorkItemType -ProcessTemplate Scrum

         ##Assert
         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -like "https://dev.azure.com/test/_apis/work/processes/6b724908-ef14-45cf-84f8-768b5384da45/workitemtypes?api-version=$(_getApiVersion Processes)"
         }
         $wit.count | should -BeGreaterThan 1
      }
  }
}