function Set-VSTeamAccount {
   [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "Low", DefaultParameterSetName = 'Secure',
    HelpUri='https://methodsandpractices.github.io/vsteam-docs/docs/modules/vsteam/commands/Set-VSTeamAccount')]
   param(
      [parameter(ParameterSetName = 'Windows', Mandatory = $true, Position = 1)]
      [parameter(ParameterSetName = 'Secure', Mandatory = $true, Position = 1)]
      [Parameter(ParameterSetName = 'Plain', Mandatory = $true, Position = 1)]
      [string] $Account,

      [parameter(ParameterSetName = 'Plain', Mandatory = $true, Position = 2, HelpMessage = 'Personal Access or Bearer Token')]
      [Alias('Token')]
      [string] $PersonalAccessToken,

      [parameter(ParameterSetName = 'Secure', Mandatory = $true, HelpMessage = 'Personal Access or Bearer Token')]
      [Alias('PAT')]
      [securestring] $SecurePersonalAccessToken,

      [parameter(ParameterSetName = 'Windows')]
      [parameter(ParameterSetName = 'Secure')]
      [Parameter(ParameterSetName = 'Plain')]
      [ValidateSet('TFS2017', 'TFS2018', 'AzD2019', 'VSTS', 'AzD', 'TFS2017U1', 'TFS2017U2', 'TFS2017U3', 'TFS2018U1', 'TFS2018U2', 'TFS2018U3', 'AzD2019U1')]
      [string] $Version,

      [string] $Drive,

      [parameter(ParameterSetName = 'Secure')]
      [Parameter(ParameterSetName = 'Plain')]
      [switch] $UseBearerToken,

      [switch] $Force
   )

   DynamicParam {
      # Create the dictionary
      $RuntimeParameterDictionary = New-Object System.Management.Automation.RuntimeDefinedParameterDictionary

      $vsteamProfileArrSet = Get-VSTeamProfile | Select-Object -ExpandProperty Name

      if ($vsteamProfileArrSet) {
         $vsteamProfileParam = _buildDynamicParam -ParameterName 'Profile' -ParameterSetName 'Profile' -arrSet $vsteamProfileArrSet
      }
      else {
         $vsteamProfileParam = _buildDynamicParam -ParameterName 'Profile' -ParameterSetName 'Profile'
      }

      $RuntimeParameterDictionary.Add('Profile', $vsteamProfileParam)

      # Only add these options on Windows Machines
      if (_isOnWindows) {
         # Generate and set the ValidateSet
         $arrSet = "Process", "User"

         if (_testAdministrator) {
            $arrSet += "Machine"
         }

         $levelParam = _buildDynamicParam -ParameterName 'Level' -arrSet $arrSet
         $RuntimeParameterDictionary.Add('Level', $levelParam)

         $winAuthParam = _buildDynamicParam -ParameterName 'UseWindowsAuthentication' -Mandatory $true -ParameterSetName 'Windows' -ParameterType ([switch])
         $RuntimeParameterDictionary.Add('UseWindowsAuthentication', $winAuthParam)
      }

      return $RuntimeParameterDictionary
   }

   process {
      # invalidate cache when changing account/collection
      # otherwise dynamic parameters being picked for a wrong collection
      [vsteam_lib.ProjectCache]::Invalidate()

      # Bind the parameter to a friendly variable
      $vsteamProfile = $PSBoundParameters['Profile']

      if (_isOnWindows) {
         # Bind the parameter to a friendly variable
         $Level = $PSBoundParameters['Level']

         if (-not $Level) {
            $Level = "Process"
         }

         $UsingWindowsAuth = $PSBoundParameters['UseWindowsAuthentication']
      }
      else {
         $Level = "Process"
      }

      if ($vsteamProfile) {
         $info = Get-VSTeamProfile | Where-Object Name -eq $vsteamProfile

         if ($info) {
            $encodedPat = $info.Pat
            $account = $info.URL
            $version = $info.Version
            $token = $info.Token
         }
         else {
            Write-Error "The profile provided was not found."
            return
         }
      }
      else {
         if ($SecurePersonalAccessToken) {
            # Convert the securestring to a normal string
            # this was the one technique that worked on Mac, Linux and Windows
            $credential = New-Object System.Management.Automation.PSCredential $account, $SecurePersonalAccessToken
            $_pat = $credential.GetNetworkCredential().Password
         }
         else {
            $_pat = $PersonalAccessToken
         }

         # If they only gave an account name add https://dev.azure.com
         if ($Account -notlike "*/*") {
            $Account = "https://dev.azure.com/$($Account)"
         }
         # If they gave https://xxx.visualstudio.com convert to new URL
         if ($Account -match "(?<protocol>https?\://)?(?<account>[A-Z0-9][-A-Z0-9]*[A-Z0-9])(?<domain>\.visualstudio\.com)") {
            $Account = "https://dev.azure.com/$($matches.account)"
         }

         if ($UseBearerToken.IsPresent) {
            $token = $_pat
            $encodedPat = ''
         }
         else {
            $token = ''
            $encodedPat = [System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes(":$_pat"))
         }

         # If no SecurePersonalAccessToken is entered, and on windows, are we using default credentials for REST calls
         if ((!$_pat) -and (_isOnWindows) -and ($UsingWindowsAuth)) {
            Write-Verbose "Using Default Windows Credentials for authentication; no Personal Access Token required"
            $encodedPat = ''
            $token = ''
         }
      }

      if ((_isOnWindows) -and ($UsingWindowsAuth) -and $(_isVSTS $Account)) {
         Write-Error "Windows Auth can only be used with Team Fondation Server or Azure DevOps Server.$([Environment]::NewLine)Provide a Personal Access Token or Bearer Token to connect to Azure DevOps Services."
         return
      }

      if ($Force -or $pscmdlet.ShouldProcess($Account, "Set Account")) {
         # Piped to null so callers can pipe to Invoke-Expression to mount the drive on one line.
         Clear-VSTeamDefaultProject *> $null
         _setEnvironmentVariables -Level $Level -Pat $encodedPat -Acct $account -BearerToken $token -Version $Version

         Set-VSTeamAPIVersion -Target (_getVSTeamAPIVersion -Instance $account -Version $Version)

         #Reset all caches when Signing in.
         [vsteam_lib.FieldCache]::Invalidate()
         [vsteam_lib.IconCache]::Invalidate()
         [vsteam_lib.PickListCache]::Invalidate()
         [vsteam_lib.ProcessTemplateCache]::Invalidate()
         [vsteam_lib.ProjectCache]::Invalidate()
         [vsteam_lib.QueryCache]::Invalidate()
         [vsteam_lib.WorkItemTypeCache]::Invalidate()

         if ($Drive) {
            # Assign to null so nothing is writen to output.
            Write-Output "# To map a drive run the following command or pipe to iex:`nNew-PSDrive -Name $Drive -PSProvider SHiPS -Root 'VSTeam#vsteam_lib.Provider.Account' -Description $account"
         }
      }
   }
}