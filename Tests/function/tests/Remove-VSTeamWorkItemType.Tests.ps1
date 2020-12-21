Set-StrictMode -Version Latest

Describe 'RemoveVSTeamWorkItemType' {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath
      . "$PSScriptRoot\..\..\..\Source\Public\Get-VSTeamProcess.ps1"
      . "$PSScriptRoot\..\..\..\Source\Public\Get-VSTeamWorkItemType.ps1"

      $Global:PSDefaultParameterValues.Remove("*-vsteam*:projectName")

      ## Arrange
      # Set the account to use for testing. A normal user would do this
      # using the Set-VSTeamAccount function.
      Mock _getInstance { return 'https://dev.azure.com/test' }
      Mock _getApiVersion { return '1.0-unitTests' } -ParameterFilter { $Service -eq 'Processes' }

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
      Mock _callApi -ParameterFilter {$Method -eq 'Delete'} {
            return $null
      }
      Mock Get-VSTeamWorkItemType {
            $wits = @(
                  [psCustomObject]@{name          = 'Bug'
                                    customization = 'system'
                                    referenceName = 'Microsoft.VSTS.WorkItemTypes.Bug'
                                    icon          = 'icon_insect'
                                    color         = 'cc293d'
                                    isDisabled    =  $false
                                    description   = 'A divergence...'
                                    url           = 'http://bogus.none/98'
                  }
                  [psCustomObject]@{name          = 'Gub'
                                    customization = 'custom'
                                    icon          = 'icon_book'
                                    color         = 'ff0000'
                                    isDisabled    =  $false
                                    description   = 'Test Item'
                                    url           = 'http://bogus.none/99';
                  }
               )
         if ($WorkItemType) { return $wits.where( { $_.name -like $WorkItemType }) }
         else               { return $wits }
      }
      [vsteam_lib.IconCache]::Invalidate()
      [vsteam_lib.ProcessTemplateCache]::Invalidate()
   }

   Context 'Delete workItem Type' {

      It 'Catches invalid WorkItem type names.' {
         Remove-VSTeamWorkItemType -ProcessTemplate "Scrum With Space" -WorkItemType NewWit -WarningVariable "Warn" -warningAction SilentlyContinue
         # Should not call the rest API from the function body, but may populate the work-item icons cache
         Should -Invoke _callApi -Exactly -Times 0 -Scope It {-not ($resource -eq "workitemicons")}
         $warn | Should -Match "'NewWit'.*Workitem type."
      }
      It 'Deletes custom WorkItem types.' {
         Remove-VSTeamWorkItemType -ProcessTemplate "Scrum With Space" -WorkItemType Gub -Force
         Should -Invoke _callApi -Exactly -Times 1 -Scope It -ParameterFilter {
            $Url    -like     '*99?api-version=*'           -and  #found expected item
            $Method -eq       'Delete'
         }
      }
       It 'Rejects deletion for system WorkItem Types' {
         Remove-VSTeamWorkItemType -ProcessTemplate "Scrum With Space" -WorkItemType Bug -WarningVariable "Warn" -warningAction SilentlyContinue
         Should -Invoke _callApi -Exactly -Times 0  -Scope It {-not ($resource -eq "workitemicons")}
         $warn | Should -Match "'Bug'.*Workitem type."

      }
   }
}
