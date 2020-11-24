<!-- #include "./common/header.md" -->

#Connect-VSTeam

## SYNOPSIS

<!-- #include "./synopsis/Connect-VSTeam.md" -->

## SYNTAX

## DESCRIPTION
Connects using an account name and optional prokect and an access token, OR
using a credential object with the access token as the passwords and account/project as the username (the /project part is optional) or using an exported credential object - which can can only be read by the user who created it. If -save is specified the credential will be written to a file. 

## EXAMPLES

### Example 1
```powershell
 Connect-VSTeam -Save -Account "my-azure-devops-account" -Project 'Proj1' -TokenFromClipboard  
```
Here the accesstoken has just been created in the portal and copied to the windows clipboard, so the -TokenFromClipboard switch is used, the user is connected to the account and a default project is set. A credential object with a user name of 
"my-azure-devops-account/Proj1" is created with the access token as the password. The Credential is saved, no path is given so the default path VsTeamCred.xml in the user's home directory is used.  The password is stored in this file as a securestring which can only be decoded by the user who created it. 
After the command is run the user is logged in and the default project is set

### Example 2
```powershell
 Connect-VSTeam
```
This will connect the user the default XML file -  VsTeamCred.xml in their home directory 

### Example 3
```powershell
 Connect-VSTeam -save -path NewProject.xml 
```
This will create the a new credential file - because no account has been specified the user will be prompted for credentials, and can enter account/project or just account as the user name, and the accesstoken as the password. 
later sessions can login with  connect-vsteam -path NewProject.xml 


### Example 4
```powershell
 Connect-VSTeam  -TokenFromClipboard -Save -Path Project4.xml
```
This version will create a new credential file, however the user is already logged on so the account name and default project are visible, and as with example 1 the the access token is in the clipboard so the user is re-logged on with the access token, re-connected to the same account and project, and the credentials are written to a file. 

## PARAMETERS

### -Account
The Azure DevOps (AzD) account name to use. 
DO NOT enter the entire URL. Just the portion after dev.azure.com. For example in the
following url mydemos is the account name.
<https://dev.azure.com/mydemos>

If the PowerShell session has a connection, the current account will be used by default.

```yaml
Type: String
Parameter Sets: None, Clipboard, Secure, Insecure
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Credential
A credential object with the Account / Azure Devops organization name and optionally the project name as the username, and the access token as the password. 

```yaml
Type: PSCredential
Parameter Sets: Cred
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Path
Path to an existing credential XML file, or if -Save is specified the path to a file to be created or over-written (no warning is given when overwriting). By default the file name  VsTeamCred.xml is used and the file is located in the users home directory.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PersonalAccessToken
The access token as a plain string. It is preferable not to enter this as a string literal in at the commandline or in a script, ideally it is created and copied and the -TokenFromClipboard switch is used, or it is stored as a secureString.  

```yaml
Type: String
Parameter Sets: Insecure
Aliases: Token

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Project
The name of the default project to connect to; if signed in this should tab complete with the names from the current project. 

```yaml
Type: String
Parameter Sets: None, Clipboard, Secure, Insecure
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Save
If specified the credential will be saved to file determined by the path parameter. If the file exists it will be overwritten. 

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SecurePersonalAccessToken
The personal accesstoken as a SecureString. 

```yaml
Type: SecureString
Parameter Sets: Secure
Aliases: PAT

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -TokenFromClipboard
Specifies that the token is currently in the clipboard. This relies on the PowerShell command Get-Clipboard, which may not be present on all platforms. 

```yaml
Type: SwitchParameter
Parameter Sets: Clipboard
Aliases: Clipboard

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -UseBearerToken
Switches the authorization from Basic to Bearer.  You still use the PAT for PersonalAccessToken parameters to store the token.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

<!-- #include "./params/version.md" -->

## INPUTS

## OUTPUTS
 
## NOTES

## RELATED LINKS
<!-- #include "./common/related.md" -->