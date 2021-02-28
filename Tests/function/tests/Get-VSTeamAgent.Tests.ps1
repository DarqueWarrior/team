Set-StrictMode -Version Latest

Describe 'VSTeamAgent' {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath
      . "$baseFolder/Source/Public/Set-VSTeamDefaultProject.ps1"
      . "$baseFolder/Source/Public/Get-VSTeamProcess.ps1"


      ## Arrange
      Mock _getApiVersion { return '1.0-unitTests' } -ParameterFilter { $Service -eq 'DistributedTaskReleased' }
      Mock Invoke-RestMethod { return @() } -ParameterFilter {$Uri -like "*_apis/work/processes*" }
      Mock _getInstance { return 'https://dev.azure.com/test' }
      Mock Get-VSTeamProcess { return [PSCustomObject]@{
            name   = 'CMMI'
            id     = 1
            Typeid = '00000000-0000-0000-0000-000000000002'
         }
      }
      [vsteam_lib.ProcessTemplateCache]::Invalidate()

      # Even with a default set this URI should not have the project added.
      Set-VSTeamDefaultProject -Project Testing
   }

   Context 'Get-VSTeamAgent' {
      BeforeAll {
         Mock Invoke-RestMethod { Open-SampleFile 'Get-VSTeamAgent-PoolId1.json' }
         Mock Invoke-RestMethod { Open-SampleFile 'Get-VSTeamAgent-PoolId1.json' -Index 0 } -ParameterFilter { $Uri -like "*101*" }
      }

      it 'by pool id should return all the agents' {
         ## Act
         Get-VSTeamAgent -PoolId 1

         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Uri -eq "https://dev.azure.com/test/_apis/distributedtask/pools/1/agents?api-version=$(_getApiVersion DistributedTaskReleased)"
         }
      }

      it 'with agent id parameter should return on agent' {
         ## Act
         Get-VSTeamAgent -PoolId 1 -id 101

         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -eq "https://dev.azure.com/test/_apis/distributedtask/pools/1/agents/101?api-version=$(_getApiVersion DistributedTaskReleased)"
         }
      }

      it 'PoolID from pipeline by value should return all the agents' {
         ## Act
         1 | Get-VSTeamAgent

         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Uri -eq "https://dev.azure.com/test/_apis/distributedtask/pools/1/agents?api-version=$(_getApiVersion DistributedTaskReleased)"
         }
      }
   }
}

