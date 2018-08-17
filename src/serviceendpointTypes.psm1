Set-StrictMode -Version Latest

# Load common code
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
. "$here\common.ps1"

# Apply types to the returned objects so format and type files can
# identify the object and act on it.
function _applyTypesToServiceEndpointType {
   param($item)

   $item.PSObject.TypeNames.Insert(0, 'Team.ServiceEndpointType')

   $item.inputDescriptors.PSObject.TypeNames.Insert(0, 'Team.InputDescriptor[]')

   foreach ($inputDescriptor in $item.inputDescriptors) {
      $inputDescriptor.PSObject.TypeNames.Insert(0, 'Team.InputDescriptor')
   }
   
   $item.authenticationSchemes.PSObject.TypeNames.Insert(0, 'Team.AuthenticationScheme[]')

   foreach ($authenticationScheme in $item.authenticationSchemes) {
      $authenticationScheme.PSObject.TypeNames.Insert(0, 'Team.AuthenticationScheme')
   }

   if ($item.PSObject.Properties.Match('dataSources').count -gt 0 -and $null -ne $item.dataSources) {
      $item.dataSources.PSObject.TypeNames.Insert(0, 'Team.DataSource[]')

      foreach ($dataSource in $item.dataSources) {
         $dataSource.PSObject.TypeNames.Insert(0, 'Team.DataSource')
      }
   }
}

function Get-VSTeamServiceEndpointType {
   [CmdletBinding()]
   param(
      [Parameter(ParameterSetName = 'ByType')]
      [string] $Type,

      [Parameter(ParameterSetName = 'ByType')]
      [string] $Scheme
   )

   Process {

      if ($Type -ne '' -or $Scheme -ne '') {

         if ($Type -ne '' -and $Scheme -ne '') {
            $body = @{
               type   = $Type
               scheme = $Scheme
            }
         }
         elseif ($Type -ne '') {
            $body = @{
               type = $Type
            }
         }
         else {
            $body = @{
               scheme = $Scheme
            }
         }

         # Call the REST API
         $resp = _callAPI -Area 'distributedtask' -Resource 'serviceendpointtypes'  `
            -Version $([VSTeamVersions]::DistributedTask) -body $body
      }
      else {
         # Call the REST API
         $resp = _callAPI -Area 'distributedtask' -Resource 'serviceendpointtypes'  `
            -Version $([VSTeamVersions]::DistributedTask)
      }
      
      
      # Apply a Type Name so we can use custom format view and custom type extensions
      foreach ($item in $resp.value) {
         _applyTypesToServiceEndpointType -item $item
      }

      return $resp.value
   }
}

Set-Alias Get-ServiceEndpointType Get-VSTeamServiceEndpointType

Export-ModuleMember `
   -Function Get-VSTeamServiceEndpointType `
   -Alias Get-ServiceEndpointType