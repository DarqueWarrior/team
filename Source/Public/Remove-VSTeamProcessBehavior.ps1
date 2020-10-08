function Remove-VSTeamProcessBehavior {
   [CmdletBinding(SupportsShouldProcess=$true,ConfirmImpact='High')]
   param (
      [Parameter(ValueFromPipelineByPropertyName=$true,Position=1)]
      [vsteam_lib.ProcessTemplateValidateAttribute()]
      [ArgumentCompleter([vsteam_lib.ProcessTemplateCompleter])]
      $ProcessTemplate = $env:TEAM_PROCESS,

      [Parameter(Mandatory=$true,Position=1)]
      [string]
      $Name,

      [switch]
      $Force
   )
   Process {
      
      $behavior = Get-VSTeamProcessBehavior -ProcessTemplate $ProcessTemplate | 
                     Where-Object -Property name -eq $Name

      if (-not $behavior) {Write-Warning "'$Name' is not a process behavior in $ProcessTemplate" ; return}
      $Params= @{
         url         = $behavior.url + "?api-version=" + (_getApiVersion Processes) 
         method      = 'Delete'
      }
      if ($Force -or $PSCmdlet.ShouldProcess($ProcessTemplate,"Remove behavior named '$Name' from process")) {
         #Call the Rest API
         $null = _callAPI @params 
      }
   }
}
