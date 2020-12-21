Set-StrictMode -Version Latest

Describe 'VSTeamPickList' {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath
      . "$PSScriptRoot\..\..\..\Source\Public\Get-VSTeamPickList.ps1"

      ## Arrange
      # Set the account to use for testing.
      # A normal user would do this using the Set-VSTeamAccount function.
      [vsteam_lib.Versions]::Account = 'https://dev.azure.com/test'
      Mock _getApiVersion { return '1.0-unitTests' }
      Mock _callApi {
         if ($id -or $method -eq 'put') {
                   return [pscustomobject]@{name='Office';id='693feca0-3123-41ba-8501-52d4882949c8';url='https://dev.azure.com/test/_apis/work/processes/lists/693feca0-3123-41ba-8501-52d4882949c8'}
         }
         else     {return ([pscustomobject]@{Value=@([pscustomobject]@{name='Office';id='693feca0-3123-41ba-8501-52d4882949c8'},[pscustomobject]@{name='State';id = '693feca0-3123-41ba-8501-52d4882949c8'})})}
      }
   }

   Context 'Set-VSTeamPickList' {

      It 'should call the correct API to change a list and set the correct type on the result' {
         ## Act
         $p = Set-VSTeamPickList -PicklistID office -RemoveOldItems -Newitems London, Dublin -Force

         ## Assert
         Should -Invoke _callApi -Exactly -Scope It -Times 1 -ParameterFilter {
            $method -eq 'Put' -and
            $body -match '"(?s)Items":\s*\[\s*"London"\s*,\s*"Dublin"\s*\]'
         }
         $p.count | should -BeExactly 1
         $p.psobject.TypeNames| should -contain 'vsteam_lib.PickList'
      }

   }
}