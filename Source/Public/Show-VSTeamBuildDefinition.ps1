function Show-VSTeamBuildDefinition {
   [CmdletBinding(DefaultParameterSetName = 'List',
    HelpUri='https://methodsandpractices.github.io/vsteam-docs/docs/modules/vsteam/Show-VSTeamBuildDefinition')]
   param(
      [Parameter(ParameterSetName = 'List')]
      [ValidateSet('Mine', 'All', 'Queued', 'XAML')]
      [string] $Type = 'All',

      [Parameter(ParameterSetName = 'ByID', Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [Alias('BuildDefinitionID')]
      [int[]] $Id,

      [Parameter(ParameterSetName = 'List')]
      [string] $Path = '\',

      [Parameter(Mandatory = $true, Position = 0, ValueFromPipelineByPropertyName = $true)]
      [vsteam_lib.ProjectValidateAttribute($false)]
      [ArgumentCompleter([vsteam_lib.ProjectCompleter])]
      [string] $ProjectName
   )
   process {
      # Build the url
      $url = "$(_getInstance)/$ProjectName/_build"

      if ($id) {
         $url += "/index?definitionId=$id"
      }
      else {
         switch ($type) {
            'Mine' {
               $url += '/index?_a=mine&path='
            }
            'XAML' {
               $url += '/xaml&path='
            }
            'Queued' {
               $url += '/index?_a=queued&path='
            }
            Default {
               # All
               $url += '/index?_a=allDefinitions&path='
            }
         }

         # Make sure path starts with \
         if ($Path[0] -ne '\') {
            $Path = '\' + $Path
         }
         $url += [System.Web.HttpUtility]::UrlEncode($Path)
      }

      Show-Browser $url
   }
}