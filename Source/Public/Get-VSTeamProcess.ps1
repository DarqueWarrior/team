# id: 02cc6a73-5cfb-427d-8c8e-b49fb086e8af
# area: processes
# resource name: processes
# route template: _apis/work/{resource}/{processTypeId}
#
# First appears in TFS 2017 U2 with same values in TFS 2017 U3:
# resourceVersion : 1
# minVersion      : 2.1
# maxVersion      : 3.2
# releasedVersion : 0.0
# However, I was unable to get any combination of versions to work.
#
# TFS 2018 U1 returns values
# resourceVersion : 1
# minVersion      : 2.1
# maxVersion      : 4.0
# releasedVersion : 0.0

function Get-VSTeamProcess {
   [CmdletBinding(DefaultParameterSetName = 'List',
    HelpUri='https://methodsandpractices.github.io/vsteam-docs/docs/modules/vsteam/commands/Get-VSTeamProcess')]
   [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '')]
   [outputType([vsteam_lib.process])]
   param(
      [Parameter(ParameterSetName = 'ByName', Position = 0)]
      [ArgumentCompleter([vsteam_lib.ProcessTemplateCompleter])]
      [Alias('ProcessName', 'ProcessTemplate')]
      $Name = '*',

      [Parameter(ParameterSetName = 'ByID')]
      [Alias('ProcessTemplateID')]
      [string] $Id,

      [switch] $ExpandProjects
   )
   process {
      $commonArgs = @{
         # In later APIs you can get the process templates from the 'work'
         # area. For older APIs the process templates are in the 'processes'
         # area. Default to the newer way of accessing process templates.
         # Get-VSTeamOption -area 'work' -resource 'processes' returns nothing
         # this is odd but the call works.
         area      = 'work'
         resource  = 'processes'
         NoProject = $true
         version   = $(_getApiVersion Processes)
      }

      # If this returns an empty string use the old area of 'process'
      if (-not $commonArgs.version) {
         $commonArgs.area = 'process'
      }

      if ($ExpandProjects) {
         $commonArgs['QueryString'] = @{'$expand'='projects'}
      }

      # Return either a single process by ID or a list of processes
      if ($id) {
         # Call the REST API with an ID
         $resp = _callAPI @commonArgs -id $id
         #Convert project objects, if present, to their names and output a process object.
         if ($resp.psobject.Members.name -contains "projects") {
            $resp.projects = [string[]]($resp.projects.name)
         }

         Write-Output ([vsteam_lib.Process]::new($resp))
      }
      else {
         try {
            # Call the REST API
            $resp = _callAPI @commonArgs | Select-Object -ExpandProperty value | Sort-Object -Property Name

            # We just fetched all the processes so let's update the cache.
            [vsteam_lib.ProcessTemplateCache]::Update([string[]]$($resp | Select-Object -ExpandProperty Name ))

            foreach ($process in $resp.where({ $_.name -like $Name })) {
               if   ($process.psobject.Members.name -contains "projects") {
                     $process.projects = [string[]]($process.projects.name)
               }

               Write-Output $([vsteam_lib.Process]::new($process))
            }
         }
         catch {
            # I catch because using -ErrorAction Stop on the Invoke-RestMethod
            # was still running the foreach after and reporting useless errors.
            # This casuses the first error to terminate this execution.
            _handleException $_
         }
      }
   }
}
