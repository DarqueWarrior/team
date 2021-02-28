function Get-VSTeamWorkItemIconList {
   [CmdletBinding()]
   param()

   process {

      $commonArgs = @{
         Area                 = 'wit' 
         Resource             = 'workitemicons'
         IgnoreDefaultProject = $true
         Version              = $(_getApiVersion Processes)
      }
      # Call the REST API
      $resp = _callAPI @commonArgs 

      Write-Output $resp.value
   }
}
