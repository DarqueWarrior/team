Set-StrictMode -Version Latest

Describe 'VSTeamProcess' {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath
      . "$PSScriptRoot\..\..\..\Source\Public\Get-VSTeamProcess.ps1"

      ## Arrange
      # Set the account to use for testing. A normal user would do this
      # using the Set-VSTeamAccount function.
      [vsteam_lib.Versions]::Account = 'https://dev.azure.com/test'
      Mock _getApiVersion    { return '1.0-unitTests' }

      Mock _callApi          { return }
      Mock Get-VSTeamProcess {
         $processes =  @(
            [PSCustomObject]@{Name = "Scrum";            ID = "6b724908-ef14-45cf-84f8-768b5384da45"},
            [PSCustomObject]@{Name = "Basic";            ID = "b8a3a935-7e91-48b8-a94c-606d37c3e9f2"},
            [PSCustomObject]@{Name = "CMMI";             ID = "27450541-8e31-4150-9947-dc59f998fc01"},
            [PSCustomObject]@{Name = "Agile";            ID = "adcc42ab-9882-485e-a3ed-7678f01f66bc"},
            [PSCustomObject]@{Name = "Scrum With Space"; ID = "12345678-0000-0000-0000-000000000000"}
         )
         if ($name) {return $processes.where({$_.name -like $name})}
         else       {return $processes}
      }


     [vsteam_lib.ProcessTemplateCache]::Invalidate()
   }

   Context 'Remove VSTeamProcess' {

      It 'Calls the Correct API  ' {
         Remove-VsteamProcess -ProcessTemplate "Scrum" -Force
         Should -Invoke _callApi -Exactly -Times 1 -Scope It -ParameterFilter {
            $Url    -like     '*/_apis/work/processes/6b724908-ef14-45cf-84f8-768b5384da45?*'       -and
            $Method -eq       'Delete'
         }
      }
   }

   AfterAll {
      [vsteam_lib.Versions]::Account = 'https://dev.azure.com/test'
   }

}