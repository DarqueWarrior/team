function Connect-VSTeam {
   [cmdletbinding(DefaultParameterSetName='None')]
   param(
      [parameter(Position=0)]
      $Path = (Join-path ([System.Environment]::GetFolderPath("UserProfile"))  "VsTeamCred.xml"),

      [parameter(ParameterSetName = 'None' )]
      [parameter(ParameterSetName = 'Insecure' )]
      [parameter(ParameterSetName = 'Secure'   )]
      [parameter(ParameterSetName = 'Clipboard')]
      [string] $Account = ([vsteam_lib.Versions]::Account -replace '^.*/'),

      [parameter(ParameterSetName = 'Insecure',Mandatory=$true)]
      [Alias('Token')]
      [string] $PersonalAccessToken,

      [parameter(ParameterSetName = 'Secure',Mandatory=$true)]
      [Alias('PAT')]
      [securestring] $SecurePersonalAccessToken,

      [parameter(ParameterSetName = 'Clipboard',Mandatory=$true)]
      [Alias('Clipboard')]
      [switch] $TokenFromClipboard,

      [parameter(ParameterSetName = 'Cred')]
      [pscredential]$Credential,

      [parameter(ParameterSetName = 'None',      Mandatory=$false)]
      [parameter(ParameterSetName = 'Insecure',  Mandatory=$false)]
      [parameter(ParameterSetName = 'Secure',    Mandatory=$false)]
      [parameter(ParameterSetName = 'Clipboard', Mandatory=$false)]
      [ArgumentCompleter([vsteam_lib.ProjectCompleter])]
      [string] $Project ,

      [ValidateSet('TFS2017', 'TFS2018', 'AzD2019', 'VSTS', 'AzD', 'TFS2017U1', 'TFS2017U2', 'TFS2017U3', 'TFS2018U1', 'TFS2018U2', 'TFS2018U3', 'AzD2019U1')]
      [string] $Version,

      [switch] $Save,

      [switch] $UseBearerToken
   )

   if (-not $Project -and $Account -eq ([vsteam_lib.Versions]::Account -replace '^.*/') -and $env:TEAM_PROJECT) {
      Write-Verbose "Setting the default project to the current project, ' $env:TEAM_PROJECT'.'"
      $Project = $env:TEAM_PROJECT
   }
   elseif ( $Project -and $Account -ne "" -and $Account -eq ([vsteam_lib.Versions]::Account -replace '^.*/') ) {
      $validProjects = [vsteam_lib.ProjectCache]::GetCurrent($false)
      if ($validProjects.count -ge 1 -and $validProjects -notcontains $Project) {
         Write-Warning "'$Project' is not a valid project name" ; return
      }
   }
   # If account wasn't specified, and we're not overwriting creds, get saved creds if they exist.
   if ( (Test-path $path -PathType Leaf) -and -not $Save -and -not $PSBoundParameters.ContainsKey('Account')) {
      $Credential = Import-Clixml $Path
   }
   #if we didn't read creds but have a plain text token from a parameter or the clipboard make it a secure string
   elseif ($PersonalAccessToken) {
      $SecurePersonalAccessToken = ConvertTo-SecureString $PersonalAccessToken -AsPlainText -Force
   }
   elseif ($TokenFromClipboard) {
      Write-Verbose "Getting Personal Access token from the clipboard."
      try {
         $SecurePersonalAccessToken = ConvertTo-SecureString (Get-Clipboard) -AsPlainText -Force
      }
      catch {
         Write-Warning "Clipboard contents were not valid." ; return
      }
   }

   # if we don't have the access token or credential object, get the credential from the user
   if (-not ($SecurePersonalAccessToken -or $Credential )) {
      $GCParams = @{Message =  "Use org org/project as a user name, e.g. from  https://dev.azure.com/My_Org/project and accesstoken as password"}
      if ($PSVersionTable.Platform -like 'win*' -and $PSVersionTable.PSEdition -eq 'core') {
         $GCParams['Title'] = "Use [shift][insert] or mouse to paste access token as password."
      }
      if ($Account) {$GCParams['UserName']=("$account/$project" -replace '/$')}
      $Credential = Get-Credential @GCParams
   }

   # if we got the credential by reading from a file or user input, use the password
   # as the token and username for account/project; and if we're saving do that here.
   if ($Credential) {
      $Account = ($Credential.UserName -split  '/|\\')[0]
      Write-verbose "Account is '$Account'."
      if (-not $PSBoundParameters.ContainsKey('Project')) {
         $Project = ($Credential.UserName -split  '/|\\')[1]
         Write-verbose "Project is '$Project'."
      }
      else {Write-verbose "Using input parameter '$Project' for Project." }

      $SecurePersonalAccessToken = $Credential.Password
      if ($Save) {
         Write-verbose "Saving credential for $($Credential.UserName) to $path"
         $credential | Export-Clixml -Path $Path
      }
   }
   # but we were told to save a token and account and, make a credential and save it.
   elseif ($SecurePersonalAccessToken -and $Account -and $Save ) {
      $userName = ("$Account/$Project" -replace '/$')
      Write-Verbose "Saving credential for '$UserName' to $path."
      [pscredential]::new($userName,$SecurePersonalAccessToken) | Export-Clixml -Path $Path
   }

   #We should have account & token from parameters file or user input.
   if (-not $Account -or -not $SecurePersonalAccessToken) {
      Write-Warning "Can't connect without an account and an access token"; return
   }
   else {
      Write-verbose "Logging on..."
      $SetVSTAParams = @{
         Account = $Account
         UseBearerToken = [boolean]$UseBearerToken
         SecurePersonalAccessToken = $SecurePersonalAccessToken
      }
      if ($Version) {$SetVSTAParams['Version']=$Version}
      Set-VSTeamAccount @SetVSTAParams
      if ($Project) {
         Set-VSTeamDefaultProject -Project $Project
<#       #this is Set-VSTeamDefaultProject -  for now.
         $env:TEAM_PROCESS = [vsteam_lib.Versions]::DefaultProcess = Get-VSTeamProcess  -ExpandProjects |
               Where-Object Projects -Contains $Project | Select-Object -ExpandProperty Name
#>
         if ($env:TEAM_PROCESS) {
            Write-Verbose "Set default process template to '$env:TEAM_PROCESS'."
         }
      }
   }
}