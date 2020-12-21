Set-StrictMode -Version Latest

Describe 'VSTeamPickList' {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath

      ## Arrange
      # Set the account to use for testing.
      # A normal user would do this using the Set-VSTeamAccount function.
      [vsteam_lib.Versions]::Account = 'https://dev.azure.com/test'
      Mock _getApiVersion { return '1.0-unitTests' }
      Mock _callApi {
         if ($id) {return [pscustomobject]@{name='Office';id='693feca0-3123-41ba-8501-52d4882949c8'}}
         else     {return ([pscustomobject]@{Value=@([pscustomobject]@{name='Office';id='693feca0-3123-41ba-8501-52d4882949c8'},[pscustomobject]@{name='State';id = '693feca0-3123-41ba-8501-52d4882949c8'})})}}
   }

   Context 'Get-VSTeamPickList' {

      It 'should call the correct API for all items and set the correct type on them' {
         ## Act
        $p = Get-VSTeamPickList

         ## Assert
         Should -Invoke _callApi -Exactly -Scope It -Times 1 -ParameterFilter {
            $area -eq 'work' -and
            $resource -eq 'processes/lists' -and
            $null -eq $id
         }
         $p.count | should -BeGreaterThan 1
         $p[0].psobject.TypeNames| should -contain 'vsteam_lib.PickList'
      }


      It 'should call the correct API for a single item  and set the correct type on it' {
            ## Act
         $f = Get-VSTeamPickList -PicklistID Office

            ## Assert
            Should -Invoke _callApi -Exactly -Scope It -Times 1 -ParameterFilter {
               $area     -eq 'work'             -and
               $resource -eq 'processes/lists' -and
               $id       -eq '693feca0-3123-41ba-8501-52d4882949c8'
            }
            $f.count | should -BeExactly 1
            $f.psobject.TypeNames| should -contain 'vsteam_lib.PickList'
      }
   }
}