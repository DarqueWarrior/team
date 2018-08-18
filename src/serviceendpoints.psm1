Set-StrictMode -Version Latest

# Load common code
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
. "$here\common.ps1"

$i = 0
$x = 1
$y = 10
$status = $null

# Apply types to the returned objects so format and type files can
# identify the object and act on it.
function _applyTypesToServiceEndpoint {
   param($item)

   $item.PSObject.TypeNames.Insert(0, 'Team.ServiceEndpoint')

   $item.createdBy.PSObject.TypeNames.Insert(0, 'Team.User')
   $item.authorization.PSObject.TypeNames.Insert(0, 'Team.authorization')
   $item.data.PSObject.TypeNames.Insert(0, 'Team.ServiceEndpoint.Details')

   if ($item.PSObject.Properties.Match('operationStatus').count -gt 0 -and $null -ne $item.operationStatus) {
      # This is VSTS
      $item.operationStatus.PSObject.TypeNames.Insert(0, 'Team.OperationStatus')
   }
}

function _trackProgress {
   param(
      [Parameter(Mandatory = $true)]
      [string] $projectName,

      [Parameter(Mandatory = $true)]
      $resp,
      
      [string] $title,
     
      [string] $msg
   )

   $i = 0
   $x = 1
   $y = 10

   $isReady = $false

   # Track status
   while (-not $isReady) {
      $status = _callAPI -ProjectName $projectName -Area 'distributedtask' -Resource 'serviceendpoints' -Id $resp.id  `
         -Version $([VSTeamVersions]::DistributedTask)

      $isReady = $status.isReady;

      if (-not $isReady) {
         $state = $status.operationStatus.state
      
         if ($state -eq "Failed") {
            throw $status.operationStatus.statusMessage
         }
      }
       
      # oscillate back a forth to show progress
      $i += $x
      Write-Progress -Activity $title -Status $msg -PercentComplete ($i / $y * 100)

      if ($i -eq $y -or $i -eq 0) {
         $x *= -1
      }
   }
}

function _supportsServiceFabricEndpoint {
   if (-not [VSTeamVersions]::ServiceFabricEndpoint) {
      throw 'This account does not support Service Fabric endpoints.'
   } 
}

function Add-VSTeamSonarQubeEndpoint {
   [CmdletBinding(DefaultParameterSetName = 'Secure')]
   param(
      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [string] $endpointName,
    
      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [string] $sonarqubeUrl,
    
      [parameter(ParameterSetName = 'Plain', Mandatory = $true, Position = 2, HelpMessage = 'Personal Access Token')]
      [string] $personalAccessToken,
    
      [parameter(ParameterSetName = 'Secure', Mandatory = $true, HelpMessage = 'Personal Access Token')]
      [securestring] $securePersonalAccessToken
   )

   DynamicParam {
      _buildProjectNameDynamicParam
   }

   Process {    
       
      if ($personalAccessToken) {
         $token = $personalAccessToken 
      }
      else {
         $credential = New-Object System.Management.Automation.PSCredential "nologin", $securePersonalAccessToken
         $token = $credential.GetNetworkCredential().Password
      }
      
      # Bind the parameter to a friendly variable
      $ProjectName = $PSBoundParameters['ProjectName']

      $obj = @{
         authorization = @{
            parameters = @{
               username = $token;
               password = ''
            };
            scheme     = 'UsernamePassword'
         };
         data          = @{};
         url           = $sonarqubeUrl
      }

      try {
         return Add-VSTeamServiceEndpoint `
            -ProjectName $ProjectName `
            -endpointName $endpointName `
            -endpointType 'sonarqube' `
            -object $obj
      }
      catch [System.Net.WebException] {
         if ($_.Exception.status -eq 'ProtocolError') {
            $errorDetails = ConvertFrom-Json $_.ErrorDetails
            $message = $errorDetails.message

            # The error message is different on TFS and VSTS
            if ($message.StartsWith("Endpoint type couldn't be recognized 'sonarqube'") -or
               $message.StartsWith("Unable to find service endpoint type 'sonarqube'")) {
               Write-Error -Message 'The Sonarqube extension not installed. Please install from https://marketplace.visualstudio.com/items?itemName=SonarSource.sonarqube'
               return
            }
         }
         
         throw
      }
   }
}

function Add-VSTeamAzureRMServiceEndpoint {
   [CmdletBinding(DefaultParameterSetName = 'Automatic')]
   param(
      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [Alias('displayName')]
      [string] $subscriptionName,
    
      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [string] $subscriptionId,
    
      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [string] $subscriptionTenantId,
    
      [Parameter(ParameterSetName = 'Manual', Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [string] $servicePrincipalId,
      
      [Parameter(ParameterSetName = 'Manual', Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [string] $servicePrincipalKey,
      
      [string] $endpointName
   )

   DynamicParam {
      _buildProjectNameDynamicParam
   }

   Process {
      # Bind the parameter to a friendly variable
      $ProjectName = $PSBoundParameters["ProjectName"]

      if (-not $endpointName) {
         $endpointName = $subscriptionName
      }

      if (-not $servicePrincipalId) {
         $creationMode = 'Automatic'
      }
      else {
         $creationMode = 'Manual'
      }

      $obj = @{
         authorization = @{
            parameters = @{
               serviceprincipalid  = $servicePrincipalId
               serviceprincipalkey = $servicePrincipalKey
               tenantid            = $subscriptionTenantId
            }
            scheme     = 'ServicePrincipal'
         }
         data          = @{
            subscriptionId   = $subscriptionId
            subscriptionName = $subscriptionName
            creationMode     = $creationMode
         }
         url           = 'https://management.azure.com/'
      }

      return Add-VSTeamServiceEndpoint `
         -ProjectName $ProjectName `
         -endpointName $endpointName `
         -endpointType 'azurerm' `
         -object $obj
   }
}

function Add-VSTeamKubernetesEndpoint {
   [CmdletBinding()]
   param(
      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [string] $endpointName,

      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [string] $kubeconfig,

      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [string] $kubernetesUrl,

      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [string] $clientCertificateData,

      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [string] $clientKeyData,

      [switch] $acceptUntrustedCerts,

      [switch] $generatePfx
   )

   DynamicParam {
      _buildProjectNameDynamicParam
   }

   Process {
      # Bind the parameter to a friendly variable
      $ProjectName = $PSBoundParameters["ProjectName"]

      # Process switch parameters
      $untrustedCerts = $false
      if ($acceptUntrustedCerts.IsPresent) {
         $untrustedCerts = $true
      }

      $pfx = $false
      if ($generatePfx.IsPresent) {
         $pfx = $true
      }

      $obj = @{
         authorization = @{
            parameters = @{
               clientCertificateData = $clientCertificateData
               clientKeyData         = $clientKeyData
               generatePfx           = $pfx
               kubeconfig            = $Kubeconfig
            };
            scheme     = 'None'
         };
         data          = @{
            acceptUntrustedCerts = $untrustedCerts
         };
         url           = $kubernetesUrl
      }

      return Add-VSTeamServiceEndpoint `
         -ProjectName $ProjectName `
         -endpointName $endpointName `
         -endpointType 'kubernetes' `
         -object $obj
   }
}

function Add-VSTeamServiceFabricEndpoint {
   [CmdletBinding(DefaultParameterSetName = 'Certificate')]
   param(
      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [Alias('displayName')]
      [string] $endpointName,

      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [string] $url,

      [parameter(ParameterSetName = 'Certificate', Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [string] $certificate,
      
      [Parameter(ParameterSetName = 'Certificate', Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [securestring] $certificatePassword,
      
      [parameter(ParameterSetName = 'Certificate', Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [parameter(ParameterSetName = 'AzureAd', Mandatory = $true, ValueFromPipelineByPropertyName = $true)]      
      [string] $serverCertThumbprint,
      
      [Parameter(ParameterSetName = 'AzureAd', Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [string] $username,
      
      [Parameter(ParameterSetName = 'AzureAd', Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [securestring] $password,
      
      [Parameter(ParameterSetName = 'None', Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
      [string] $clusterSpn,
      
      [Parameter(ParameterSetName = 'None', Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
      [bool] $useWindowsSecurity
   )

   DynamicParam {
      _buildProjectNameDynamicParam
   }

   Process {
      # This will throw if this account does not support ServiceFabricEndpoint
      _supportsServiceFabricEndpoint

      # Bind the parameter to a friendly variable
      $ProjectName = $PSBoundParameters["ProjectName"]

      switch ($PSCmdlet.ParameterSetName) {
         "Certificate" { 
            # copied securestring usage from Add-VSTeamAccount
            # while we don't actually have a username here, PSCredential requires that a non empty string is provided
            $credential = New-Object System.Management.Automation.PSCredential $serverCertThumbprint, $certificatePassword
            $certPass = $credential.GetNetworkCredential().Password
            $authorization = @{
               parameters = @{
                  certificate          = $certificate
                  certificatepassword  = $certPass
                  servercertthumbprint = $serverCertThumbprint
               }
               scheme     = 'Certificate'
            }
         }
         "AzureAd" {
            # copied securestring usage from Add-VSTeamAccount
            $credential = New-Object System.Management.Automation.PSCredential $username, $password
            $pass = $credential.GetNetworkCredential().Password
            $authorization = @{
               parameters = @{
                  password             = $pass
                  servercertthumbprint = $serverCertThumbprint
                  username             = $username
               }
               scheme     = 'UsernamePassword'
            }
         }
         Default {
            $authorization = @{
               parameters = @{
                  ClusterSpn         = $clusterSpn
                  UseWindowsSecurity = $useWindowsSecurity
               }
               scheme     = 'None'
            }
         }
      }
      
      $obj = @{
         authorization = $authorization
         data          = @{}
         url           = $url
      }

      return Add-VSTeamServiceEndpoint `
         -ProjectName $ProjectName `
         -endpointName $endpointName `
         -endpointType 'servicefabric' `
         -object $obj
   }
}

function Add-VSTeamServiceEndpoint {
   [CmdletBinding(DefaultParameterSetName = 'Secure')]
   param(
      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [string] $endpointName,

      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [string] $endpointType,
      
      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [hashtable] $object
   )

   DynamicParam {
      _buildProjectNameDynamicParam
   }

   Process {
      # Bind the parameter to a friendly variable
      $ProjectName = $PSBoundParameters["ProjectName"]

      $object['name'] = $endpointName
      $object['type'] = $endpointType

      $body = $object | ConvertTo-Json

      # Call the REST API
      $resp = _callAPI -ProjectName $projectName -Area 'distributedtask' -Resource 'serviceendpoints'  `
         -Method Post -ContentType 'application/json' -body $body -Version $([VSTeamVersions]::DistributedTask)
      
      _trackProgress -projectName $projectName -resp $resp -title 'Creating Service Endpoint' -msg "Creating $endpointName"

      return Get-VSTeamServiceEndpoint -ProjectName $ProjectName -id $resp.id
   }
}

