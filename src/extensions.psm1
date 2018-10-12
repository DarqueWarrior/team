Set-StrictMode -Version Latest

# Load common code
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
. "$here\common.ps1"

function Add-VSTeamExtension {
   param(
      [parameter(Mandatory = $true)]
      [string] $PublisherId,

      [parameter(Mandatory = $true)]
      [string] $ExtensionId,

      [parameter(Mandatory = $false)]
      [string] $Version
   )
   Process {
      $resource = 'extensionmanagement/installedextensionsbyname/' + $PublisherId + '/' + $ExtensionId 
      
      if ($version) {
         $resource += '/'+$Version
      }
       
      try {
         $resp = _callAPI  -Method Post -SubDomain 'extmgmt' -Resource $resource -Version $([VSTeamVersions]::ExtensionsManagement) -ContentType "application/json"
         Write-Output $resp   
      }
      catch {
         throw $_
      }
   }  
}

function Get-VSTeamExtension {
   param (
      [Parameter(ParameterSetName = 'List', Mandatory=$false)]
      [switch] $IncludeInstallationIssues,

      [Parameter(ParameterSetName = 'List', Mandatory=$false)]
      [switch] $IncludeDisabledExtensions,

      [Parameter(ParameterSetName = 'List', Mandatory=$false)]
      [switch] $IncludeErrors,


      [Parameter(ParameterSetName = 'GetById', Mandatory=$true)]
       [string] $PublisherId,

      [Parameter(ParameterSetName = 'GetById', Mandatory=$true)]
      [string] $ExtensionId      
   )
   Process {   
      
      if(($PublisherId -and !$ExtensionId) -or (!$PublisherId -and $ExtensionId)){
         throw 'You must provide both PublisherId and ExtensionId.'
      }

      if ($PublisherId -and $ExtensionId) {
         $resource = 'extensionmanagement/installedextensionsbyname/' + $PublisherId + '/' + $ExtensionId
         try {
            $resp = _callAPI  -Method Get -SubDomain 'extmgmt' -Resource $resource -Version $([VSTeamVersions]::ExtensionsManagement) -ContentType "application/json"
         
            Write-Output $resp   
         }
         catch {
            throw $_
         }
      }
     else {
         $queryString = @{}
         if ($IncludeInstallationIssues.IsPresent) {
            $queryString.includeCapabilities = $true
         }
         
         if ($IncludeDisabledExtensions.IsPresent) {
            $queryString.includeDisabledExtensions = $true
         }

         if ($IncludeErrors.IsPresent) {
            $queryString.includeErrors = $true
         }
         try {
            $resp = _callAPI  -Method Get -SubDomain 'extmgmt' -Resource 'extensionmanagement/installedextensions' -QueryString $queryString -Version $([VSTeamVersions]::ExtensionsManagement) -ContentType "application/json"
           
            Write-Output $resp   
         }
         catch {
            throw $_
         }  
      }
   }
}

function Update-VSTeamExtension {
   [CmdletBinding( SupportsShouldProcess = $true, ConfirmImpact = "Medium")]
   param (
      [parameter(Mandatory = $true)]
      [string] $PublisherId,

      [parameter(Mandatory = $true)]
      [string] $ExtensionId,

      [parameter(Mandatory = $false)]
      [ValidateSet('none', 'disabled')]
      [string] $ExtensionState,

      [switch] $Force
   )
   if ($Force -or $pscmdlet.ShouldProcess($Name, "Update extension")) {
      $obj =    @{
         extensionId    = $ExtensionId
         publisherId    = $PublisherId
         installState   = 
            {
               flags    = $ExtensionState
            }
      }
      $body = $obj | ConvertTo-Json
      try {
         $resp = _callAPI  -Method Patch -body $body -SubDomain 'extmgmt' -Resource 'extensionmanagement/installedextensions' -Version $([VSTeamVersions]::ExtensionsManagement) -ContentType "application/json"
         Write-Output $resp   
      }
      catch {
         throw $_
      }
   }
}

function Remove-VSTeamExtension {
   [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "High")]
   param (
      [parameter(Mandatory = $true)]
      [string] $PublisherId,

      [parameter(Mandatory = $true)]
      [string] $ExtensionId,

      [switch] $Force
   )
   if ($Force -or $pscmdlet.ShouldProcess($item, "Remove extension")) {
      $resource = 'extensionmanagement/installedextensionsbyname/' + $PublisherId + '/' + $ExtensionId 
      try {
         $resp = _callAPI  -Method Delete -SubDomain 'extmgmt' -Resource $resource -Version $([VSTeamVersions]::ExtensionsManagement) -ContentType "application/json"
         Write-Output $resp   
      }
      catch {
         throw $_
      }
   }
}


Set-Alias Add-Extension Add-VSTeamExtension
Set-Alias Get-Extension Get-VSTeamExtension
Set-Alias Update-Extension Update-VSTeamExtension
Set-Alias Remove-Extension Remove-VSTeamExtension

Export-ModuleMember `
   -Function Add-VSTeamExtension, Get-VSTeamExtension, Update-VSTeamExtension, Remove-VSTeamExtension `
   -Alias Add-Extension, Get-Extension, Update-Extension, Remove-Extension