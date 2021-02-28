Set-StrictMode -Version Latest

Describe 'VSTeamAccessControlList' {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath
      . "$baseFolder/Source/Public/Set-VSTeamDefaultProject.ps1"
      . "$baseFolder/Source/Public/Get-VSTeamProcess.ps1"

      ## Arrange
      # You have to set the version or the api-version will not be added when versions = ''
      Mock _getApiVersion { return '1.0-unitTests' } -ParameterFilter { $Service -eq 'Core' }

      $securityNamespaceObject = [vsteam_lib.SecurityNamespace]::new($(Open-SampleFile 'securityNamespace.json' -Index 0))

      # Set the account to use for testing. A normal user would do this
      # using the Set-VSTeamAccount function.
      Mock _getInstance { return 'https://dev.azure.com/test' }
      Mock Get-VSTeamProcess { return [PSCustomObject]@{
            name   = 'CMMI'
            id     = 1
            Typeid = '00000000-0000-0000-0000-000000000002'
         }
      }

   }

   Context 'Get-VSTeamAccessControlList' {
      BeforeAll {
         Mock Invoke-RestMethod { Open-SampleFile 'accessControlListResult.json' }
         Mock Invoke-RestMethod { throw 'Error' } -ParameterFilter { $Uri -like "*token=boom*" }
      }

      It 'by SecurityNamespaceId should return ACLs' {
         ## Arrange
         # Even with a default set this URI should not have the project added.
         Set-VSTeamDefaultProject -Project Testing

         ## Act
         Get-VSTeamAccessControlList -SecurityNamespaceId 5a27515b-ccd7-42c9-84f1-54c998f03866 `
            -Token "SomeToken" `
            -Descriptors "SomeDescriptor" `
            -IncludeExtendedInfo `
            -Recurse

         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Uri -like "https://dev.azure.com/test/_apis/accesscontrollists/5a27515b-ccd7-42c9-84f1-54c998f03866*" -and
            $Uri -like "*api-version=$(_getApiVersion Core)*" -and
            $Uri -like "*descriptors=SomeDescriptor*" -and
            $Uri -like "*includeExtendedInfo=True*" -and
            $Uri -like "*token=SomeToken*" -and
            $Uri -like "*recurse=True*"
         }
      }

      It 'by SecurityNamespace should return ACLs' {
         ## Act
         Get-VSTeamAccessControlList -SecurityNamespace $securityNamespaceObject `
            -Token "SomeToken" `
            -Descriptors "SomeDescriptor"

         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Uri -like "https://dev.azure.com/test/_apis/accesscontrollists/58450c49-b02d-465a-ab12-59ae512d6531*" -and
            $Uri -like "*api-version=$(_getApiVersion Core)*" -and
            $Uri -like "*descriptors=SomeDescriptor*" -and
            $Uri -like "*token=SomeToken*"
         }
      }

      It 'by SecurityNamespace (pipeline) should return ACEs' {
         ## Act
         $securityNamespaceObject | Get-VSTeamAccessControlList -Token "AcesToken" -Descriptors "AcesDescriptor"

         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Uri -like "https://dev.azure.com/test/_apis/accesscontrollists/58450c49-b02d-465a-ab12-59ae512d6531*" -and
            $Uri -like "*api-version=$(_getApiVersion Core)*" -and
            $Uri -like "*api-version=$(_getApiVersion Core)*" -and
            $Uri -like "*descriptors=AcesDescriptor*" -and
            $Uri -like "*token=AcesToken*"
         }
      }

      It 'by SecurityNamespaceId should throw' {
         ## Act / Assert
         { Get-VSTeamAccessControlList -SecurityNamespaceId 5a27515b-ccd7-42c9-84f1-54c998f03866 `
               -Token "boom" `
               -Descriptors "SomeDescriptor" `
               -IncludeExtendedInfo `
               -Recurse } | Should -Throw
      }

      It 'by SecurityNamespace should throw' {
         ## Act / Assert
         { Get-VSTeamAccessControlList  -SecurityNamespace $securityNamespaceObject `
               -Token "boom" `
               -Descriptors "SomeDescriptor" `
               -IncludeExtendedInfo `
               -Recurse } | Should -Throw
      }
   }
}
