#include "./common/header.md"

# Add-VSTeamAccount

## SYNOPSIS

#include "./synopsis/Add-VSTeamAccount.md"

## SYNTAX

## DESCRIPTION

On Windows you have to option to store the information at the process, user
or machine (you must be running PowerShell as administrator to store at the
machine level) level.

On Linux and Mac you can only store at the process level.

Calling Add-VSTeamAccount will clear any default project.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------

```PowerShell
PS C:\> Add-VSTeamAccount
```

You will be prompted for the account name and personal access token.

### -------------------------- EXAMPLE 2 --------------------------

```PowerShell
PS C:\> Add-VSTeamAccount -Account mydemos -PersonalAccessToken 7a8ilh6db4aforlrnrqmdrxdztkjvcc4uhlh5vgbmgap3mziwnga
```

Allows you to provide all the information on the command line.

### -------------------------- EXAMPLE 3 --------------------------

```PowerShell
PS C:\> Add-VSTeamAccount -Account http://localtfs:8080/tfs/DefaultCollection -UseWindowsAuthentication
```

On Windows, allows you use to use Windows authentication against a local TFS server.

### -------------------------- EXAMPLE 4 --------------------------

```PowerShell
PS C:\> Add-VSTeamAccount -Profile demonstrations
```

Will add the account from the profile provided.

### -------------------------- EXAMPLE 5 --------------------------

```PowerShell
PS C:\> Add-VSTeamAccount -Profile demonstrations -Drive demo
PS C:\> Set-Location demo:
PS demo:\> Get-ChildItem
```

Will add the account from the profile provided and mount a drive named demo that you can navigate like a file system.

### -------------------------- EXAMPLE 6 --------------------------

```PowerShell
PS C:\> Add-VSTeamAccount -Profile demonstrations -Level Machine
```

Will add the account from the profile provided and store the information at the Machine level. Now any new PowerShell sessions will auto load this account.

Note: You must run PowerShell as an Adminstrator to store at the Machine level.

## PARAMETERS

### -Account

The Visual Studio Team Services (VSTS) account name to use.
DO NOT enter the entire URL.

Just the portion before visualstudio.com. For example in the
following url mydemos is the account name.
<https://mydemos.visualstudio.com>
or
The full Team Foundation Server (TFS) url including the collection.
<http://localhost:8080/tfs/DefaultCollection>

```yaml
Type: String
Parameter Sets: Secure (Default)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

```yaml
Type: String
Parameter Sets: Plain, Windows
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PAT

A secured string to capture your personal access token.

This will allow you to provide your personal access token
without displaying it in plain text.

To use pat simply omit it from the Add-VSTeamAccount command.

```yaml
Type: SecureString
Parameter Sets: Secure (Default)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Level

On Windows allows you to store your account information at the Process, User or Machine levels.
When saved at the User or Machine level your account information will be in any future PowerShell processes.

To store at the Machine level you must be running PowerShell as an Administrator.

```yaml
Type: String
Parameter Sets: Secure, Plain (Default)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PersonalAccessToken

The personal access token from VSTS/TFS to use to access this account.

```yaml
Type: String
Parameter Sets: Plain
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -UseWindowsAuthentication

Allows the use of the current user's Windows credentials to authenticate against a local TFS.

```yaml
Type: SwitchParameter
Parameter Sets: Windows
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Profile

The profile name stored using Add-VSTeamProfile function. You can tab complete through existing profile names.

```yaml
Type: String
Parameter Sets: Profile
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

#include "./params/version.md"

### -Drive

The name of the drive you want to mount to this account. The command you need to run will be presented. Simply copy and paste the command to mount the drive. To use the drive run Set-Location *driveName*:

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: false
Position: Named
Default value:
Accept pipeline input: False
Accept wildcard characters: False
```

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS

[Add-VSTeamAccount](Add-VSTeamAccount.md)
[Add-VSTeamProfile](Add-VSTeamProfile.md)
[Set-VSTeamDefaultProject](Set-VSTeamDefaultProject.md)