function Get-VSTeamServiceEndpoint {
   [CmdletBinding(DefaultParameterSetName = 'List')]
   param(
      [Parameter(ParameterSetName = 'ByID', Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [string] $id
   )

   DynamicParam {
      _buildProjectNameDynamicParam
   }

   Process {
      # Bind the parameter to a friendly variable
      $ProjectName = $PSBoundParameters["ProjectName"]

      if ($id) {
         # Call the REST API
         $resp = _callAPI -Area 'distributedtask' -Resource 'serviceendpoints' -Id $id  `
            -Version $([VSTeamVersions]::DistributedTask) -ProjectName $ProjectName
         
         _applyTypesToServiceEndpoint -item $resp

         Write-Output $resp
      }
      else {
         # Call the REST API
         $resp = _callAPI -ProjectName $ProjectName -Area 'distributedtask' -Resource 'serviceendpoints'  `
            -Version $([VSTeamVersions]::DistributedTask)
         
         # Apply a Type Name so we can use custom format view and custom type extensions
         foreach ($item in $resp.value) {
            _applyTypesToServiceEndpoint -item $item
         }

         return $resp.value
      }
   }
}

function Update-VSTeamServiceEndpoint {
   [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "Medium")]
   param(
      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [string] $id,

      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [hashtable] $object,

      [switch] $Force
   )

   DynamicParam {
      _buildProjectNameDynamicParam
   }

   Process {
      # Bind the parameter to a friendly variable
      $ProjectName = $PSBoundParameters["ProjectName"]

      $body = $object | ConvertTo-Json

      if ($Force -or $pscmdlet.ShouldProcess($item, "Update Service Endpoint")) {
         # Call the REST API
         $resp = _callAPI -ProjectName $projectName -Area 'distributedtask' -Resource 'serviceendpoints' -Id $id  `
            -Method Put -ContentType 'application/json' -body $body -Version $([VSTeamVersions]::DistributedTask)
      
         _trackProgress -projectName $projectName -resp $resp -title 'Updating Service Endpoint' -msg "Updating $id"

         return Get-VSTeamServiceEndpoint -ProjectName $ProjectName -id $id
      }
   }
}

function Remove-VSTeamServiceEndpoint {
   [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "High")]
   param(
      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [string[]] $id,

      [switch] $Force
   )

   DynamicParam {
      _buildProjectNameDynamicParam
   }

   Process {
      # Bind the parameter to a friendly variable
      $ProjectName = $PSBoundParameters["ProjectName"]

      foreach ($item in $id) {
         if ($Force -or $pscmdlet.ShouldProcess($item, "Delete Service Endpoint")) {
            # Call the REST API
            _callAPI -projectName $projectName -Area 'distributedtask' -Resource 'serviceendpoints' -Id $item  `
               -Method Delete -Version $([VSTeamVersions]::DistributedTask) | Out-Null

            Write-Output "Deleted service endpoint $item"
         }
      }
   }
}

