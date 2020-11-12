Set-StrictMode -Version Latest

Describe 'AddVSTeamWorkItemType' {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath
      . "$PSScriptRoot\..\..\..\Source\Public\Get-VSTeamProcess.ps1"

      $Global:PSDefaultParameterValues.Remove("*-vsteam*:projectName")

      ## Arrange
      # Set the account to use for testing. A normal user would do this
      # using the Set-VSTeamAccount function.
      Mock _getInstance { return 'https://dev.azure.com/test' }
      Mock _getApiVersion { return '1.0-unitTests' } -ParameterFilter { $Service -eq 'Processes' }

      Mock Get-VSTeamProcess {
         $processes = @(
            [PSCustomObject]@{Name = "Scrum";            url = 'http://bogus.none/1'; ID = "6b724908-ef14-45cf-84f8-768b5384da45" },
            [PSCustomObject]@{Name = "Basic";            url = 'http://bogus.none/2'; ID = "b8a3a935-7e91-48b8-a94c-606d37c3e9f2" },
            [PSCustomObject]@{Name = "CMMI";             url = 'http://bogus.none/3'; ID = "27450541-8e31-4150-9947-dc59f998fc01" },
            [PSCustomObject]@{Name = "Agile";            url = 'http://bogus.none/4'; ID = "adcc42ab-9882-485e-a3ed-7678f01f66bc" },
            [PSCustomObject]@{Name = "Scrum With Space"; url = 'http://bogus.none/5'; ID = "12345678-0000-0000-0000-000000000000" }
         )
         if ($name) { return $processes.where( { $_.name -like $name }) }
         else { return $processes }
      }
      Mock _callApi -ParameterFilter { $Method -eq 'Post' } -MockWith {
         return ([psCustomObject]@{name = 'Dummy' })
      }
   }

   Context 'Add-VSTeamWorkItemType' {
      BeforeAll {
            [vsteam_lib.ProcessTemplateCache]::Invalidate()
      }
      It 'Calls the API with the expected body. ' {
         Add-VSTeamWorkItemType -ProcessTemplate Scrum -WorkItemType NewWit -Description "New Work item Type" -Color Red  -Icon asterisk
         Should -Invoke _callApi -Exactly -Times 1 -Scope It -ParameterFilter {
            $Url -like 'https://dev.azure.com/test/_apis/work/processes/6b724908-ef14-45cf-84f8-768b5384da45/workitemtypes?api-version=*' -and
            $Body -match '"name":\s+"NewWit"' -and
            $Body -match '"color":\s+"ff0000"' -and
            $Body -match '"icon":\s+"icon_asterisk"' -and
            $Body -match '"description":\s+"New Work item Type"' -and
            $Method -eq 'Post'
         }
      }
   }
}