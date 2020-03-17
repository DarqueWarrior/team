function Update-VSTeamServiceEndpoint {
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "Medium")]
    param(
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [string] $id,
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [hashtable] $object,
        [switch] $Force,
        [Parameter(Mandatory=$true, Position = 0 )]
        [ValidateProjectAttribute()]
        [ArgumentCompleter([ProjectCompleter])]
        $ProjectName
    )
    process {
                $body = $object | ConvertTo-Json
        if ($Force -or $pscmdlet.ShouldProcess($id, "Update Service Endpoint")) {
            # Call the REST API
            $resp = _callAPI -ProjectName $projectName -Area 'distributedtask' -Resource 'serviceendpoints' -Id $id  `
                -Method Put -ContentType 'application/json' -body $body -Version $([VSTeamVersions]::DistributedTask)
            _trackServiceEndpointProgress -projectName $projectName -resp $resp -title 'Updating Service Endpoint' -msg "Updating $id"
            return Get-VSTeamServiceEndpoint -ProjectName $ProjectName -id $id
        }
    }
}
