Set-StrictMode -Version Latest

Describe 'VSTeamWorkItemIterationPermission' {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath

      . "$baseFolder/Source/Classes/VSTeamLeaf.ps1"
      . "$baseFolder/Source/Classes/VSTeamDirectory.ps1"
      . "$baseFolder/Source/Classes/VSTeamWorkItemIterationPermissions.ps1"
      . "$baseFolder/Source/Classes/VSTeamSecurityNamespace.ps1"
      . "$baseFolder/Source/Private/applyTypes.ps1"
      . "$baseFolder/Source/Public/Get-VSTeamClassificationNode.ps1"
      . "$baseFolder/Source/Public/Add-VSTeamAccessControlEntry.ps1"

      $userSingleResult = Get-Content "$sampleFiles\users.single.json" -Raw | ConvertFrom-Json
      $userSingleResultObject = [vsteam_lib.User2]::new($userSingleResult)

      $groupSingleResult = Get-Content "$sampleFiles\groupsSingle.json" -Raw | ConvertFrom-Json
      $groupSingleResultObject = [vsteam_lib.Group]::new($groupSingleResult)

      $projectResult = [PSCustomObject]@{
         name        = 'Test Project Public'
         description = ''
         url         = ''
         id          = '010d06f0-00d5-472a-bb47-58947c230876'
         state       = ''
         visibility  = ''
         revision    = [long]0
         defaultTeam = [PSCustomObject]@{ }
         _links      = [PSCustomObject]@{ }
      }

      $projectResultObject = [vsteam_lib.Project]::new($projectResult)

      $accessControlEntryResult =
      @"
{
   "count": 1,
   "value": [
     {
       "descriptor": "Microsoft.TeamFoundation.Identity;S-1-9-1551374245-1204400969-2402986413-2179408616-0-0-0-0-1",
       "allow": 8,
       "deny": 0,
       "extendedInfo": {}
     }
   ]
}
"@ | ConvertFrom-Json

      $classificationNodeIterationId =
      @"
{
   "count": 1,
   "value": [
     {
       "id": 20,
       "identifier": "18e7998d-d0c5-4c01-b547-d7d4eb4c97c5",
       "name": "Sprint 3",
       "structureType": "iteration",
       "hasChildren": false,
       "path": "\\Demo Public\\Iteration\\Sprint 3",
       "_links": {
         "self": {
           "href": "https://dev.azure.com/vsteampsmoduletest/53e2997d-3723-4c1c-aa62-a0194cb65a29/_apis/wit/classificationNodes/Iterations/Sprint%203"
         },
         "parent": {
           "href": "https://dev.azure.com/vsteampsmoduletest/53e2997d-3723-4c1c-aa62-a0194cb65a29/_apis/wit/classificationNodes/Iterations"
         }
       },
       "url": "https://dev.azure.com/vsteampsmoduletest/53e2997d-3723-4c1c-aa62-a0194cb65a29/_apis/wit/classificationNodes/Iterations/Sprint%203"
     }
   ]
 }
"@ | ConvertFrom-Json | Select-Object -ExpandProperty value

      $classificationNodeIterationIdObject = [vsteam_lib.ClassificationNode]::new($classificationNodeIterationId, "test")

      $iterationRootNode =
      @"
{
   "id": 16,
   "identifier": "dfa90792-403a-4119-a52b-bd142c08291b",
   "name": "Demo Public",
   "structureType": "iteration",
   "hasChildren": true,
   "path": "\\Demo Public\\Iteration",
   "_links": {
     "self": {
       "href": "https://dev.azure.com/vsteampsmoduletest/53e2997d-3723-4c1c-aa62-a0194cb65a29/_apis/wit/classificationNodes/Iterations"
     }
   },
   "url": "https://dev.azure.com/vsteampsmoduletest/53e2997d-3723-4c1c-aa62-a0194cb65a29/_apis/wit/classificationNodes/Iterations"
 }
"@ | ConvertFrom-Json

      $iterationRootNodeObject = [vsteam_lib.ClassificationNode]::new($iterationRootNode, "test")

      # Set the account to use for testing. A normal user would do this
      # using the Set-VSTeamAccount function.
      Mock _getInstance { return 'https://dev.azure.com/test' }

      # You have to set the version or the api-version will not be added when versions = ''
      Mock _getApiVersion { return '1.0-unitTests' } -ParameterFilter { $Service -eq 'Core' }
   }

   Context 'Add-VSTeamWorkItemIterationPermission' {
      BeforeAll {
         Mock Get-VSTeamClassificationNode { return $iterationRootNodeObject }
         Mock Get-VSTeamClassificationNode { return $classificationNodeIterationIdObject } -ParameterFilter { $Ids -eq 44 -or $Path -eq "Sprint 1" }

         Mock Invoke-RestMethod {
            # If this test fails uncomment the line below to see how the mock was called.
            # Write-Host $args
            return $accessControlEntryResult
         }
      }

      It 'by IterationID and User should return ACEs' {
         Add-VSTeamWorkItemIterationPermission -Project $projectResultObject -IterationID 44 -User $userSingleResultObject -Allow ([VSTeamWorkItemIterationPermissions]'GENERIC_READ,CREATE_CHILDREN') -Deny ([VSTeamWorkItemIterationPermissions]'DELETE')
         Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Uri -like "https://dev.azure.com/test/_apis/accesscontrolentries/bf7bfa03-b2b7-47db-8113-fa2e002cc5b1*" -and
            $Uri -like "*api-version=$(_getApiVersion Core)*" -and
            $Body -like "*`"token`": `"vstfs:///Classification/Node/dfa90792-403a-4119-a52b-bd142c08291b:vstfs:///Classification/Node/18e7998d-d0c5-4c01-b547-d7d4eb4c97c5`",*" -and
            $Body -like "*`"descriptor`": `"Microsoft.IdentityModel.Claims.ClaimsIdentity;788df857-dcd8-444d-885e-bff359bc1982\\test@testuser.com`",*" -and
            $Body -like "*`"allow`": 5,*" -and
            $Body -like "*`"deny`": 8,*" -and
            $Method -eq "Post"
         }
      }

      It 'by IterationID and Group should return ACEs' {
         Add-VSTeamWorkItemIterationPermission -Project $projectResultObject -IterationID 44 -Group $groupSingleResultObject -Allow ([VSTeamWorkItemIterationPermissions]'GENERIC_READ,CREATE_CHILDREN') -Deny ([VSTeamWorkItemIterationPermissions]'DELETE')
         Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Uri -like "https://dev.azure.com/test/_apis/accesscontrolentries/bf7bfa03-b2b7-47db-8113-fa2e002cc5b1*" -and
            $Uri -like "*api-version=$(_getApiVersion Core)*" -and
            $Body -like "*`"token`": `"vstfs:///Classification/Node/dfa90792-403a-4119-a52b-bd142c08291b:vstfs:///Classification/Node/18e7998d-d0c5-4c01-b547-d7d4eb4c97c5`",*" -and
            $Body -like "*`"descriptor`": `"Microsoft.TeamFoundation.Identity;S-1-9-1551374245-856009726-4193442117-2390756110-2740161821-0-0-0-0-1`",*" -and
            $Body -like "*`"allow`": 5,*" -and
            $Body -like "*`"deny`": 8,*" -and
            $Method -eq "Post"
         }
      }

      It 'by IterationID and Descriptor should return ACEs' {
         Add-VSTeamWorkItemIterationPermission -Project $projectResultObject -IterationID 44 -Descriptor "Microsoft.TeamFoundation.Identity;S-1-9-1551374245-856009726-4193442117-2390756110-2740161821-0-0-0-0-1" -Allow ([VSTeamWorkItemIterationPermissions]'GENERIC_READ,CREATE_CHILDREN') -Deny ([VSTeamWorkItemIterationPermissions]'DELETE')
         Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Uri -like "https://dev.azure.com/test/_apis/accesscontrolentries/bf7bfa03-b2b7-47db-8113-fa2e002cc5b1*" -and
            $Uri -like "*api-version=$(_getApiVersion Core)*" -and
            $Body -like "*`"token`": `"vstfs:///Classification/Node/dfa90792-403a-4119-a52b-bd142c08291b:vstfs:///Classification/Node/18e7998d-d0c5-4c01-b547-d7d4eb4c97c5`",*" -and
            $Body -like "*`"descriptor`": `"Microsoft.TeamFoundation.Identity;S-1-9-1551374245-856009726-4193442117-2390756110-2740161821-0-0-0-0-1`",*" -and
            $Body -like "*`"allow`": 5,*" -and
            $Body -like "*`"deny`": 8,*" -and
            $Method -eq "Post"
         }
      }

      It 'by IterationPath and User should return ACEs' {
         Add-VSTeamWorkItemIterationPermission -Project $projectResultObject -IterationPath "Sprint 1" -User $userSingleResultObject -Allow ([VSTeamWorkItemIterationPermissions]'GENERIC_READ,CREATE_CHILDREN') -Deny ([VSTeamWorkItemIterationPermissions]'DELETE')
         Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Uri -like "https://dev.azure.com/test/_apis/accesscontrolentries/bf7bfa03-b2b7-47db-8113-fa2e002cc5b1*" -and
            $Uri -like "*api-version=$(_getApiVersion Core)*" -and
            $Body -like "*`"token`": `"vstfs:///Classification/Node/dfa90792-403a-4119-a52b-bd142c08291b:vstfs:///Classification/Node/18e7998d-d0c5-4c01-b547-d7d4eb4c97c5`",*" -and
            $Body -like "*`"descriptor`": `"Microsoft.IdentityModel.Claims.ClaimsIdentity;788df857-dcd8-444d-885e-bff359bc1982\\test@testuser.com`",*" -and
            $Body -like "*`"allow`": 5,*" -and
            $Body -like "*`"deny`": 8,*" -and
            $Method -eq "Post"
         }
      }

      It 'by IterationPath and Group should return ACEs' {
         Add-VSTeamWorkItemIterationPermission -Project $projectResultObject -IterationPath "Sprint 1" -Group $groupSingleResultObject -Allow ([VSTeamWorkItemIterationPermissions]'GENERIC_READ,CREATE_CHILDREN') -Deny ([VSTeamWorkItemIterationPermissions]'DELETE')
         Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Uri -like "https://dev.azure.com/test/_apis/accesscontrolentries/bf7bfa03-b2b7-47db-8113-fa2e002cc5b1*" -and
            $Uri -like "*api-version=$(_getApiVersion Core)*" -and
            $Body -like "*`"token`": `"vstfs:///Classification/Node/dfa90792-403a-4119-a52b-bd142c08291b:vstfs:///Classification/Node/18e7998d-d0c5-4c01-b547-d7d4eb4c97c5`",*" -and
            $Body -like "*`"descriptor`": `"Microsoft.TeamFoundation.Identity;S-1-9-1551374245-856009726-4193442117-2390756110-2740161821-0-0-0-0-1`",*" -and
            $Body -like "*`"allow`": 5,*" -and
            $Body -like "*`"deny`": 8,*" -and
            $Method -eq "Post"
         }
      }

      It 'by IterationPath and Descriptor should return ACEs' {
         Add-VSTeamWorkItemIterationPermission -Project $projectResultObject -IterationPath "Sprint 1" -Descriptor "Microsoft.TeamFoundation.Identity;S-1-9-1551374245-856009726-4193442117-2390756110-2740161821-0-0-0-0-1" -Allow ([VSTeamWorkItemIterationPermissions]'GENERIC_READ,CREATE_CHILDREN') -Deny ([VSTeamWorkItemIterationPermissions]'DELETE')
         Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Uri -like "https://dev.azure.com/test/_apis/accesscontrolentries/bf7bfa03-b2b7-47db-8113-fa2e002cc5b1*" -and
            $Uri -like "*api-version=$(_getApiVersion Core)*" -and
            $Body -like "*`"token`": `"vstfs:///Classification/Node/dfa90792-403a-4119-a52b-bd142c08291b:vstfs:///Classification/Node/18e7998d-d0c5-4c01-b547-d7d4eb4c97c5`",*" -and
            $Body -like "*`"descriptor`": `"Microsoft.TeamFoundation.Identity;S-1-9-1551374245-856009726-4193442117-2390756110-2740161821-0-0-0-0-1`",*" -and
            $Body -like "*`"allow`": 5,*" -and
            $Body -like "*`"deny`": 8,*" -and
            $Method -eq "Post"
         }
      }
   }
}