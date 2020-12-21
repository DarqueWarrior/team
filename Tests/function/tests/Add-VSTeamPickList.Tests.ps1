Set-StrictMode -Version Latest

Describe 'VSTeamPickList' {
    BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath

      ## Arrange
      # Set the account to use for testing.
      # A normal user would do this using the Set-VSTeamAccount function.
      [vsteam_lib.Versions]::Account = 'https://dev.azure.com/test'
      Mock _getApiVersion { return '1.0-unitTests' }
      Mock _callApi { return [pscustomobject]@{name='Office';id='693feca0-3123-41ba-8501-52d4882949c8'}}
   }

   Context 'Add-VSTeamPickList' {

      It 'should call the correct API for all items and set the correct type on them' {
         ## Act
        $p = Add-VSTeamPickList -Name Office -Items London, Paris -Force

         ## Assert
         Should -Invoke _callApi -Exactly -Scope It -Times 1 -ParameterFilter {
            $Method -eq 'Post' -and
            $area -eq 'work' -and
            $resource -eq 'processes/lists' -and
            $null -eq $id -and
            $body -match '"type":\s*"string"' -and
            $body -match '"name":\s*"Office"'-and
            $body -match '(?s)"items":\s*\[\s*"London",\s*"Paris"\s*\]'
         }
         $p.count | should -BeExactly 1
         $p.psobject.TypeNames| should -contain 'vsteam_lib.PickList'
      }
   }
}