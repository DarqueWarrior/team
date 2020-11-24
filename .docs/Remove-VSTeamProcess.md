<!-- #include "./common/header.md" -->

# Remove-VSTeamProcess

## SYNOPSIS

<!-- #include "./synopsis/Remove-VSTeamProcess.md" -->

## SYNTAX

## DESCRIPTION

<!-- #include "./synopsis/Remove-VSTeamProcess.md" -->

## EXAMPLES

### Example 1

```PowerShell
Remove-VSTeamProcess -Process Agile2     

Confirm
Are you sure you want to perform this action?
Performing the operation "DELETE Devops Process template" on target "Agile2".
[Y] Yes [A] Yes to All [N] No [L] No to All [S] Suspend [?] Help (default is "Yes"): y:
```

This deletes the custom process "Agile2"; because -Force was not specified, a confirmation prompt is shown.

## PARAMETERS

### -Confirm
Prompts you for confirmation before running the cmdlet. By default this command requires confirmation so this parameter is only needed if $ConfirmPreference has been changed.

<!-- #include "./params/force.md" -->


### -ProcessTemplate
The name of the process template which is to be deleted.

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
