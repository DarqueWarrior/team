Set-StrictMode -Version Latest

Describe "VSTeam" {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath
   }

   Context "Get-VSTeamWorkItemIconList" {
   
      BeforeAll {
         Mock _getInstance { return 'https://dev.azure.com/test' }
         Mock _getApiVersion { return '1.0-unitTests' } 
         Mock _callApi {return [pscustomObject]@{value="Dummy"}}
      }
      It 'Should call the API correctly' {

         ## Act
         Get-VSTeamWorkItemIconList
         ## Assert
         Should -Invoke _callApi -Exactly 1 -ParameterFilter {
               $Area -eq 'wit' -and   $Resource -eq 'workitemicons' -and $IgnoreDefaultProject -eq $true
         }
      }
   }
}
