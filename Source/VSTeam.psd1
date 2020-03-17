#
# Module manifest for module 'VSTeam'
#
# Generated by: @DonovanBrown
#
# Generated on: 28/02/2020
#

@{

# Script module or binary module file associated with this manifest.
RootModule = 'VSTeam.psm1'

# Version number of this module.
ModuleVersion = '6.4.4'

# Supported PSEditions
# CompatiblePSEditions = @()

# ID used to uniquely identify this module
GUID = '210e95b1-50bb-44da-a993-f567f4574214'

# Author of this module
Author = '@DonovanBrown'

# Company or vendor of this module
CompanyName = ''

# Copyright statement for this module
Copyright = '(c) 2020 Donovan Brown. All rights reserved.'

# Description of the functionality provided by this module
Description = 'Adds functionality for working with Azure DevOps and Team Foundation Server.'

# Minimum version of the PowerShell engine required by this module
# PowerShellVersion = ''

# Name of the PowerShell host required by this module
# PowerShellHostName = ''

# Minimum version of the PowerShell host required by this module
# PowerShellHostVersion = ''

# Minimum version of Microsoft .NET Framework required by this module. This prerequisite is valid for the PowerShell Desktop edition only.
# DotNetFrameworkVersion = ''

# Minimum version of the common language runtime (CLR) required by this module. This prerequisite is valid for the PowerShell Desktop edition only.
# ClrVersion = ''

# Processor architecture (None, X86, Amd64) required by this module
# ProcessorArchitecture = ''

# Modules that must be imported into the global environment prior to importing this module
RequiredModules = @('SHiPS', 
               'Trackyon.Utils')

# Assemblies that must be loaded prior to importing this module
# RequiredAssemblies = @()

# Script files (.ps1) that are run in the caller's environment prior to importing this module.
# ScriptsToProcess = '.\vsteam.classes.ps1'

# Type files (.ps1xml) to be loaded when importing this module
TypesToProcess = '.\vsteam.types.ps1xml'

# Format files (.ps1xml) to be loaded when importing this module
FormatsToProcess = '.\vsteam.format.ps1xml'

# Modules to import as nested modules of the module specified in RootModule/ModuleToProcess
# NestedModules = @()

# Functions to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no functions to export.
# This wildcard will be replaced during the build process in AzD
   FunctionsToExport = @(
                        'Add-VSTeam',
                        'Add-VSTeamAccessControlEntry',
                        'Add-VSTeamAzureRMServiceEndpoint',
                        'Add-VSTeamBuild',
                        'Add-VSTeamBuildDefinition',
                        'Add-VSTeamBuildTag',
                        'Add-VSTeamExtension',
                        'Add-VSTeamFeed',
                        'Add-VSTeamGitRepository',
                        'Add-VSTeamGitRepositoryPermission',
                        'Add-VSTeamKubernetesEndpoint',
                        'Add-VSTeamMembership',
                        'Add-VSTeamNuGetEndpoint',
                        'Add-VSTeamPolicy',
                        'Add-VSTeamProfile',
                        'Add-VSTeamProject',
                        'Add-VSTeamProjectPermission',
                        'Add-VSTeamRelease',
                        'Add-VSTeamReleaseDefinition',
                        'Add-VSTeamServiceEndpoint',
                        'Add-VSTeamServiceFabricEndpoint',
                        'Add-VSTeamSonarQubeEndpoint',
                        'Add-VSTeamTaskGroup',
                        'Add-VSTeamUserEntitlement',
                        'Add-VSTeamVariableGroup',
                        'Add-VSTeamWorkItem',
                        'Add-VSTeamWorkItemAreaPermission',
                        'Add-VSTeamWorkItemIterationPermission',
                        'Clear-VSTeamDefaultProject',
                        'Disable-VSTeamAgent',
                        'Enable-VSTeamAgent',
                        'Get-VSTeam',
                        'Get-VSTeamAccessControlList',
                        'Get-VSTeamAgent',
                        'Get-VSTeamAPIVersion',
                        'Get-VSTeamApproval',
                        'Get-VSTeamBuild',
                        'Get-VSTeamBuildArtifact',
                        'Get-VSTeamBuildDefinition',
                        'Get-VSTeamBuildLog',
                        'Get-VSTeamBuildTag',
                        'Get-VSTeamClassificationNode',
                        'Get-VSTeamCloudSubscription',
                        'Get-VSTeamDescriptor',
                        'Get-VSTeamExtension',
                        'Get-VSTeamFeed',
                        'Get-VSTeamGitRef',
                        'Get-VSTeamGitRepository',
                        'Get-VSTeamGroup',
                        'Get-VSTeamInfo',
                        'Get-VSTeamJobRequest',
                        'Get-VSTeamMember',
                        'Get-VSTeamMembership',
                        'Get-VSTeamOption',
                        'Get-VSTeamPolicy',
                        'Get-VSTeamPolicyType',
                        'Get-VSTeamPool',
                        'Get-VSTeamProcess',
                        'Get-VSTeamProfile',
                        'Get-VSTeamProject',
                        'Get-VSTeamPullRequest',
                        'Get-VSTeamQueue',
                        'Get-VSTeamRelease',
                        'Get-VSTeamReleaseDefinition',
                        'Get-VSTeamResourceArea',
                        'Get-VSTeamSecurityNamespace',
                        'Get-VSTeamServiceEndpoint',
                        'Get-VSTeamServiceEndpointType',
                        'Get-VSTeamTaskGroup',
                        'Get-VSTeamTfvcBranch',
                        'Get-VSTeamTfvcRootBranch',
                        'Get-VSTeamUser',
                        'Get-VSTeamUserEntitlement',
                        'Get-VSTeamVariableGroup',
                        'Get-VSTeamWiql',
                        'Get-VSTeamWorkItem',
                        'Get-VSTeamWorkItemType',
                        'Invoke-VSTeamRequest',
                        'Remove-VSTeam',
                        'Remove-VSTeamAccessControlList',
                        'Remove-VSTeamAccount',
                        'Remove-VSTeamAgent',
                        'Remove-VSTeamBuild',
                        'Remove-VSTeamBuildDefinition',
                        'Remove-VSTeamBuildTag',
                        'Remove-VSTeamExtension',
                        'Remove-VSTeamFeed',
                        'Remove-VSTeamGitRepository',
                        'Remove-VSTeamMembership',
                        'Remove-VSTeamPolicy',
                        'Remove-VSTeamProfile',
                        'Remove-VSTeamProject',
                        'Remove-VSTeamRelease',
                        'Remove-VSTeamReleaseDefinition',
                        'Remove-VSTeamServiceEndpoint',
                        'Remove-VSTeamTaskGroup',
                        'Remove-VSTeamUserEntitlement',
                        'Remove-VSTeamVariableGroup',
                        'Remove-VSTeamWorkItem',
                        'Set-VSTeamAccount',
                        'Set-VSTeamAlias',
                        'Set-VSTeamAPIVersion',
                        'Set-VSTeamApproval',
                        'Set-VSTeamDefaultProject',
                        'Set-VSTeamEnvironmentStatus',
                        'Set-VSTeamReleaseStatus',
                        'Show-VSTeam',
                        'Show-VSTeamApproval',
                        'Show-VSTeamBuild',
                        'Show-VSTeamBuildDefinition',
                        'Show-VSTeamFeed',
                        'Show-VSTeamGitRepository',
                        'Show-VSTeamProject',
                        'Show-VSTeamPullRequest',
                        'Show-VSTeamRelease',
                        'Show-VSTeamReleaseDefinition',
                        'Show-VSTeamWorkItem',
                        'Test-VSTeamMembership',
                        'Update-VSTeam',
                        'Update-VSTeamBuild',
                        'Update-VSTeamBuildDefinition',
                        'Update-VSTeamExtension',
                        'Update-VSTeamPolicy',
                        'Update-VSTeamProfile',
                        'Update-VSTeamProject',
                        'Update-VSTeamRelease',
                        'Update-VSTeamReleaseDefinition',
                        'Update-VSTeamServiceEndpoint',
                        'Update-VSTeamTaskGroup',
                        'Update-VSTeamUserEntitlement',
                        'Update-VSTeamVariableGroup',
                        'Update-VSTeamWorkItem')

# Cmdlets to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no cmdlets to export.
CmdletsToExport = @()

# Variables to export from this module
# VariablesToExport = @()

# Aliases to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no aliases to export.
AliasesToExport = @()

# DSC resources to export from this module
# DscResourcesToExport = @()

# List of all modules packaged with this module
# ModuleList = @()

# List of all files packaged with this module
# FileList = @()

# Private data to pass to the module specified in RootModule/ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
PrivateData = @{

    PSData = @{

        # Tags applied to this module. These help with module discovery in online galleries.
        Tags = 'VSTS','TFS','DevOps','VisualStudio','TeamServices','Team','AzureDevOps','Pipelines','Boards','Artifacts','TestPlans','Repos','AzD','ADO','AzDO'

        # A URL to the license for this module.
        LicenseUri = 'https://github.com/DarqueWarrior/vsteam/blob/master/LICENSE'

        # A URL to the main website for this project.
        ProjectUri = 'https://github.com/DarqueWarrior/vsteam'

        # A URL to an icon representing this module.
        # IconUri = ''

        # ReleaseNotes of this module
        ReleaseNotes = 'https://github.com/DarqueWarrior/vsteam/blob/master/CHANGELOG.md'

        # Prerelease string of this module
        # Prerelease = ''

        # Flag to indicate whether the module requires explicit user acceptance for install/update/save
        # RequireLicenseAcceptance = $false

        # External dependent modules of this module
        # ExternalModuleDependencies = @()

    } # End of PSData hashtable

 } # End of PrivateData hashtable

# HelpInfo URI of this module
# HelpInfoURI = ''

# Default prefix for commands exported from this module. Override the default prefix using Import-Module -Prefix.
# DefaultCommandPrefix = ''

}
