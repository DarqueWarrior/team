function Add-VSTeamWorkItemType {
   [cmdletbinding(SupportsShouldProcess=$true)]
   param(
      [Parameter(Position=0, ValueFromPipelineByPropertyName = $true)]
      [vsteam_lib.ProcessTemplateValidateAttribute()]
      [ArgumentCompleter([vsteam_lib.ProcessTemplateCompleter])]
      $ProcessTemplate = $env:TEAM_PROCESS,

      [parameter(Mandatory = $true,Position=1)]
      [Alias('Name')]
      [string] $WorkItemType,

      [string] $Description,

      [ArgumentCompleter([vsteam_lib.ColorCompleter])]
      [vsteam_lib.ColorTransformToHexAttribute()]
      $Color = '000000',

      [vsteam_lib.IconTransformAttribute()]
      [ArgumentCompleter([vsteam_lib.IconCompleter])]
      [string]$Icon = 'icon_asterisk'
   )
   process {
      #Allow additions to more than one ProcessTemplate
      foreach ($pt in $ProcessTemplate) {
         $url =  _getProcessTemplateUrl $pt
         if ($url) {$url += "/workitemtypes?api-version=" + (_getApiVersion Processes)}
         else      {Write-Warning "Could not convert '$pt' into a process template"; return}

         $body  = @{
            name  = $WorkItemType
            color = $Color
            icon  = $Icon
         }
         if ($Description)  {$body['description'] =$Description }

         if ($PSCmdlet.ShouldProcess($pt, "Add workitem '$WorkItemType' to process template"))  {
            # Call the Rest API. _callAPi displays errors for the user and throws,
            # if this happens half way through adding to mulitple process templates
            # don't stop with some done and some not.
            try {
               $resp = _callapi -Url $url -method  Post -body (ConvertTo-Json $body) -ErrorAction Stop
            }
            catch {
               Write-Warning "An error occured trying to add a workitem type to Process template '$pt'"
               continue
            }
            if ($pt -eq $env:TEAM_PROCESS) {[vsteam_lib.WorkItemTypeCache]::Invalidate()}

            $resp.PSObject.TypeNames.Insert(0, 'vsteam_lib.WorkItemType')
            Add-Member -InputObject $resp -MemberType AliasProperty -Name WorkItemType    -Value "name"
            Add-Member -InputObject $resp -MemberType NoteProperty  -Name ProcessTemplate -Value $pt

            Write-Output $resp
         }
      }
   }
}
