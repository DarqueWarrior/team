<!-- #include "./common/header.md" -->

# Set-VSTeamProcess

## SYNOPSIS

<!-- #include "./synopsis/Set-VSTeamProcess.md" -->

## SYNTAX

## DESCRIPTION

<!-- #include "./synopsis/Set-VSTeamProcess.md" -->

## EXAMPLES

### Example 1

```PowerShell
Set-VSTeamProcess -name Agile -AsDefault

Confirm
Are you sure you want to perform this action?
Performing the operation "Update Devops Process" on target "Agile".
[Y] Yes [A] Yes to All [N] No [L] No to All [S] Suspend [?] Help (default is "Yes"): y


Name  Enabled Default Description
----  ------- ------- -----------
Agile True    True    This template is flexible and will work great for most teams...
```

This command sets the built-in process "Agile" as the default process, and prompts the user to confirm the action.

### Example 2

```PowerShell
Get-VSTeamProcess -Name Basic | Set-VSTeamProcess -Disabled -Force

Name  Enabled Default Description
----  ------- ------- -----------
Basic False   False   This template is flexible for any process...
```

The first command in the pipeline gets built-in process "Basic", and the second disables it without waiting for confirmation.
The Get- command could take a wildcard and return multiple matching processes, which would cause them all to be disabled.

### Example 3

```PowerShell
PS C:\> Set-VSTeamProcess -ProcessTemplate 'Basic J' -NewName 'Basic-J' -Description 'Template for the Mysterious J Project' -Force


Name    Enabled Default Description
----    ------- ------- -----------
Basic-J True    False   Template for the Mysterious J Project
```

This renames a project to remove the space from its name, and gives it a new description.

## PARAMETERS

### -AsDefault

Makes a process the default for new projects in the organization

```yaml
Type: SwitchParameter
Parameter Sets: LeaveAlone, Show
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Confirm
Prompts you for confirmation before running the cmdlet. By default this command requires confirmation so this parameter is only needed if $ConfirmPreference has been changed.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```
### -Description

A new description for the new process.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Disabled

Disables a process; built-in processes cannot be deleted but can be disabled.

```yaml
Type: SwitchParameter
Parameter Sets: Hide
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Enabled

Re-enables a disabled process.

```yaml
Type: SwitchParameter
Parameter Sets: Show
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

<!-- #include "./params/force.md" -->

### -NewName

Allows the process to be renamed.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ProcessTemplate
The current name of the process template which is to be modified.

```yaml
Type: Object
Parameter Sets: (All)
Aliases: Name

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

<!-- #include "./params/whatif.md" -->

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS

[Add-VSTeamProcess](Add-VSTeamProcess.md)

[Get-VSTeamProcess](Get-VSTeamProcess.md)

[Remove-VSTeamProcess](Remove-VSTeamProcess.md)