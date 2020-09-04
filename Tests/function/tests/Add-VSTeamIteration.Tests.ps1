Set-StrictMode -Version Latest

Describe 'VSTeamIteration' {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath      
      . "$baseFolder/Source/Public/Add-VSTeamClassificationNode"

      ## Arrange
      Mock _getInstance { return 'https://dev.azure.com/test' }
      Mock _getApiVersion { return '5.0-unitTests' } -ParameterFilter { $Service -eq 'Core' }

      $classificationNodeResult = Get-Content "$sampleFiles\classificationNodeResult.json" -Raw | ConvertFrom-Json
      Mock Invoke-RestMethod { return $classificationNodeResult }
   }

   Context 'Add-VSTeamIteration' {
      It 'iteration should return Nodes' {
         ## Act
         Add-VSTeamIteration -ProjectName "Public Demo" -Name "MyClassificationNodeName"

         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Uri -like "https://dev.azure.com/test/Public Demo/_apis/wit/classificationnodes/iterations*" -and
            $Uri -like "*api-version=$(_getApiVersion Core)*" -and
            $Body -like '*"name":*"MyClassificationNodeName"*'
         }
      }

      It 'with Path "<Path>" should return Nodes' -TestCases @(
         @{ Path = 'SubPath' }
         @{ Path = 'Path/SubPath' }
      ) {
         param ($Path)
         ## Act
         Add-VSTeamIteration -ProjectName "Public Demo" -Name "MyClassificationNodeName" -Path $Path

         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Uri -like "https://dev.azure.com/test/Public Demo/_apis/wit/classificationnodes/iterations/$Path*" -and
            $Uri -like "*api-version=$(_getApiVersion Core)*" -and
            $Body -like '*"name":*"MyClassificationNodeName"*'
         }
      }

      It 'with empty Path "<Path>" should return Nodes' -TestCases @(
         @{Path = "" }
         @{Path = $null }
      ) {
         param ($Path)
         ## Act
         Add-VSTeamIteration -ProjectName "Public Demo" -Name "MyClassificationNodeName" -Path $Path

         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Uri -like "https://dev.azure.com/test/Public Demo/_apis/wit/classificationnodes/iterations?*" -and
            $Uri -like "*api-version=$(_getApiVersion Core)*" -and
            $Body -like '*"name":*"MyClassificationNodeName"*'
         }
      }
   }
}
