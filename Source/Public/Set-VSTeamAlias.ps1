function Set-VSTeamAlias {
   [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "Low",
    HelpUri='https://methodsandpractices.github.io/vsteam-docs/docs/modules/vsteam/Set-VSTeamAlias')]
   param(
      [switch] $Force
   )

   if ($Force -or $pscmdlet.ShouldProcess("Set Alias")) {
      New-Alias ata Set-VSTeamAccount -Scope Global -Force
      New-Alias sta Set-VSTeamAccount -Scope Global -Force
      New-Alias gti Get-VSTeamInfo -Scope Global -Force
      New-Alias ivr Invoke-VSTeamRequest -Scope Global -Force
      New-Alias Get-ServiceEndpoint Get-VSTeamServiceEndpoint -Scope Global -Force
      New-Alias Add-AzureRMServiceEndpoint Add-VSTeamAzureRMServiceEndpoint -Scope Global -Force
      New-Alias Remove-ServiceEndpoint Remove-VSTeamServiceEndpoint -Scope Global -Force
      New-Alias Add-SonarQubeEndpoint Add-VSTeamSonarQubeEndpoint -Scope Global -Force
      New-Alias Add-KubernetesEndpoint Add-VSTeamKubernetesEndpoint -Scope Global -Force
      New-Alias Add-ServiceEndpoint Add-VSTeamServiceEndpoint -Scope Global -Force
      New-Alias Update-ServiceEndpoint Update-VSTeamServiceEndpoint -Scope Global -Force
      New-Alias Add-ServiceFabricEndpoint Add-VSTeamServiceFabricEndpoint -Scope Global -Force
      New-Alias Remove-ServiceFabricEndpoint Remove-VSTeamServiceFabricEndpoint -Scope Global -Force
      New-Alias Remove-AzureRMServiceEndpoint Remove-VSTeamAzureRMServiceEndpoint -Scope Global -Force
      New-Alias Remove-SonarQubeEndpoint Remove-VSTeamSonarQubeEndpoint -Scope Global -Force
      New-Alias Get-Build Get-VSTeamBuild -Scope Global -Force
      New-Alias Show-Build Show-VSTeamBuild -Scope Global -Force
      New-Alias Get-BuildLog Get-VSTeamBuildLog -Scope Global -Force
      New-Alias Get-BuildTag Get-VSTeamBuildTag -Scope Global -Force
      New-Alias Get-BuildArtifact Get-VSTeamBuildArtifact -Scope Global -Force
      New-Alias Add-Build Add-VSTeamBuild -Scope Global -Force
      New-Alias Add-BuildTag Add-VSTeamBuildTag -Scope Global -Force
      New-Alias Remove-Build Remove-VSTeamBuild -Scope Global -Force
      New-Alias Remove-BuildTag Remove-VSTeamBuildTag -Scope Global -Force
      New-Alias Update-Build Update-VSTeamBuild -Scope Global -Force
      New-Alias Get-BuildDefinition Get-VSTeamBuildDefinition -Scope Global -Force
      New-Alias Add-BuildDefinition Add-VSTeamBuildDefinition -Scope Global -Force
      New-Alias Show-BuildDefinition Show-VSTeamBuildDefinition -Scope Global -Force
      New-Alias Remove-BuildDefinition Remove-VSTeamBuildDefinition -Scope Global -Force
      New-Alias Show-Approval Show-VSTeamApproval -Scope Global -Force
      New-Alias Get-Approval Get-VSTeamApproval -Scope Global -Force
      New-Alias Set-Approval Set-VSTeamApproval -Scope Global -Force
      New-Alias Get-CloudSubscription Get-VSTeamCloudSubscription -Scope Global -Force
      New-Alias Get-GitRepository Get-VSTeamGitRepository -Scope Global -Force
      New-Alias Show-GitRepository Show-VSTeamGitRepository -Scope Global -Force
      New-Alias Add-GitRepository Add-VSTeamGitRepository -Scope Global -Force
      New-Alias Remove-GitRepository Remove-VSTeamGitRepository -Scope Global -Force
      New-Alias Get-Pool Get-VSTeamPool -Scope Global -Force
      New-Alias Get-Project Get-VSTeamProject -Scope Global -Force
      New-Alias Show-Project Show-VSTeamProject -Scope Global -Force
      New-Alias Update-Project Update-VSTeamProject -Scope Global -Force
      New-Alias Add-Project Add-VSTeamProject -Scope Global -Force
      New-Alias Remove-Project Remove-VSTeamProject -Scope Global -Force
      New-Alias Get-Queue Get-VSTeamQueue -Scope Global -Force
      New-Alias Get-ReleaseDefinition Get-VSTeamReleaseDefinition -Scope Global -Force
      New-Alias Show-ReleaseDefinition Show-VSTeamReleaseDefinition -Scope Global -Force
      New-Alias Add-ReleaseDefinition Add-VSTeamReleaseDefinition -Scope Global -Force
      New-Alias Remove-ReleaseDefinition Remove-VSTeamReleaseDefinition -Scope Global -Force
      New-Alias Get-Release Get-VSTeamRelease -Scope Global -Force
      New-Alias Show-Release Show-VSTeamRelease -Scope Global -Force
      New-Alias Add-Release Add-VSTeamRelease -Scope Global -Force
      New-Alias Remove-Release Remove-VSTeamRelease -Scope Global -Force
      New-Alias Set-ReleaseStatus Set-VSTeamReleaseStatus -Scope Global -Force
      New-Alias Add-ReleaseEnvironment Add-VSTeamReleaseEnvironment -Scope Global -Force
      New-Alias Get-TeamInfo Get-VSTeamInfo -Scope Global -Force
      New-Alias Add-TeamAccount Set-VSTeamAccount -Scope Global -Force
      New-Alias Remove-TeamAccount Remove-VSTeamAccount -Scope Global -Force
      New-Alias Get-TeamOption Get-VSTeamOption -Scope Global -Force
      New-Alias Get-TeamResourceArea Get-VSTeamResourceArea -Scope Global -Force
      New-Alias Clear-DefaultProject Clear-VSTeamDefaultProject -Scope Global -Force
      New-Alias Set-DefaultProject Set-VSTeamDefaultProject -Scope Global -Force
      New-Alias Get-TeamMember Get-VSTeamMember -Scope Global -Force
      New-Alias Get-Team Get-VSTeam -Scope Global -Force
      New-Alias Add-Team Add-VSTeam -Scope Global -Force
      New-Alias Update-Team Update-VSTeam -Scope Global -Force
      New-Alias Remove-Team Remove-VSTeam -Scope Global -Force
      New-Alias Add-Profile Add-VSTeamProfile -Scope Global -Force
      New-Alias Remove-Profile Remove-VSTeamProfile -Scope Global -Force
      New-Alias Get-Profile Get-VSTeamProfile -Scope Global -Force
      New-Alias Set-APIVersion Set-VSTeamAPIVersion -Scope Global -Force
      New-Alias Add-UserEntitlement Add-VSTeamUserEntitlement -Scope Global -Force
      New-Alias Remove-UserEntitlement Remove-VSTeamUserEntitlement -Scope Global -Force
      New-Alias Get-UserEntitlement Get-VSTeamUserEntitlement -Scope Global -Force
      New-Alias Update-UserEntitlement Update-VSTeamUserEntitlement -Scope Global -Force
      New-Alias Set-EnvironmentStatus Set-VSTeamEnvironmentStatus -Scope Global -Force
      New-Alias Get-ServiceEndpointType Get-VSTeamServiceEndpointType -Scope Global -Force
      New-Alias Update-BuildDefinition Update-VSTeamBuildDefinition -Scope Global -Force
      New-Alias Get-TfvcRootBranch Get-VSTeamTfvcRootBranch -Scope Global -Force
      New-Alias Get-TfvcBranch Get-VSTeamTfvcBranch -Scope Global -Force
      New-Alias Get-WorkItemType Get-VSTeamWorkItemType -Scope Global -Force
      New-Alias Add-WorkItem Add-VSTeamWorkItem -Scope Global -Force
      New-Alias Get-WorkItem Get-VSTeamWorkItem -Scope Global -Force
      New-Alias Remove-WorkItem Remove-VSTeamWorkItem -Scope Global -Force
      New-Alias Show-WorkItem Show-VSTeamWorkItem -Scope Global -Force
      New-Alias Get-Policy Get-VSTeamPolicy -Scope Global -Force
      New-Alias Get-PolicyType Get-VSTeamPolicyType -Scope Global -Force
      New-Alias Add-Policy Add-VSTeamPolicy -Scope Global -Force
      New-Alias Update-Policy Update-VSTeamPolicy -Scope Global -Force
      New-Alias Remove-Policy Remove-VSTeamPolicy -Scope Global -Force
      New-Alias Get-GitRef Get-VSTeamGitRef -Scope Global -Force
      New-Alias Get-Agent Get-VSTeamAgent -Scope Global -Force
      New-Alias Remove-Agent Remove-VSTeamAgent -Scope Global -Force
      New-Alias Enable-Agent Enable-VSTeamAgent -Scope Global -Force
      New-Alias Disable-Agent Disable-VSTeamAgent -Scope Global -Force
      New-Alias Update-Profile Update-VSTeamProfile -Scope Global -Force
      New-Alias Get-APIVersion Get-VSTeamAPIVersion -Scope Global -Force
      New-Alias Add-NuGetEndpoint Add-VSTeamNuGetEndpoint -Scope Global -Force
      New-Alias Get-Feed Get-VSTeamFeed -Scope Global -Force
      New-Alias Add-Feed Add-VSTeamFeed -Scope Global -Force
      New-Alias Show-Feed Show-VSTeamFeed -Scope Global -Force
      New-Alias Remove-Feed Remove-VSTeamFeed -Scope Global -Force
      New-Alias Get-PullRequest Get-VSTeamPullRequest -Scope Global -Force
      New-Alias Show-PullRequest Show-VSTeamPullRequest -Scope Global -Force
      New-Alias Add-Extension Add-VSTeamExtension -Scope Global -Force
      New-Alias Get-Extension Get-VSTeamExtension -Scope Global -Force
      New-Alias Update-Extension Update-VSTeamExtension -Scope Global -Force
      New-Alias Remove-Extension Remove-VSTeamExtension -Scope Global -Force
      New-Alias Update-WorkItem Update-VSTeamWorkItem -Scope Global -Force
      New-Alias Get-JobRequest Get-VSTeamJobRequest -Scope Global -Force
      New-Alias Update-ReleaseDefinition Update-VSTeamReleaseDefinition -Scope Global -Force
   }
}