function Update-VSTeamVariableGroup {
   [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "Medium",
    HelpUri='https://methodsandpractices.github.io/vsteam-docs/docs/modules/vsteam/commands/Update-VSTeamVariableGroup')]
   param(
      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [string] $Id,

      [Parameter(ParameterSetName = 'ByHashtable', Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [string] $Name,

      [Parameter(ParameterSetName = 'ByHashtable', Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
      [string] $Description,

      [Parameter(ParameterSetName = 'ByHashtable', Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [hashtable] $Variables,

      [Parameter(ParameterSetName = 'ByBody', Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [string] $Body,

      [switch] $Force,

      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [vsteam_lib.ProjectValidateAttribute($false)]
      [ArgumentCompleter([vsteam_lib.ProjectCompleter])]
      [string] $ProjectName
   )

   DynamicParam {
      $dp = New-Object System.Management.Automation.RuntimeDefinedParameterDictionary

      if ($(_getApiVersion -Target) -ne "TFS2017" -and $PSCmdlet.ParameterSetName -eq "ByHashtable") {
         $ParameterName = 'Type'
         $rp = _buildDynamicParam -ParameterName $ParameterName -arrSet ('Vsts', 'AzureKeyVault') -Mandatory $true
         $dp.Add($ParameterName, $rp)

         $ParameterName = 'ProviderData'
         $rp = _buildDynamicParam -ParameterName $ParameterName -Mandatory $false -ParameterType ([hashtable])
         $dp.Add($ParameterName, $rp)
      }

      return $dp
   }

   Process {
      if ([string]::IsNullOrWhiteSpace($Body)) {
         $bodyAsHashtable = @{
            name        = $Name
            description = $Description
            variables   = $Variables
         }

         if ([vsteam_lib.Versions]::Version -ne "TFS2017") {
            $Type = $PSBoundParameters['Type']
            $bodyAsHashtable.Add("type", $Type)

            $ProviderData = $PSBoundParameters['ProviderData']
            if ($null -ne $ProviderData) {
               $bodyAsHashtable.Add("providerData", $ProviderData)
            }
         }

         $body = $bodyAsHashtable | ConvertTo-Json -Depth 100
      }

      if ($Force -or $pscmdlet.ShouldProcess($Id, "Update Variable Group")) {
         # Call the REST API
         $resp = _callAPI -Method PUT -ProjectName $projectName `
            -Area distributedtask `
            -Resource variablegroups `
            -Id $Id `
            -body $body `
            -Version $(_getApiVersion VariableGroups)

         Write-Verbose $resp

         return Get-VSTeamVariableGroup -ProjectName $ProjectName -Id $Id
      }
   }
}
