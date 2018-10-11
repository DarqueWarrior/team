Set-StrictMode -Version Latest

InModuleScope extensions {
   [VSTeamVersions]::Account = 'https://dev.azure.com/test'
   Describe 'Extension' {
     
      $results = [PSCustomObject]@{
         count = 1
         value = [PSCustomObject]@{
            extensionId     = 'test'
            extensionName   = 'test'
            publisherId     = 'test'
            publisherName   = 'test'
            version         = '1.0.0'
            registrationId  = '12345678-9012-3456-7890-123456789012'
            manifestVersion = 1
            baseUri         = ''
            fallbackBaseUri = ''
            scopes          = [PSCustomObject]@{}
            installState    = [PSCustomObject]@{
               flags  = 'none'
            }   
         }
      }

      $singleResult = [PSCustomObject]@{
         extensionId     = 'test'
         extensionName   = 'test'
         publisherId     = 'test'
         publisherName   = 'test'
         version         = '1.0.0'
         registrationId  = '12345678-9012-3456-7890-123456789012'
         manifestVersion = 1
         baseUri         = ''
         fallbackBaseUri = ''
         scopes          = [PSCustomObject]@{}
         installState    = [PSCustomObject]@{
            flags  = 'none'
         }            
      }  
      
      Context 'Get-VSTeamExtension' {
         BeforeAll {
               $env:Team_TOKEN = '1234'
         }

         AfterAll {
               $env:TEAM_TOKEN = $null
         }

         Mock  _callAPI { return $results } 

         It 'Should return extensions' {
            Get-VSTeamExtension
   
            Assert-MockCalled _callAPI -Exactly 1 -Scope It -ParameterFilter {
               $Method -eq 'Get' -and
               $subDomain -eq 'extmgmt' -and
               $version -eq [VSTeamVersions]::ExtensionsManagement
               $Url -like "*https://extmgmt.dev.azure.com/test/_apis/_apis/extensionmanagement/installedextensions*"
            }
         }
      }
   
      Context 'Add-VSTeamExtension without version' {
         BeforeAll {
            $env:Team_TOKEN = '1234'
      }

      AfterAll {
            $env:TEAM_TOKEN = $null
      }

      Mock _callAPI { return $singleResult }
      
      
      It 'Should add an extension without version' {
         Add-VSTeamExtension -PublisherId 'test' -ExtensionId 'test'

         Assert-MockCalled _callAPI -Exactly 1 -Scope It -ParameterFilter {
            $Method -eq 'Get' -and
            $subDomain -eq 'extmgmt' -and
            $version -eq [VSTeamVersions]::ExtensionsManagement -and
            $uri 
            $Url -like "*https://extmgmt.dev.azure.com/test/_apis/_apis/extensionmanagement/installedextensionsbyname/test/test*"
         }
      }
   }

      Context 'Add-VSTeamExtension with version' {
         BeforeAll {
            $env:Team_TOKEN = '1234'
      }

      AfterAll {
            $env:TEAM_TOKEN = $null
      }

      Mock _callAPI { return $singleResult }
      
      
      It 'Should add an extension with version' {
         Add-VSTeamExtension -PublisherId 'test' -ExtensionId 'test' -Version '1.0.0'
    
         Assert-MockCalled _callAPI -Exactly 1 -Scope It -ParameterFilter {
            $Method -eq 'Get' -and
            $subDomain -eq 'extmgmt' -and
            $version -eq [VSTeamVersions]::ExtensionsManagement
            $Url -like "*https://extmgmt.dev.azure.com/test/_apis/_apis/extensionmanagement/installedextensionsbyname/test/test/1.0.0*"
            }
       }
   }

      Context 'Update-VSTeamExtension' {
         BeforeAll {
            $env:Team_TOKEN = '1234'
      }

      AfterAll {
            $env:TEAM_TOKEN = $null
      }

      Mock _callAPI { return $singleResult }
      
      It 'Should add an extension without version' {
         Update-VSTeamExtension -PublisherId 'test' -ExtensionId 'test'

         Assert-MockCalled _callAPI -Exactly 1 -Scope It -ParameterFilter {
            $Method -eq 'Post' -and
            $subDomain -eq 'extmgmt' -and
            $version -eq [VSTeamVersions]::ExtensionsManagement
            $Url -like "*https://extmgmt.dev.azure.com/test/_apis/_apis/extensionmanagement/installedextensionsbyname/test/test*"
         }       
      }
   }

   Context 'Remove-VSTeamExtension' {
      BeforeAll {
         $env:Team_TOKEN = '1234'
   }

   AfterAll {
         $env:TEAM_TOKEN = $null
   }

   Mock _callAPI { return $singleResult }
   
   It 'Should remove an extension' {
      Update-VSTeamExtension -PublisherId 'test' -ExtensionId 'test'

      Assert-MockCalled _callAPI -Exactly 1 -Scope It -ParameterFilter {
         $Method -eq 'Delete' -and
         $subDomain -eq 'extmgmt' -and
         $version -eq [VSTeamVersions]::ExtensionsManagement
         $Url -like "*https://extmgmt.dev.azure.com/test/_apis/_apis/extensionmanagement/installedextensionsbyname/test/test*"
      }       
   }
   }
   }
}