Set-StrictMode -Version Latest

Describe 'VSTeamMembership' {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath
      . "$baseFolder/Source/Private/callMembershipAPI.ps1"

      ## Arrange
      Mock _supportsGraph
      Mock _getApiVersion { return '5.0' } -ParameterFilter { $Service -eq 'Graph' }

      # Set the account to use for testing. A normal user would do this
      # using the Set-VSTeamAccount function.
      Mock _getInstance { return 'https://dev.azure.com/test' }

      Mock Invoke-RestMethod

      $UserDescriptor = 'aad.OTcyOTJkNzYtMjc3Yi03OTgxLWIzNDMtNTkzYmM3ODZkYjlj'
      $GroupDescriptor = 'vssgp.Uy0xLTktMTU1MTM3NDI0NS04NTYwMDk3MjYtNDE5MzQ0MjExNy0yMzkwNzU2MTEwLTI3NDAxNjE4MjEtMC0wLTAtMC0x'
   }

   Context 'Test-VSTeamMembership' {
      It 'Should test membership' {
         ## Act
         $result = Test-VSTeamMembership -MemberDescriptor $UserDescriptor -ContainerDescriptor $GroupDescriptor

         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Method -eq "Head" -and
            $Uri -like "https://vssps.dev.azure.com/test/_apis/graph/memberships/$UserDescriptor/$GroupDescriptor*" -and
            $Uri -like "*api-version=$(_getApiVersion Graph)*"
         }

         $result | Should -Be $true
      }
   }
}