Set-Alias Get-ServiceEndpoint Get-VSTeamServiceEndpoint
Set-Alias Add-SonarQubeEndpoint Add-VSTeamSonarQubeEndpoint
Set-Alias Add-KubernetesEndpoint Add-VSTeamKubernetesEndpoint
Set-Alias Remove-ServiceEndpoint Remove-VSTeamServiceEndpoint
Set-Alias Add-ServiceFabricEndpoint Add-VSTeamServiceFabricEndpoint
Set-Alias Add-AzureRMServiceEndpoint Add-VSTeamAzureRMServiceEndpoint

Set-Alias Remove-SonarQubeEndpoint Remove-VSTeamServiceEndpoint
Set-Alias Remove-ServiceFabricEndpoint Remove-VSTeamServiceEndpoint
Set-Alias Remove-AzureRMServiceEndpoint Remove-VSTeamServiceEndpoint
Set-Alias Remove-VSTeamSonarQubeEndpoint Remove-VSTeamServiceEndpoint
Set-Alias Remove-VSTeamServiceFabricEndpoint Remove-VSTeamServiceEndpoint
Set-Alias Remove-VSTeamAzureRMServiceEndpoint Remove-VSTeamServiceEndpoint

Set-Alias Add-ServiceEndpoint Add-VSTeamServiceEndpoint
Set-Alias Update-ServiceEndpoint Update-VSTeamServiceEndpoint

Export-ModuleMember `
   -Function Get-VSTeamServiceEndpoint, Add-VSTeamAzureRMServiceEndpoint, Remove-VSTeamServiceEndpoint, 
Add-VSTeamSonarQubeEndpoint, Add-VSTeamServiceFabricEndpoint, Add-VSTeamKubernetesEndpoint, Add-VSTeamServiceEndpoint, Update-VSTeamServiceEndpoint `
   -Alias Get-ServiceEndpoint, Add-AzureRMServiceEndpoint, Remove-ServiceEndpoint, Add-SonarQubeEndpoint, Add-KubernetesEndpoint,
Remove-VSTeamAzureRMServiceEndpoint, Remove-VSTeamSonarQubeEndpoint, Remove-AzureRMServiceEndpoint,
Remove-SonarQubeEndpoint, Add-ServiceFabricEndpoint, Remove-ServiceFabricEndpoint, Remove-VSTeamServiceFabricEndpoint, Add-ServiceEndpoint, Update-ServiceEndpoint