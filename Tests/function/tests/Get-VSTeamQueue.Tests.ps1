Set-StrictMode -Version Latest

Describe 'VSTeamQueue' {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath
      . "$baseFolder/Source/Private/applyTypes.ps1"

      ## Arrange
      Mock _getInstance { return 'https://dev.azure.com/test' }
      Mock _getApiVersion { return '1.0-unitTests' } -ParameterFilter { $Service -eq 'DistributedTask' }

      Mock Invoke-RestMethod { return [PSCustomObject]@{ value = [PSCustomObject]@{ id = 3; name = 'Hosted'; pool = [PSCustomObject]@{ name = "Default" } } } }
      Mock Invoke-RestMethod { return [PSCustomObject]@{ id = 101; name = 'Hosted'; pool = [PSCustomObject]@{ name = "Default" } } } -ParameterFilter { $Uri -like "*101*" }
   }

   Context 'Get-VSTeamQueue' {
      It 'should return requested queue' {
         ## Act
         Get-VSTeamQueue -projectName project -queueId 101

         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -eq "https://dev.azure.com/test/project/_apis/distributedtask/queues/101?api-version=$(_getApiVersion DistributedTask)"
         }
      }

      it 'with actionFilter & queueName parameter should return all the queues' {
         ## Act
         Get-VSTeamQueue -projectName project -actionFilter 'None' -queueName 'Hosted'

         # With PowerShell core the order of the query string is not the
         # same from run to run!  So instead of testing the entire string
         # matches I have to search for the portions I expect but can't
         # assume the order.
         # The general string should look like this:
         # "https://dev.azure.com/test/project/_apis/distributedtask/queues/?api-version=$(_getApiVersion DistributedTask)&actionFilter=None&queueName=Hosted"
         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -like "*https://dev.azure.com/test/project/_apis/distributedtask/queues*" -and
            $Uri -like "*api-version=$(_getApiVersion DistributedTask)*" -and
            $Uri -like "*actionFilter=None*" -and
            $Uri -like "*queueName=Hosted*"
         }
      }

      it 'with no parameters should return all the queues' {
         ## Act
         Get-VSTeamQueue -ProjectName project

         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -eq "https://dev.azure.com/test/project/_apis/distributedtask/queues?api-version=$(_getApiVersion DistributedTask)"
         }
      }

      it 'with queueName parameter should return all the queues' {
         ## Act
         Get-VSTeamQueue -projectName project -queueName 'Hosted'

         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -eq "https://dev.azure.com/test/project/_apis/distributedtask/queues?api-version=$(_getApiVersion DistributedTask)&queueName=Hosted"
         }
      }

      it 'with actionFilter parameter should return all the queues' {
         ## Act
         Get-VSTeamQueue -projectName project -actionFilter 'None'

         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -eq "https://dev.azure.com/test/project/_apis/distributedtask/queues?api-version=$(_getApiVersion DistributedTask)&actionFilter=None"
         }
      }
   }
}