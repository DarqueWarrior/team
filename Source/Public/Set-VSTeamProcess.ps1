function Set-VSTeamProcess {
   [CmdletBinding(DefaultParameterSetName='LeaveAlone',SupportsShouldProcess=$true,ConfirmImpact='High')]
   [OutputType([vsteam_lib.Process])]
   param (
      [parameter(Mandatory = $true,ValueFromPipelineByPropertyName=$true,Position=1)]
      [vsteam_lib.ProcessTemplateValidateAttribute()]
      [ArgumentCompleter([vsteam_lib.ProcessTemplateCompleter])]
      [Alias('Name')]
      $ProcessTemplate,

      [String]$Description,

      [String]$NewName,

      [parameter(ParameterSetName='Hide', Mandatory = $true)]
      [switch]$Disabled,

      [parameter(ParameterSetName='Show', Mandatory = $true)]
      [switch]$Enabled,

      [parameter(ParameterSetName='LeaveAlone')]
      [parameter(ParameterSetName='Show')]
      [switch]$AsDefault,

      [switch]$Force
   )
   process {
      if ($PSBoundParameters.Keys.count -lt 2 -or ($Force -and $PSBoundParameters.Keys.count -lt 2)) {
         Write-Warning "Nothing to do!" ; return
      }
      $url =  _getProcessTemplateUrl $ProcessTemplate
      if (-not $url) {Write-Warning "Could not find the Process for '$ProcessTemplate" ; return}

      $body = @{}
      if ($Description) {$body['description'] = $Description}
      if ($NewName    ) {$body['name']        = $NewName}
      if ($Disabled   ) {$body['IsEnabled']   = $false}
      if ($Enabled    ) {$body['IsEnabled']   = $true}
      if ($AsDefault  ) {$body['IsDefault']   = $true}

      $commonArgs = @{
         Method      = "Patch"
         URL         =  $url + "?api-version=" + (_getApiVersion Processes)
         Body        = ConvertTo-Json  $body
      }

      if ($Force -or $PSCmdlet.ShouldProcess($ProcessTemplate,'Update Process template')) {
         # Call the REST API
         $resp = _callAPI @commonArgs
         if ($resp.psobject.Properties.name -Notcontains 'typeid') {
            Write-Warning 'The server did not return an ID for a modified process. '
         }
         else {

            return [vsteam_lib.Process]::new($resp)

         }
      }
   }
}
