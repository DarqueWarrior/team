Set-StrictMode -Version Latest

Describe 'VSTeamField' {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath

      ## Arrange
      # Set the account to use for testing. Field cache relies on versions.account
      # A normal user would do this using the Set-VSTeamAccount function.
      [vsteam_lib.Versions]::Account = 'https://dev.azure.com/test'
      Mock _getApiVersion { return '1.0-unitTests' }
      [vsteam_lib.FieldCache]::Invalidate()

      Mock _callApi {
         if ($id) {return [pscustomobject]@{name='History'}}
         else     {return ([pscustomobject]@{Value=@([pscustomobject]@{name='History';referenceName = 'System.History'},[pscustomobject]@{name='State';referenceName = 'System.State'})})}}
   }

   Context 'Get-VSTeamField' {

      It 'should call the correct API for all items and set the correct type on them' {
         ## Act
        $f = Get-VSTeamField

         ## Assert
         Should -Invoke _callApi -Exactly -Scope It -Times 1 -ParameterFilter {
            $area     -eq 'wit' -and
            $resource -eq 'fields' -and
            $null     -eq $id
         }
         $f.count | should -BeGreaterThan 1
         $f[0].psobject.TypeNames| should -contain 'vsteam_lib.Field'
      }

      It 'should call the correct API for a single item  and set the correct type on it' {
            ## Act
         $f = Get-VSTeamField -ReferenceName History

            ## Assert
            Should -Invoke _callApi -Exactly -Scope It -Times 1 -ParameterFilter {
               $area -eq 'wit' -and
               $resource -eq 'fields' -and
               $id -eq  'System.History'
            }
            $f.count | should -BeExactly 1
            $f.psobject.TypeNames| should -contain 'vsteam_lib.Field'
      }
   }
}