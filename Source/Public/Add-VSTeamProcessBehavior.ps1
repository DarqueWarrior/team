function Add-VSTeamProcessBehavior {
   [CmdletBinding(SupportsShouldProcess=$true)]
   param (
      [Parameter(ValueFromPipelineByPropertyName=$true,Position=1)]
      [vsteam_lib.ProcessTemplateValidateAttribute()]
      [ArgumentCompleter([vsteam_lib.ProcessTemplateCompleter])]
      $ProcessTemplate = $env:TEAM_PROCESS,

      [Parameter(Mandatory=$true,Position=1)]
      [string]
      $Name,

      [ArgumentCompleter([vsteam_lib.ColorCompleter])]
      [vsteam_lib.ColorTransformToHexAttribute()]
      [String]$Color = "808080"

   )
   Process {
      $url = _getProcessTemplateUrl $ProcessTemplate 
      if (-not $url) {Write-Warning "Could not convert '$ProcessTemplate' into a process template"; return}
      else           {$Params = @{url = "$url/behaviors?api-version=" + (_getApiVersion Processes) } }

      $resp0  = (_callApi @params).value
      if ($resp0.name -contains $Name) {Write-Warning "'$Name' already exists!" ; return}

      $params['body'] = ConvertTo-Json @{
         name          = $Name
         color         = $Color
         inherits      = 'System.PortfolioBacklogBehavior' # this is the only supported one
         referenceName = "Custom.$Name"  #or you can have a custom.guid
      }

      if ($PSCmdlet.ShouldProcess($ProcessTemplate,"Add behavior named '$Name' to process")) {
         #Call the Rest API
         $resp = _callAPI @params -method Post  -ContentType "application/json" 
         
         # Apply a Type Name so we can use custom format view and custom type extensions
         # and add the processTemplate name so it can become a parameter when the object is piped into other functions
         $resp.psobject.TypeNames.Insert(0,'vsteam_lib.Processbehavior')
         Add-Member -InputObject $resp -MemberType NoteProperty -Name ProcessTemplate -Value $ProcessTemplate

         return $resp 
      }
   }
}
