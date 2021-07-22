# Changelog

## 7.4.0

Merged [Pull Request](https://github.com/DarqueWarrior/vsteam/pull/400) from [Sebastian Schütze](https://github.com/SebastianSchuetze) which included the following:

- Fixes ambiguity of parameter sets in VSTeamUserEntitlement cmdlets [#393](https://github.com/DarqueWarrior/vsteam/issues/393)

Merged [Pull Request](https://github.com/DarqueWarrior/vsteam/pull/408) from [Sebastian Schütze](https://github.com/SebastianSchuetze) which included the following:

- Added `Set-VSTeamPipelineAuthorization` to set pipeline authorizations.

## 7.3.0

Merged [Pull Request](https://github.com/DarqueWarrior/vsteam/pull/396) from [Markus Blaschke](https://github.com/mblaschke) which included the following:

- Fixed the problem of JSON serialization with the message "WARNING: Resulting JSON is truncated as serialization has exceeded the set depth of 2" for most the cmdlets that post complex json bodies.

Merged [Pull Request](https://github.com/DarqueWarrior/vsteam/pull/384) from [Sebastian Schütze](https://github.com/SebastianSchuetze) which included the following:

- Add-VSTeamPool, Remove-VSTeamPool and Update-VSTeampool for handling agent pools on Azure DevOps

Merged [Pull Request](https://github.com/MethodsAndPractices/vsteam/pull/374) from [hkarthik7](https://github.com/hkarthik7) which includes the following:

- Added a new parameter artifactVersionId to Get-VSTeamRelease cmdlet. This will help to return the release for passed artifact Id. For instance the release details of a build can be retrieved by passing build Id to the cmdlet.

```powershell
$buildId = Get-VSTeamBuild -Top 1
Get-VSTeamRelease -artifactVersionId $buildId.Id
```

Merged [Pull Request](https://github.com/DarqueWarrior/vsteam/pull/386) from [Sebastian Schütze](https://github.com/SebastianSchuetze) which included the following:

- added the cmdlet Add-VSTeamBuildPermission following the other cmdlet like Add-VSTeamProjectPermission
- changed internal permission (ACL) functions to not have deny or allow permissions to be mandatory, because this caused not to be able to only add allow or deny permissions.
- allowed to handle user accounts from typ 'srv' which are service accounts of Azure DevOps. Now these can be permitted as well to all functions using ACLs

Merged [Pull Request](https://github.com/DarqueWarrior/vsteam/pull/397) from [Sebastian Schütze](https://github.com/SebastianSchuetze) which included the following:

- Fixes encoding problem with special charcters on Add-VSTeamWorkItem, Update-VSTeamWorkItem, Update-VSTeamUserEntitlement [#397](https://github.com/DarqueWarrior/vsteam/issues/365)

## 7.2.0

Merged [Pull Request](https://github.com/DarqueWarrior/vsteam/pull/371) and (https://github.com/DarqueWarrior/vsteam/pull/389) from [Sebastian Schütze](https://github.com/SebastianSchuetze) which included the following:

- Added Set-VSTeamPipelineBilling to buy or release Microsoft-hosted and self-hosted agents
- Added Get-VSTeamAccounts to get the organizations where the user has access. Where the given user is either a member or an owner
- Added Get-VSTeamUserProfile that gets the users profile of an account.
- Added Get-VSTeamBillingAccount to get information whether the account is connected to a subscription or not.
- fixed filenames of files to work on linux (casing)
- added the possibility to call _callApi with a custom bearer token
- added the possibility to call _callApi without the account name in the url

## 7.1.4

Combined all the build json files (_types.json, _formats.json and _functions.json) into a single file called config.json in the root folder.
Fixed issue #376

## 7.1.3

Merged [Pull Request](https://github.com/DarqueWarrior/vsteam/pull/350) from [Daniel Silva](https://github.com/DanielSSilva) which included the following:

- Fixed exception thrown by the Update-VSTeamPullRequest when status is set to "completed", by adding the missing "lastMergeSourceCommit" property to body.

Also added Clear-VSTeamDefaultProjectCount and Set-VSTeamDefaultProjectCount to control the default number of projects returned for tab completion and validation. By default only 100 projects are returned and the 100 returned is nondeterministic. But calling Set-VSTeamDefaultProjectCount you can increase the number of projects returned.


## 7.1.2

Merged [Pull Request](https://github.com/DarqueWarrior/vsteam/pull/366) from [Jhoneill](https://github.com/jhoneill) which included the following:

- Fix Query Cache [#365](https://github.com/DarqueWarrior/vsteam/issues/365)

Changed Get-VSTeamProject to return all projects by default instead of just the top 100. This change was made to address issue #363. If your project name was not in the top 100 projects validation would fail. Returning all projects can have performance issues. You can set the value for top used by setting a PowerShell default value:

```powershell
$Global:PSDefaultParameterValues["*-vsteam*:top"] = 500
```

Fixed issue #360 by updating the way DateTimes are tested.

## 7.1.1

Fixed bug in Test-VSTeamYamlPipeline by adding a Pipelines version value.

## 7.1.0

Added:

- Get-VSTeamPackage to return packages of a feed.
- Show-VSTeamPackage to open package in default browser.
- Get-VSTeamPackageVersion to return all the versions of a package.
- Update-VSTeamNuGetPackageVersion to list and un-list versions.

## 7.0.1

Merged [Pull Request](https://github.com/DarqueWarrior/vsteam/pull/354)

- Fixed bug [353](https://github.com/MethodsAndPractices/vsteam/issues/353)
- Added TriggerInfo to vsteam_lib.Build class

## 7.0.0

## Breaking changes

All classes are moved to a new C# class library.

You must have [.netCore](dot.net) installed to build the class lib on macOS, Linux and Windows.

All types were changed from 'Team.' to 'vsteam_lib.' this will make it easy when moving types from PowerShell to C#.

VSTeamDescriptor is now vsteam_lib.Descriptor and no longer has a Descriptor property. Use the Id, Name or ToString() property in its place.

ProjectName is now a named parameter for most functions. This freed position 0 for other parameters to make functions easier to use.

User2 is now vsteam_lib.User

Removed CUID from vsteam_lib.User.

Removed RequestedFor from vsteam_lib.Release

Disable-VSTeamAgent now requires -Force.

ReleaseIdsFilter changed to ReleaseId on Get-VSTeamApproval

Changed Ids parameter to Id on the following functions to be consistent with other functions:

- Get-VSTeamArea
- Get-VSTeamIteration
- Get-VSTeamGitCommit
- Get-VSTeamClassificationNode

ReClassifyId and Path are now required on Remove-VSTeamArea.

Get-VSTeamGitCommit removed Id alias on RepositoryId parameter.

Renamed parameters on Get-VSTeamBuildTimeline to make it easier to pipe results of Get-VSTeamBuild into Get-VSTeamBuildTimeline. $Id of type Guid is now $TimelineId. $BuildId of type int[] is now $Id.

Removed Type parameter from Get-VSTeamBuildDefinition.

Removed the Top and Skip parameters from Get-VSTeamProcess.

Get-VSTeamMembership now returns a collection. There is no need to .value with results.

### Core changes

The folder structure of the project was changed to support the new C# class library.

All the tests and sample files are under the Tests folder.

There is a new packages folder that contains required libs to build the C# project that do not live in NuGet.

The Build folder is now the .build folder.

Build-Module script builds the class lib project as well.

The C# solution files is in the root of the project vsteam_lib.sln.

The lib is in the classes folder under source and the tests are under the library folder under Tests.

You can now call Get-VSTeamTfvcBranch with no parameters.

Added -force to Remove-VSTeamAccessControlEntry so you don't have to use -confirm:$false. This make it consistent with the rest of the functions

Get-VSTeamUser and Get-VSTeamGroup can now take Descriptor from pipeline.

All unit tests were reviewed and all now use sample files where possible instead of inline objects.

Added -Force to Stop-VSTeamBuild

### Docs changes

Added HelpUri to all public functions

Deleted the docs folder because all docs are now available [here](https://methodsandpractices.github.io/vsteam-docs/)

Added examples to all the help files.

## 6.5.1

Fixed bug [337](https://github.com/MethodsAndPractices/vsteam/issues/337)
Fixed bug [345](https://github.com/MethodsAndPractices/vsteam/issues/345)

Merged [Pull Request](https://github.com/DarqueWarrior/vsteam/pull/335) from [Sebastian Schütze](https://github.com/SebastianSchuetze) which included the following:

- Fixed bug [326](https://github.com/MethodsAndPractices/vsteam/issues/326)

## 6.5.0

Added a default 60 second timeout on _callAPI. You can override the value with Set-VSTeamDefaultAPITimeout and clear with Clear-VSTeamDefaultAPITimeout.

Changed the completers to quote all values.

Added support for different releases of the Server version:
TFS2017U1, TFS2017U2, TFS2017U3, TFS2018U1, TFS2018U2, TFS2018U3 and AZD2019U1.

The versions for Azure DevOps were also updated to 6.0-preview where supported.

Requires Pester 5.x
All the tests have been upgraded to use Pester 5.

Merged [Pull Request](https://github.com/DarqueWarrior/vsteam/pull/315) from [Jhoneill](https://github.com/jhoneill) which included the following:

- Fix Get-VSTeamWiql [#314](https://github.com/DarqueWarrior/vsteam/issues/314)

Merged [Pull Request](https://github.com/DarqueWarrior/vsteam/pull/317) from [Brittan DeYoung](https://github.com/brittandeyoung) which included the following:

- Adds a new function Stop-VSTeamBuild which allows cancelling a build using the build id

Merged [Pull Request](https://github.com/DarqueWarrior/vsteam/pull/322) from [Jhoneill](https://github.com/jhoneill) which included the following:

- Enhance Get-VSTeamProcess

Merged [Pull Request](https://github.com/DarqueWarrior/vsteam/pull/328) from [Sebastian Schütze](https://github.com/SebastianSchuetze) which included the following:

- Run unit tests in Docker containers Locally

Merged [Pull Request](https://github.com/DarqueWarrior/vsteam/pull/333) from [Daniel Sturm](https://github.com/danstur) which included the following:

- Adds -IncludeCommits switch to Get-VSTeamPullRequest

## 6.4.8

You can now tab complete Area and Resource of Invoke-VSTeamRequest.

Merged [Pull Request](https://github.com/DarqueWarrior/vsteam/pull/286) from [Sebastian Schütze](https://github.com/SebastianSchuetze) which included the following:

- Added cmdlets for add, get and remove for classification nodes, iterations and areas

## 6.4.7

\_callAPI, \_buildRequestURI and Invoke-VSTeamRequest now support UseProjectId switch if the Project ID is required for the API call.

Addressed following issues:

- Do not change the strict mode setting for the user's PowerShell session [#296](https://github.com/DarqueWarrior/vsteam/issues/296)
- Consider reducing the scope of the default parameter "Project" from "_" to "_-VsTeam\*" [#297](https://github.com/DarqueWarrior/vsteam/issues/297)

Merged [Pull Request](https://github.com/DarqueWarrior/vsteam/pull/275) from [Jhoneill](https://github.com/jhoneill) which included the following:

- Removing Dynamic parameters for completer and validator attributes.

Merged [Pull Request](https://github.com/DarqueWarrior/vsteam/pull/283) from [Sebastian Schütze](https://github.com/SebastianSchuetze) which included the following:

- Added Get-VSTeamBuildTimeline to get timeline of a build

## 6.4.6

Corrected a display issue were the List view was being used by default instead of Table.

## 6.4.5

All unit test now pass consistently.

Merged [Pull Request](https://github.com/DarqueWarrior/vsteam/pull/265) from [Michel Zehnder](https://github.com/MichelZ) which included the following:

- Simplify merging of files

Merged [Pull Request](https://github.com/DarqueWarrior/vsteam/pull/272) from [Sebastian Schütze](https://github.com/SebastianSchuetze) which included the following:

- Add Test-VSTeamYamlPipeline to preview check changes for YAML pipelines. [See release sprint 165](https://docs.microsoft.com/azure/devops/release-notes/2020/sprint-165-update#azure-pipelines-1).

Merged [Pull Request](https://github.com/DarqueWarrior/vsteam/pull/273) from [Lukas Wöhrl](https://github.com/woehrl01) which included the following:

- Adds a new function Update-VSTeamAgent which allows to update the agent version

## 6.4.4

Merged [Pull Request](https://github.com/DarqueWarrior/vsteam/pull/257) from [Michel Zehnder](https://github.com/MichelZ) which included the following:

- Fix bug in Get-VSTeamBuildArtifact with additional "properties" property

Merged [Pull Request](https://github.com/DarqueWarrior/vsteam/pull/245) from [Michel Zehnder](https://github.com/MichelZ) which included the following:

- Add Get-VSTeamGitStats to retrieve statistics about branches

Merged [Pull Request](https://github.com/DarqueWarrior/vsteam/pull/244) from [Michel Zehnder](https://github.com/MichelZ) which included the following:

- Add support for licensingSource and msdnLicenseType to Add-VSTeamUserEntitlement / Update-VSTeamUserEntitlement

Merged [Pull Request](https://github.com/DarqueWarrior/vsteam/pull/243) from [Michel Zehnder](https://github.com/MichelZ) which included the following:

- Add additional filtering capabilities to Get-VSTeamPullRequest

Merged [Pull Request](https://github.com/DarqueWarrior/vsteam/pull/242) from [Michel Zehnder](https://github.com/MichelZ) which included the following:

- Added "-and" operator to the Membership tests

Merged [Pull Request](https://github.com/DarqueWarrior/vsteam/pull/241) from [Michel Zehnder](https://github.com/MichelZ) which included the following:

- Added Update-VSTeamPullRequest to manipulate some basics about Pull Requests
- Added Add-VSTeamPullRequest to create Pull Requests

Merged [Pull Request](https://github.com/DarqueWarrior/vsteam/pull/240) from [Michel Zehnder](https://github.com/MichelZ) which included the following:

- Add option to add additional headers (-AdditionalHeaders) to the request generated by the `Invoke-VSTeamRequest` call

Merged [Pull Request](https://github.com/DarqueWarrior/vsteam/pull/239) from [Michel Zehnder](https://github.com/MichelZ) which included the following:

- Added ;charset=utf-8 to POST/PUT JSON requests

Merged [Pull Request](https://github.com/DarqueWarrior/vsteam/pull/238) from [Michel Zehnder](https://github.com/MichelZ) which included the following:

- Added Get-VSTeamGitCommit to retrieve commits

Merged [Pull Request](https://github.com/DarqueWarrior/vsteam/pull/237) from [Michel Zehnder](https://github.com/MichelZ) which included the following:

- Add -Filter, -FilterContains, -Top and -ContinuationToken to Get-VSTeamGitRefs

Merged [Pull Request](https://github.com/DarqueWarrior/vsteam/pull/232) from [Mark Wragg](https://github.com/markwragg) which included the following:

- Bug fix in Get-VSTeamBuildArtifact where an error is returned because the API returns an extra record along with the list of artifacts that is called 'build.sourceLabel' and contains a URL but no "properties" object.

Merged [Pull Request](https://github.com/DarqueWarrior/vsteam/pull/231) from [Dave Neeley](https://github.com/daveneeley) which included the following:

- Removed a trailing slash from resource URIs generated by `_BuildRequestURI` when the ID parameter is not included in the function call.

Merged [Pull Request](https://github.com/DarqueWarrior/vsteam/pull/225) from [Cadacious](https://github.com/Cadacious) which included the following:

- Added Get/Set-VSTeamPermissionInheritance

Merged [Pull Request](https://github.com/DarqueWarrior/vsteam/pull/224) from [Cadacious](https://github.com/Cadacious) which included the following:

- Adds Remove-VSTeamAccessControlEntry

## 6.4.3

Merged [Pull Request](https://github.com/DarqueWarrior/vsteam/pull/229) from [Asif Mithawala](https://github.com/asifma) which included the following:

Added additional property checks in VSTeamJobRequest

## 6.4.2

Merged [Pull Request](https://github.com/DarqueWarrior/vsteam/pull/226) from [Asif Mithawala](https://github.com/asifma) which included the following:

Added property checks in VSTeamJobRequest

Merged [Pull Request](https://github.com/DarqueWarrior/vsteam/pull/227) from [Sebastian Schütze](https://github.com/SebastianSchuetze) which included the following:

Added Remove-VSTeamWorkItem to delete work items

- Added a parameter to filter unit tests
- Added documentation on parameters of Build-Module.ps1 in code and for README.MD
- Removed references to update the .PSD1 file in the PR template as well as in the contribution doc, since it does not seem to be needed anymore, because it is generated automatically.
- Added coverage.xml to the .gitignore file

## 6.4.1

Fixed issue [Description on variable groups is not a required field #208](https://github.com/DarqueWarrior/vsteam/issues/208).

## 6.4.0

Merged [Pull Request](https://github.com/DarqueWarrior/vsteam/pull/214) from [Louis Tourtellotte](https://github.com/quintessential5) which included the following:

Add/Update Var Group: Support for Body Param, so that json can be directly provided rather than a hashtable of variables. See the example in the documentation for more use case details.

Merged [Pull Request](https://github.com/DarqueWarrior/vsteam/pull/213) from [Louis Tourtellotte](https://github.com/quintessential5) which included the following:

Get-VSTeamVariableGroup fixes

Merged [Pull Request](https://github.com/DarqueWarrior/vsteam/pull/212) from [Louis Tourtellotte](https://github.com/quintessential5) which included the following:

Support for task groups

Merged [Pull Request](https://github.com/DarqueWarrior/vsteam/pull/211) from [Dick van de Meulengraaf](https://github.com/dickvdm) which included the following:

AzD2019 configuration, being Azure DevOps Server (on-prem) 2019 (17.143.28912.1)

Merged [Pull Request](https://github.com/DarqueWarrior/vsteam/pull/209) from [Sebastian Schütze](https://github.com/SebastianSchuetze) which included the following:

Added Remove-VSTeamWorkItem to delete work items

Merged [Pull Request](https://github.com/DarqueWarrior/vsteam/pull/204) from [Jeroen Janssen](https://github.com/japj) which included the following:

maxParallelism to Disable/Enable-VSTeamAgent

Merged [Pull Request](https://github.com/DarqueWarrior/vsteam/pull/205) from [Sebastian Schütze](https://github.com/SebastianSchuetze) which included the following:

Get-VSTeamWiql to get work items via [WIQL](https://docs.microsoft.com/rest/api/azure/devops/wit/wiql?view=azure-devops-rest-5.1&WT.mc_id=-github-dbrown) and also to expand the returned work items with all fields selected.

**Breaking changes**:

Changed signature of Get-VSTeamWorkItem to only have Id of type int[] instead of Id and Ids.

## 6.3.6

Merged [Pull Request](https://github.com/DarqueWarrior/vsteam/pull/200) from [Chris Gardner](https://github.com/ChrisLGardner) which included the following:

Get-VSTeamPullRequest documentation was linking to Get-VSTeamWorkItem documentation

## 6.3.5

Updated Build-Module.ps1 to support static code analysis and running unit tests.
Updated Merge-File.ps1 to clean trailing white-space.

Merged [Pull Request](https://github.com/DarqueWarrior/vsteam/pull/199) from [Sebastian Schütze](https://github.com/SebastianSchuetze) which included the following:

bug fix for update and add workItem

## 6.3.4

Merged [Pull Request](https://github.com/DarqueWarrior/vsteam/pull/193) from [Sebastian Schütze](https://github.com/SebastianSchuetze) which included the following:

Rename:
VSTS --> AzD
\*Visual Studio Team Services --> Azure DevOps

## 6.3.3

Merged [Pull Request](https://github.com/DarqueWarrior/vsteam/pull/191) from [Louis Tourtellotte](https://github.com/quintessential5) which included the following:

Get-VSTeamVariableGroup: support for getting by name as well as by ID.

Merged [Pull Request](https://github.com/DarqueWarrior/vsteam/pull/190) from [Sebastian Schütze](https://github.com/SebastianSchuetze) which included the following:

Updated Add-VSTeamWorkItem and Update-VSTeamWorkItem to support any work item field, also custom ones.

## 6.3.2

Merged [Pull Request](https://github.com/DarqueWarrior/vsteam/pull/182) from [eosfor](https://github.com/eosfor) which included the following:

Invalidate cache on account change

Merged [Pull Request](https://github.com/DarqueWarrior/vsteam/pull/181) from [Michael Erpenbeck](https://github.com/GitMje) which included the following:

Fixed typo in README.md file for better readability

Merged [Pull Request](https://github.com/DarqueWarrior/vsteam/pull/179) from [Jim W](https://github.com/Seekatar) which included the following:

Add PSDrive support for memberships

- Memberships
  - Groups
    - Group1
  - Users
    - User1

## 6.3.1

Merged [Pull Request](https://github.com/DarqueWarrior/vsteam/pull/178) from [Jim W](https://github.com/Seekatar) which included the following:

- Add-VSTeamMembership
- Remove-VSTeamMembership
- Get-VSTeamMembership
- Test-VSTeamMembership

## 6.3.0

Added support for the following:

- Update-VSTeamReleaseDefinition

Also added Raw and JSON support to the Get-VSTeamReleaseDefinition.
The shape of the object returned by Get-VSTeamReleaseDefinition was slightly changed.
Release definitions was added to the SHiPS provider.

## 6.2.9

Merged [Pull Request](https://github.com/DarqueWarrior/vsteam/pull/176) from [Carlo Wahlstedt](https://github.com/carlowahlstedt) which included the following:

Updated help to refer to Add-VSTeamProfile instead of Set-VSTeamProfile

## 6.2.8

Added support for Get-VSTeamJobRequest. The provider was extended to show the Job Request under the Agent.

- Account
  - Agent Pools
    - Pool1
      - Agent1
        - JobRequest1

## 6.2.7

Added support for -Raw and -Json on Get-VSTeamBuildDefinition so the objects and/or JSON can be returned in Update-VSTeamBuildDefinition.

This was added so users can update Build variables from one stage to pass to the next.

```PowerShell
$b = Get-VSTeamBuildDefinition 12 -Raw
Add-VSTeamBuildDefinition -InFile $b
```

Also merged [Pull Request](https://github.com/DarqueWarrior/vsteam/pull/170) from [Ignacio Galarza, Jr.](https://github.com/ignatz42) which included the following:

Added functions to deal with variable groups

- Added Add-VSTeamVariableGroup to add new variable groups.
- Added Get-VSTeamVariableGroup to get variable groups.
- Added Update-VSTeamVariableGroup to update variable groups
- Added Remove-VSTeamVariableGroup to remove variable groups

## 6.2.6

Added Update-VSTeamRelease.
Added support for -Raw and -Json on Get-VSTeamRelease so the objects and/or JSON can be returned in Update-VSTeamRelease.

This was added so users can update release variables from one stage to pass to the next.

```PowerShell
$r = Get-VSTeamRelease $(Release.ReleaseId) -Raw
$r.variables.DEPLOYMENT_CONFIG.value = "test123"
Update-VSTeamRelease $(Release.ReleaseId) -Release $r
```

See the help of Update-VSTeamRelease for more examples.

## 6.2.5

Polished the docs.

## 6.2.4

Added code to log error if -UseWindowsAuthentication is used to connect to Azure DevOps Services. -UseWindowsAuthentication is only for connecting to TFS or Azure DevOps Server.

## 6.2.3

Fixes issue [Get-VSTeamAccessControlList -IncludeExtendedInfo. Cannot convert value PSCustomObject to type Hashtable #159](https://github.com/DarqueWarrior/vsteam/issues/159)

## 6.2.2

Merged [Pull Request](https://github.com/DarqueWarrior/vsteam/pull/158) from [Ryan](https://github.com/RPhay) which included the following:

Fixes issue [Get-VSTeamBuildDefinition fails #155](https://github.com/DarqueWarrior/vsteam/issues/155)

## 6.2.1

Merged [Pull Request](https://github.com/DarqueWarrior/vsteam/pull/156) from [Daniel Sturm](https://github.com/danstur) which included the following:

Corrects error creating VSTeamBuildDefinitionProcessPhase object in later versions of Azure DevOps Server (TFS).

## 6.2.0

Merged [Pull Request](https://github.com/DarqueWarrior/vsteam/pull/144) from [Michel Zehnder](https://github.com/MichelZ) which included the following:

Added functions to deal with Security
Note: Some of these are only supported in Azure DevOps (Online), not TFS and Azure DevOps Server due to unavailable APIs

- Added Get-VSTeamSecurityNamespace to retrieve security namespaces
- Added Add-VSTeamAccessControlEntry to add low level ACE's
- Added Get-VSTeamAccessControlList to retrieve ACL's
- Added Add-VSTeamAccessControlList to add ACL's
- Added Add-VSTeamWorkItemIterationPermission
- Added Get-VSTeamClassificationNode
- Added Get-VSTeamUser (see breaking changes below)
- Added Add-VSTeamWorkItemAreaPermission
- Added Add-VSTeamProjectPermission

**Breaking changes**:

- Renamed Get-VSTeamUser to Get-VSTeamUserEntitlement
- Renamed Add-VSTeamUser to Add-VSTeamUserEntitlement
- Renamed Update-VSTeamUser to Update-VSTeamUserEntitlement
- Added new Get-VSTeamUser cmdlet retrieving more data about the User itself

## 6.1.3

Fixed typos in Set-VSTeamAlias function.

## 6.1.2

Fixed issued with version 5.0 REST API JSON object for build definition. jobCancelTimeoutInMinutes appears to have moved to the build definition from the phase.

## 6.1.1

Merged [Pull Request](https://github.com/DarqueWarrior/vsteam/pull/147) from [Joakim Bick](https://github.com/minimoe) which included the following:

Fix interacting with large GIT repositories without hitting integer overflow.

## 6.1.0

The AzD API now defaults to the 5.x versions.

Merged [Pull Request](https://github.com/DarqueWarrior/vsteam/pull/140) from [Michel Zehnder](https://github.com/MichelZ) which included the following:

Added Get-VSTeamGroup to retrieve Groups
Added Get-VSTeamDescriptor to resolve ID's to Descriptors

**Breaking changes**:

Replaced the -Release parameter of Get-VSTeamOption with -SubDomain parameter so any domain can be used.

## 6.0.1

Fixing issue with mapping drive.

You can now use Set-VSTeamAccount with Invoke-Expression to switch accounts and map a drive on a single line. i.e.:

Set-VSTeamAccount -Profile Test -Drive t | iex

This will switch to the account in the Test profile and map a drive t: to the account.

## 6.0.0

Each function is now broken out into a separate file. The folder structure was changed with the core content moved into the Source folder. All the PSM1's were moved to PS1's files. There is now a single PSM1 now.

**Breaking changes**:
All the aliases have been removed. If you want to use the old aliases run Set-VSTeamAlias. They were removed due to conflicts with other modules.

The VSTeamVersions class is no longer exported. To set versions you must use Set-VSTeamAPIVersion.

Parameters for Set-VSTeamAPIVersion have been changed. The Version parameter has been re-purposed to set the version of a single service. To set all the version for a particular version of TFS or AzD set use the Target parameter.

Add-VSTeamAccount has been changed to Set-VSTeamAccount the ata alias is now mapped to Set-VSTeamAccount. To use the alias you must run Set-VSTeamAlias.

Changing the PAT parameter to SecurePersonalAccessToken of Set-VSTeamAccount.

## 5.0.2

Merged [Pull Request](https://github.com/DarqueWarrior/vsteam/pull/129) from [Adam Murray](https://github.com/muzzar78) which included the following:

- Added ParentId parameter to Add-VSTeamWorkItem to allow the parent work item to be set

## 5.0.1

Merged [Pull Request](https://github.com/DarqueWarrior/vsteam/pull/128) from [Fifth Street Partners](https://github.com/fifthstreetpartners) which included the following:

- Added Get-VSTeamProcess
- Modified Add-VSTeamProcess to allow for any Process Template to be used

## 5.0.0

**Breaking changes**:
Project name is no longer a parameter to Get-VSTeamWorkItem

Added Update-VSTeamWorkItem. You can update the following:

- Title
- Description
- IterationPath
- AssignedTo

Exposed the following properties on work item type:

- Description
- IterationPath
- AssignedTo

Fixed bug where you could not add a work item if you only provided the title.
Fixed bug where you could not get a work item by id.

## 4.0.13

Updated readme to Azure DevOps and Azure DevOps Server.

Updated the help file to fix syntax errors on some of the functions.

## 4.0.12

Fixed bug where Get-VSTeamGitRepository was failing if you did not provide a project name. Now you can run without a project and get all the repositories for the entire organization.

## 4.0.11

Merged [Pull Request](https://github.com/DarqueWarrior/vsteam/pull/111) from [Brian Schmitt](https://github.com/brianschmitt) which included the following:

- Adding better error handling when response is null

Merged [Pull Request](https://github.com/DarqueWarrior/vsteam/pull/108) from [Richard Diphoorn](https://github.com/rdtechie) which included the following:

- Added description, iteration path and assigned to, on Work items

Merged [Pull Request](https://github.com/DarqueWarrior/vsteam/pull/110) from [Guillaume Pugnet](https://github.com/GPugnet) which included the following:

- Add-VSTeamExtension
- Get-VSTeamExtension
- Remove-VSTeamExtension
- Update-VSTeamExtension

## 4.0.10

Fixed bug where you could not add a build by build definition name.

## 4.0.9

Merged [Pull Request](https://github.com/DarqueWarrior/vsteam/pull/102) from [Brian Schmitt](https://github.com/brianschmitt) which included the following:

- Get-VSTeamPullRequest
- Show-VSTeamPullRequest

## 4.0.8

Merged [Pull Request](https://github.com/DarqueWarrior/vsteam/pull/93) from [Kai Walter](https://github.com/KaiWalter) which included the following:

- replaced {accountName}.visualStudio.com with dev.azure.com/{accountName}

## 4.0.7

Setting the Top to 10,000 when searching by email in Update-VSTeamUser. If you have a large number of users you should use by ID instead of by email. This addresses issue [90](https://github.com/DarqueWarrior/vsteam/issues/90).

## 4.0.6

Fixed bug where you could not Tab complete the build definition name when calling Add-VSTeamBuild.

Merged [Pull Request](https://github.com/DarqueWarrior/vsteam/pull/92) from [Olivier](https://github.com/hangar18rip) which included the following:

- Added the Demands property to the VSTeamBuildDefinition type

## 4.0.5

Merged [Pull Request](https://github.com/DarqueWarrior/vsteam/pull/89) from [Guillaume Pugnet](https://github.com/GPugnet) which included the following:

- old license was not populated when updating a user by id

## 4.0.4

Fixed bug where the version would not be saved when storing account at User or Admin level. When you started a new PowerShell the account would load but the version would always be TFS2017. Now it loads correctly.

## 4.0.3

Merged [Pull Request](https://github.com/DarqueWarrior/vsteam/pull/84) from [Kai Walter](https://github.com/KaiWalter) which included the following:

- converted VSTeamQueue from format/type to class

Merged [Pull Request](https://github.com/DarqueWarrior/vsteam/pull/86) from [Denny](https://github.com/dvankleef) which included the following:

- Added update User. Currently only can update license type

## 4.0.2

Added Remove-VSTeamFeed

Merged [Pull Request](https://github.com/DarqueWarrior/vsteam/pull/82) from [Kai Walter](https://github.com/KaiWalter) which included the following:

- removed output of objects returned from API to avoid misleading outputs for consumers
- added GitRepository object to BuildDefinition
- had to add a [VSTeamProjectCache]::timestamp = -1 to VSTeamAccount constructor after experiencing blocking with New-PSDrive -Name V -PSProvider SHiPS -Root 'VSTeam#VSTeamAccount' -Verbose; Get-VSTeamBuildDefinition -ProjectName someProject

## 4.0.1

You can now list and add package management feeds.

Added Add-VSTeamNuGetEndpoint

## 4.0.0

**Breaking changes**:
The @VSTeamVersionTable was removed and replaced with a static VSTeamVersions class. This allows the values to flow between the provider and the rest of the functions in the module.

Due to this breaking change _Get-VSTeamAPIVersion_ was added to review the current version being used.

Merged [Pull Request](https://github.com/DarqueWarrior/vsteam/pull/77) from [Kai Walter](https://github.com/KaiWalter) which included the following:

- Build Definition / Process / Phases / Steps are broken down into separate objects

```PowerShell
(Get-VSTeamBuildDefinition -ProjectName MyProject -Id 42).Process
(Get-VSTeamBuildDefinition -ProjectName MyProject -Id 42).Process.Phases
(Get-VSTeamBuildDefinition -ProjectName MyProject -Id 42).Process.Phases[0].Steps
(Get-VSTeamBuildDefinition -ProjectName MyProject -Id 42).Process.Phases[0].Steps[0]
```

## 3.0.7

Removed some common code and took dependency on Trackyon.Utils that did the same things.

## 3.0.6

Added Update-VSTeamProfile to allow easy updating of the PAT for each profile.

## 3.0.5

Merged [Pull Request 70](https://github.com/DarqueWarrior/vsteam/pull/70) and [Pull Request 72](https://github.com/DarqueWarrior/vsteam/pull/72) from [Geert van der Cruijsen](https://github.com/Geertvdc) which included the following:

- Added a function to remove vsts agents from a pool by calling Remove-Agent or Remove-VSTeamAgent
- Disable & Enable agents in pool

Add [Pull Request 70](https://github.com/DarqueWarrior/vsteam/pull/71) from [Kai Walter](https://github.com/KaiWalter) which included the following:

- Integration tests for Build Definitions

## 3.0.4

The ProjectName dynamic parameter that enables Tab Complete of project names was getting called approximately 20 times when tab completing a function name. To reduce the number of calls a rudimentary cache was put in place.

## 3.0.3

Merged [Pull Request](https://github.com/DarqueWarrior/vsteam/pull/66) from [Kai Walter](https://github.com/KaiWalter) which included the following:

- Updated integration tests to account for the new hosted agent pool.

Also added Pool and Agent to the Provider so you can now navigate pools and agents with Get-ChildItem (ls, dir).

Account

- Agent Pools
  - Pool1
    - Agent1
- Project1
- Project2
  - Builds
    - Build1
    - Build2
  - Releases
    - Release1
      - Environment 1
        - Attempt 1
          - Task1
          - Task2
          - Task3
    - Release2
  - Teams
    - Team1
    - Team2
  - Repositories
    - Repository1
      - Ref1
      - Ref2

## 3.0.2

Added Get-VSTeamGitRef to retrieve the branches for adding Pull Request support in the future.

Also added Git Repositories and Git Refs to the Provider so you can now navigate repositories and refs with Get-ChildItem (ls, dir).

Account

- Project1
- Project2
  - Builds
    - Build1
    - Build2
  - Releases
    - Release1
      - Environment 1
        - Attempt 1
          - Task1
          - Task2
          - Task3
    - Release2
  - Teams
    - Team1
    - Team2
  - Repositories
    - Repository1
      - Ref1
      - Ref2

Polished the classes defined for the provider. Also updated some of the functions to return the same classes as the provider. The classes all have a hidden \_internalObj property that contains the raw object returned from the REST API call. Not all the properties of the object are exposed via properties of the class. This property will provide access to them if you need them.

Updated the format.ps1xml files to show more data when the provider is used and to format the provider output to be more consistent with a normal file system. The + and . modes were replaced with d----- and ----- for directories and leafs.

Added a lot of new tests that pushed th code coverage to 99.69%.

## 3.0.1

Huge review of the docs and added support for bearer auth.

Bearer auth will allow you to use the OAuth token created by VSTS during your build and release and not have to create a PAT. Just check the 'Allow scripts to access OAuth token' option on your phase. Then you can add an account by using the -UseBearerToken switch and passing in the \$(System.AccessToken) variable.

```PowerShell
Set-VSTeamAccount -Account mydemos -Token $(System.AccessToken) -UseBearerToken
```

The token is scoped to only allow access to the account running the build or release. To access other accounts you will have to use a personal access token.

## 3.0.0

There is a breaking change with calls to Add-VSTeamKubernetesEndpoint. The acceptUntrustedCerts and generatePfx parameters have been changed from boolean to switch. So any calls that contained:

```powershell
-acceptUntrustedCerts $true -generatePfx $true
```

can be replaced with:

```powershell
-acceptUntrustedCerts -generatePfx
```

There is no need to pass $true.  For calls where you passed $false simply remove the parameter from the call.

This release also contains functions to add a work item and query the work item types. You can not edit the work items yet.

```powershell
Add-VSTeamWorkItem -ProjectName test -WorkItemType Task -Title Test
```

Additional change in this release include more unit tests which resulted in much higher code coverage.

## 2.1.14

- Started adding support for work items.
  - List work item types
  - Get a single work item type

## 2.1.13

Merged [Pull Request](https://github.com/DarqueWarrior/vsteam/pull/50) from [Markus Blaschke](https://github.com/mblaschke) which included the following:

- Added functions for handling of service endpoints:
  - Add-VSTeamKubernetesEndpoint
  - Add-VSTeamServiceEndpoint
  - Update-VSTeamServiceEndpoint

## 2.1.12

Merged [Pull Request](https://github.com/DarqueWarrior/vsteam/pull/51) from [Steve Croxford](https://github.com/CodedBeard) which included the following:

- Added support for creating service fabric endpoints.

## 2.1.11

Updated the delete confirmation message for Remove-VSTeamUser to show the user name and email instead of ID.

## 2.1.10

Merged [Pull Request](https://github.com/DarqueWarrior/vsteam/pull/46) from [Michal Karpinski](https://github.com/karpis) which included the following:

- Added -SourceBranch parameter to Add-VSTeamBuild

## 2.1.9

Merged [Pull Request](https://github.com/DarqueWarrior/vsteam/pull/44) from [Michal Karpinski](https://github.com/karpis) which included the following:

- Added functions for querying TFVC branches:
  - Get-VSTeamTfvcRootBranch
  - Get-VSTeamTfvcBranch

Merged [Pull Request](https://github.com/DarqueWarrior/vsteam/pull/45) from [Michal Karpinski](https://github.com/karpis) which included the following:

- Added ability to pass parameters when queueing builds

## 2.1.8

Merged [Pull Request](https://github.com/DarqueWarrior/vsteam/pull/38) from [Jeffrey Opdam](https://github.com/jeffrey-opdam) which included the following:

- Added support for assigner to be a group, when requesting approvals for a group

## 2.1.7

Merged [Pull Request](https://github.com/DarqueWarrior/vsteam/pull/42) from [Michal Karpinski](https://github.com/karpis) which included the following:

- Added a function for updating an existing build definition from an input json file

## 2.1.6

Merged [Pull Request](https://github.com/DarqueWarrior/vsteam/pull/39) from [Francisco Cabral](https://github.com/franciscocabral) which included the following:

- Fix GET Approval filter by release ids

## 2.1.5

Fixed issue [#40](https://github.com/DarqueWarrior/vsteam/issues/40) so adding a SonarQube or AzureRM Service Endpoint returns the endpoint.

## 2.1.4

Merged [Pull Request](https://github.com/DarqueWarrior/vsteam/pull/37) from [David Roberts](https://github.com/davidroberts63) which included the following:

- Add functions to get/edit code policies

## 2.1.3

Added support for Service Endpoint Types
Updated the ValidateSet for StatusFilter of Approvals

## 2.1.2

Fixed issue [#36](https://github.com/DarqueWarrior/vsteam/issues/36) so all git repositories are returned when you do not provide an project.

## 2.1.1

Removed the External Module Dependencies so SHiPS is installed with the module.

## 2.1.0

Lots of code refactoring and clean up.

Replaced Add-VSTeamReleaseEnvironment with Set-VSTeamEnvironmentStatus.

## 2.0.2

Pushed VSTeamVersionTable to global scope.

Added ReleaseId to release

Added Add-VSTeamUser

Added Invoke-VSTeamRequest. You can now call any REST API supported by TFS2017, TFS2018 or VSTS.

## 2.0.1

The module now has a dependency on SHiPS for PSDrive support.

You must be running 6.0.0-rc or later on Mac and Linux.
You must be running 5.1.16299.64 or later on Windows.

Added drive support created by [Stefan Stranger](https://github.com/stefanstranger). You can now use the -Drive parameter of Set-VSTeamAccount to mount a PSDrive to your account.

You can now tab complete your profiles.

## 1.0.5

Added support for Profiles. Now you can store different accounts and PATS as a profile using Add-VSTeamProfile. Then you can call Set-VSTeamAccount with the -Profile parameter and the PAT will be read from the profile. This prevents you having to remember the PAT to switch between accounts. Profiles also store the API version to use with the account.

Added \$Global:VSTeamVersionTable so you can experiment with different versions of the VSTS/TFS APIs. The variable contains the following:

- 'Build' = '3.0'
- 'Release' = '3.0-preview'
- 'Core' = '3.0'
- 'Git' = '3.0'
- 'DistributedTask' = '3.0-preview'

You can update the version so try new versions of APIs. See Set-VSTeamAPIVersion.

## 1.0.4

Added support for Show-VSTeam that opens the configured TFS or VSTS in default browser.

Merged [Pull Request](https://github.com/DarqueWarrior/vsteam/pull/26) from [Michel Perfetti](https://github.com/miiitch) which included the following:

- Remove deadlock when endpoint creation failed

## 1.0.3

Explicit export of alias
Fixed typo in help
Fixed typo in export of function
Changed projectName dynamic parameter to return projects in any state instead of just well-formed.

## 1.0.2

Added Show-VSTeam\* functions

Fixed ReleaseDefinition functions not recognized bug

## 1.0.1

Renamed from Team to VSTeam. An alias for every function with it's original name is provided.

## 0.1.34

Added support to queue a build by ID using the Add-VSTeamBuild function. The Add-VSTeamBuild function also fully qualifies the names of build definitions when you tab complete from command line.

I added new full name extended property to build definition type.

Added support so you can update a project by ID as well as by Name.

## 0.1.33

The variable to test if you are on Mac OS changed from IsOSX to IsMacOS. Because I have Set-StrictMode -Version Latest trying to access a variable that is not set will crash.

## 0.1.32

Merged [Pull Request](https://github.com/DarqueWarrior/vsteam/pull/16) from [Fergal](https://github.com/ObsidianPhoenix) which included the following:

- Added Support for Build Tags
- Added the ability to update KeepForever, and the Build Number
- Added the ability to pull artifact data from the build

## 0.1.31

Merged [Pull Request](https://github.com/DarqueWarrior/vsteam/pull/17) from [Kees Verhaar](https://github.com/KeesV) which included the following:

- Add ProjectName as a property on team member so it can be used further down the pipeline

## 0.1.30

Merged [Pull Request](https://github.com/DarqueWarrior/vsteam/pull/15) from [Kees Verhaar](https://github.com/KeesV) which included the following:

- Add support for teams

## 0.1.29

Merged [Pull Request](https://github.com/DarqueWarrior/vsteam/pull/12) from [Andy Neillans](https://github.com/aneillans) which included the following:

- Fixed for on-premise URLS being incorrectly classed as VSTS accounts
- Fixed for projects validation if you have more than 100 projects

## 0.1.28

Added ID to approval default output

## 0.1.27

Clearing code analysis warnings

## 0.1.26

Merged [Pull Request](https://github.com/DarqueWarrior/vsteam/pull/10) from [Roberto Peña](https://github.com/eulesv) which included the following:

- Adding a regular expression to validate VSTS account

## 0.1.25

- Moved -Expand parameter of Get-VSTeamRelease to all parameter sets.

## 0.1.24

- Added support so you can start a release from a Git commit

## 0.1.23

Merged [Pull Request](https://github.com/DarqueWarrior/vsteam/pull/8) from [Michel Perfetti](https://github.com/miiitch) which included the following:

- Support for the [SonarQube extension](https://marketplace.visualstudio.com/items?itemName=SonarSource.sonarqube)

## 0.1.22

- Fixed bug in Set-VSTeamDefaultProject on Mac and Linux

## 0.1.21

- Added Get-VSTeamBuildLog that returns the logs of the provided build

Merged [Pull Request](https://github.com/DarqueWarrior/vsteam/pull/6)from [Michel Perfetti](https://github.com/miiitch) which included the following:

- Added serviceEndpoint parameters to Add-VSTeamAzureRMServiceEndpoint cmdlet: if the serviceEndPoint parameters are not specified, the Automatic mode is used
- The \_trackProgress function was changed too to reflect the return code of the api [endpoints](https://www.visualstudio.com/docs/integrate/api/endpoints/endpoints?WT.mc_id=-github-dbrown)
- The URL in the payload changed to [https://management.azure.com](https://management.azure.com)

## 0.1.19

Removed test folder from module

## 0.1.18

Merged [Pull Request](https://github.com/DarqueWarrior/vsteam/pull/5) from [Christopher Mank](https://github.com/ChristopherMank) which included the following:

- Created new function in the release module named 'Add-VSTeamReleaseEnvironment'. New function deploys an environment from an existing release.

## 0.1.16

Merged [Pull Request](https://github.com/DarqueWarrior/vsteam/pull/4) from [Andy Neillans](https://github.com/aneillans) which included the following:

- Bug fix for broken PAT code handling.

## 0.1.15

Merged [Pull Request](https://github.com/DarqueWarrior/vsteam/pull/3) from [Andy Neillans](https://github.com/aneillans) which included the following:

- Corrected typos in help files.
- Refactored location of common methods.
- Implemented using DefaultCredentials when using TFS. This removes the need to create a PAT.

## 0.1.14

Initial Open Source release
