Set-StrictMode -Version Latest

Describe 'VSTeamWorkItemType' {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath
      . "$PSScriptRoot\..\..\..\Source\Public\Get-VSTeamWorkItemType.ps1"
      . "$PSScriptRoot\..\..\..\Source\Public\Unlock-VSTeamWorkItemType.ps1"
      $Global:PSDefaultParameterValues.Remove("*-vsteam*:projectName")

      ## Arrange
      # Set the account to use for testing. A normal user would do this
      # using the Set-VSTeamAccount function.
      Mock _getInstance { return 'https://dev.azure.com/test' }
      Mock _getApiVersion { return '1.0-unitTests' } -ParameterFilter { $Service -eq 'Processes' }

      Mock _callApi -ParameterFilter { $Method -eq 'Post' } -MockWith {
         return ([psCustomObject]@{name = 'Dummy' })
      }
      Mock _callApi -ParameterFilter { $Method -eq 'Patch' } -MockWith {
         return ([psCustomObject]@{name = 'Dummy' })
      }
      Mock Get-VSTeamWorkItemType   {
            $wits = @(
                  [psCustomObject]@{name            = 'Bug'
                                    customization   = 'system'
                                    referenceName   = 'Microsoft.VSTS.WorkItemTypes.Bug'
                                    icon            = 'icon_insect'
                                    color           = 'cc293d'
                                    isDisabled      =  $false
                                    description     = 'A divergence...'
                                    url             = 'http://bogus.none/workitemTypes/98'
                                    processTemplate = 'scrum'
                  }
                  [psCustomObject]@{name            = 'Gub'
                                    customization   = 'custom'
                                    icon            = 'icon_book'
                                    color           = 'ff0000'
                                    isDisabled      =  $false
                                    description     = 'Test Item'
                                    url             = 'http://bogus.none/workitemTypes/99'
                                    processTemplate = 'scrum'
                  }
               )
         if ($WorkItemType) { return $wits.where( { $_.name -like $WorkItemType }) }
         else               { return $wits }
      }


       Mock Write-Warning {
         return
      }

       Mock Unlock-VSTeamWorkItemType {
         return $WorkItemType
      }
   }

   Context 'Update WorkItem Types' {

      It 'Catches invalid WorkItem Type names.' {
         Set-VSTeamWorkItemType -ProcessTemplate "Scrum With Space" -WorkItemType NewWit -Description "New Work item Type" -Color ff0000  -Icon icon_asterisk -warningAction SilentlyContinue
         # Should not call the rest API from the function body, but may populate the work-item icons cache
         Should -Invoke _callApi -Exactly -Times 0 -Scope It {-not ($resource -eq "workitemicons")}
         Should -Invoke Write-Warning -Exactly -Times 1 -Scope It
      }
      It 'Patches custom WorkItem Types.' {
         Set-VSTeamWorkItemType -ProcessTemplate "Scrum With Space" -WorkItemType Gub -Description 'New Text' -Color Green  -Icon icon_book  -Force
         Should -Invoke _callApi -Exactly -Times 1 -Scope It -ParameterFilter {
            $Url    -like     '*99?api-version=*'           -and  #found expected item
            $Body   -match    '"isDisabled":\s+false'       -and  #Should expressly set
            $Body   -match    '"color":\s+"008000"'         -and  #Should convert from green
            $Body   -match    '"icon":\s+"icon_book"'       -and
            $Body   -match    '"description":\s+"New Text'  -and
            $Method -eq       'Patch'
         }
      }
       It 'Unlocks system WorkItem Types' {
         Set-VSTeamWorkItemType -ProcessTemplate "Scrum With Space" -WorkItemType Bug -Disabled -Force
         Should -Invoke Unlock-VSTeamWorkItemType -Exactly -Times 1
         Should -Invoke _callApi -Exactly -Times 1 -Scope It -ParameterFilter {
            $Url    -like     '*workitemTypes/98?api-version=*'           -and  #found expected item
            $Body   -match    '"isDisabled":\s+true'        -and
            $Method -eq       'Patch'
         }
      }
   }
}
