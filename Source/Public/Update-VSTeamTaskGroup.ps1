function Update-VSTeamTaskGroup {
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "Low")]
    param(
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [string] $Id,
        [Parameter(ParameterSetName = 'ByFile', Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [string] $InFile,
        [Parameter(ParameterSetName = 'ByBody', Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [string] $Body,
        [switch] $Force,
        [Parameter(Mandatory=$true, Position = 0 )]
        [ValidateProjectAttribute()]
        [ArgumentCompleter([ProjectCompleter])]
        $ProjectName
    )
    process {
                if ($Force -or $pscmdlet.ShouldProcess("Update Task Group")) {
            if ($InFile) {
                $resp = _callAPI -Method Put -ProjectName $ProjectName -Area distributedtask -Resource taskgroups -Version $([VSTeamVersions]::TaskGroups) -InFile $InFile -ContentType 'application/json' -Id $Id
            }
            else {
                $resp = _callAPI -Method Put -ProjectName $ProjectName -Area distributedtask -Resource taskgroups -Version $([VSTeamVersions]::TaskGroups) -Body $Body -ContentType 'application/json' -Id $Id
            }
        }
        return $resp
    }
}
