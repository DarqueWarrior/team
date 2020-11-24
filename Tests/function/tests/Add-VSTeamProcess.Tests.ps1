Set-StrictMode -Version Latest

Describe 'VSTeamProcess' {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath
      . "$PSScriptRoot\..\..\..\Source\Public\Get-VSTeamProcess.ps1"


      ## Arrange
      # Set the account to use for testing. A normal user would do this
      # using the Set-VSTeamAccount function.
      Mock _getInstance      { return 'https://dev.azure.com/test' }
      Mock _getApiVersion    { return '1.0-unitTests' }

      Mock _callApi          {
            #Return a single process object. Any process will do.
            return ([psCustomObject]@{
               typeId              = '6b724908-ef14-45cf-84f8-768b5384da45'
               name                = 'Scrum'
               referenceName       = ''
               description         = 'This template is for teams who follow the Scrum framework.'
               parentProcessTypeId = '00000000-0000-0000-0000-000000000000'
               isEnabled           = $True
               isDefault           = $True
               customizationType   = 'system'
               })
      }
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

   Context 'Add-VSTeamProcess' {

      It 'Posts with basic parameters when creating new process templates' {
         Add-VsteamProcess -Parent "Scrum" -processName "Scrum2","Scrum3" -Force
         Should -Invoke _callApi -Exactly -Times 1 -Scope It -ParameterFilter {
            $Method    -eq       'Post'                      -and
            $NoProject -eq       $true                       -and
            $area      -eq       'Work'                      -and
            $resource  -eq       'processes'                 -and
            $Body      -match    '"name":\s+"Scrum2"'        -and
            $Body      -notmatch 'ReferenceName|Description' -and

            $Body      -match    '"parentProcessTypeId":\s+"6b724908-ef14-45cf-84f8-768b5384da45"'
         }
         Should -Invoke _callApi -Exactly -Times 1 -Scope It -ParameterFilter {
            $Method    -eq       'Post'                      -and
            $NoProject -eq       $true                       -and
            $area      -eq       'Work'                      -and
            $resource  -eq       'processes'                 -and
            $Body      -match    '"name":\s+"Scrum3"'        -and
            $Body      -notmatch 'ReferenceName|Description' -and
            $Body      -match    '"parentProcessTypeId":\s+"6b724908-ef14-45cf-84f8-768b5384da45"'
         }
      }
      It 'Uses more than one template and Posts with ref name and description when creating a new process template.' {
         Add-VsteamProcess -Parent "Agile" -processName "Agile2" -referenceName "Custom.agile2" -Desc "Custom agile process" -Force
         Should -Invoke _callApi -Exactly -Times 1 -Scope It -ParameterFilter {
            $NoProject -eq       $true
            $area      -eq       'Work'
            $resource  -eq       'processes'
            $Body   -match '"parentProcessTypeId":\s+"adcc42ab-9882-485e-a3ed-7678f01f66bc"' -and
            $Body   -match '"name":\s+"Agile2"'                       -and
            $Body   -match '"ReferenceName":\s+"Custom\.agile2"'      -and
            $Body   -match '"Description":\s+"Custom agile process"'  -and
            $Method -eq       'Post'
         }
      }
   }
}