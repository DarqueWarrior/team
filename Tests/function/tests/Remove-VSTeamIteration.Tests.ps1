Set-StrictMode -Version Latest

Describe 'VSTeamIteration' {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath

      . "$baseFolder/Source/Public/Remove-VSTeamClassificationNode.ps1"

      Mock _getInstance { return 'https://dev.azure.com/test' }
      Mock _getApiVersion { return '5.0-unitTests' } -ParameterFilter { $Service -eq 'Core' }
   }

   Context 'Remove-VSTeamIteration' {
      BeforeAll {
         Mock Invoke-RestMethod {
            #Write-Host $args
            return $null
         }
      }

      It 'should delete iteration' -TestCases @(
      ) {
         ## Act
         Remove-VSTeamIteration -ProjectName "Public Demo" -Force

         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Method -eq "Delete" -and
            $Uri -like "https://dev.azure.com/test/Public Demo/_apis/wit/classificationnodes/iterations*" -and
            $Uri -like "*api-version=$(_getApiVersion Core)*"
         }
      }

      It 'should delete iteration with reclassification id <ReClassifyId>' -TestCases @(
         @{ReClassifyId = 4 }
      ) {
         param ($ReClassifyId)
         ## Act
         Remove-VSTeamIteration -ProjectName "Public Demo" -ReClassifyId $ReClassifyId -Force

         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Method -eq "Delete" -and
            $Uri -like "https://dev.azure.com/test/Public Demo/_apis/wit/classificationnodes/iterations*" -and
            $Uri -like "*api-version=$(_getApiVersion Core)*"
         }
      }

      It 'with Path "<Path>" should delete iteration' -TestCases @(
         @{Path = "SubPath" }
         @{Path = "Path/SubPath" }
      ) {
         param ($Path)
         ## Act
         Remove-VSTeamIteration -ProjectName "Public Demo" -Path $Path -Force

         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Method -eq "Delete" -and
            $Uri -like "https://dev.azure.com/test/Public Demo/_apis/wit/classificationnodes/iterations/$Path*" -and
            $Uri -like "*api-version=$(_getApiVersion Core)*"
         }
      }

      It 'with empty Path "<Path>" should delete iteration' -TestCases @(
         @{Path = "" }
         @{Path = $null }
      ) {
         param ($Path)
         ## Act
         Remove-VSTeamIteration -ProjectName "Public Demo" -Path $Path -Force

         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Method -eq "Delete" -and
            $Uri -like "https://dev.azure.com/test/Public Demo/_apis/wit/classificationnodes/iterations?*" -and
            $Uri -like "*api-version=$(_getApiVersion Core)*"
         }
      }
   }
}