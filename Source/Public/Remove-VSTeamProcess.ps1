function Remove-VSTeamProcess {
   [CmdletBinding(DefaultParameterSetName='LeaveAlone',SupportsShouldProcess=$true,ConfirmImpact='High')]
   param (
      [parameter(Mandatory = $true,ValueFromPipelineByPropertyName=$true,Position=1)]
      [vsteam_lib.ProcessTemplateValidateAttribute()]
      [ArgumentCompleter([vsteam_lib.ProcessTemplateCompleter])]
      [Alias('Name','ProcessName')]
      $ProcessTemplate,

      [switch]$Force
   )
   process {
      forEach ($p in $ProcessTemplate){
         $url =  (_getProcessTemplateUrl $p.toString()) + "?api-version=" + (_getApiVersion Processes)
         if ($Force -or $PSCmdlet.ShouldProcess($P,'DELETE Process template')) {
            try {
               # Call the REST API
               $null = _callAPI -method Delete -url $url
            }
            Catch {
               Write-Error -Category InvalidResult -Activity "Remove-VSWorkItemProcess"  -Message "An error occured trying to remove $p"
            }
         }
      }
   }
}
