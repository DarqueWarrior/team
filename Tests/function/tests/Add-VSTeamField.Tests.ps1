Set-StrictMode -Version Latest

Describe 'VSTeamField' {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath
      . "$PSScriptRoot\..\..\..\Source\Public\Get-VSTeamPickList.ps1"
      ## Arrange
      # Set the account to use for testing. Field cache relies on versions.account
      # A normal user would do this using the Set-VSTeamAccount function.
      [vsteam_lib.Versions]::Account = 'https://dev.azure.com/test'
      Mock _getApiVersion { return '1.0-unitTests' }

      Mock Get-VSTeamPickList{return [PSCustomObject]@{ Name = 'Offices';id='b34dd44a-954e-433d-b8a8-c3e8c72698a7'}}

      Mock _callApi {         return [pscustomobject]@{name='Office'}   }
   }
   Context 'Add-VSTeamField' {

      It 'should call the correct API to create a field and set the correct type on the returned item' {
         ## Act
        [vsteam_lib.PickListCache]::Invalidate()
        $f = Add-VSTeamField -Force -Name "Office" -PicklistID Offices

         ## Assert
         Should -Invoke _callApi -Scope It -ParameterFilter {
            $method   -eq 'Post'
            $area     -eq 'wit' -and
            $resource -eq 'fields' -and
            $null     -eq $id -and
            $body -match '"name":\s*"Office"' -and
            $body -match '"picklistId":\s*"b34dd44a-954e-433d-b8a8-c3e8c72698a7"'-and
            $body -match '"readonly":\s*false'-and
            $body -match '"type":\s*"string"'-and
            $body -match '"usage":\s*"workitem"'
         } -Times 1   -Exactly
         $f.count | should -BeExactly  1
         $f.psobject.TypeNames| should -Contain 'vsteam_lib.Field'
      }
   }
}