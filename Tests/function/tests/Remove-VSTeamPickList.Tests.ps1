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

   Context 'Remove-VSTeamPickList' {

      It 'should call the correct API to delete a list.' {
         ## Act
         Remove-VSTeamPickList -PicklistID office -force

         ## Assert
         Should -Invoke _callApi -Exactly -Scope It -Times 1 -ParameterFilter {
            $method -eq 'DELETE' -and
            $url -match '693feca0-3123-41ba-8501-52d4882949c8'
         }
      }

   }
}