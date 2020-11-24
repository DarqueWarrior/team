function Add-VSTeamProcess {
   [cmdletbinding(SupportsShouldProcess=$true,ConfirmImpact='High')]
   [OutputType([vsteam_lib.Process])]
   param(
      [parameter(Mandatory = $true,ValueFromPipeline=$true)]
      [Alias('Name','ProcessTemplate')]
      [string[]] $ProcessName,

      [string] $Description,

      [string] $ReferenceName,

      [parameter(Mandatory = $true)]
      [vsteam_lib.ProcessTemplateValidateAttribute()]
      [ArgumentCompleter([vsteam_lib.ProcessTemplateCompleter])]
      [string]$ParentProcessName,

      [switch]$Force
   )
   begin {
      #Can't pipe many existing processes in, but can create multiple descendants of one existing one.
      if   ($ParentProcessName -is [vsteam_lib.Process]) {$parentProcess = $ParentProcessName}
      else {$parentProcess = Get-VSTeamProcess -Name $ParentProcessName}
   }
   process {
      #Can't pipe many existing processes in, but can create multiple descendants of one existing one.
      foreach ($p in $ProcessName) {
         if ($ParentProcessName -is [vsteam_lib.Process]) {$parentProcess = $ParentProcessName}
         else {$parentProcess = Get-VSTeamProcess -Name $ParentProcessName}
         if (-not $parentProcess) { Write-Warning "Could not resolve '$p'."; return   }

         $body          =  @{ 'parentProcessTypeId'  = $parentProcess.id
                              'name'                 = $P
         }
         if ($ReferenceName) {$body['referenceName'] = $ReferenceName}
         if ($Description)   {$body['description']   = $Description  }

         $commonArgs = @{
            Method      = "Post"
            NoProject   = $true
            Area        = 'work'
            Resource    = 'processes'
            Version     = _getApiVersion Processes
            Body        = ConvertTo-Json  $body
         }
         if ($Force -or $PSCmdlet.ShouldProcess($p,'Create New Process')) {
            # Call the REST API
            $resp = _callAPI @commonArgs

            if ($resp.psobject.Properties.name -notcontains 'typeid') {
               Write-Warning 'The server did not return an ID for a newly created process. '
            }
            else {
               [vsteam_lib.ProcessTemplateCache]::Invalidate()

               Write-Output ([vsteam_lib.Process]::new($resp))
            }
         }
      }
   }
}
