using namespace System.Collections
using namespace System.Collections.Generic
using namespace System.Management.Automation

# This class defines an attribute that allows the user the tab complete
# build definition names for function parameters. For this completer to
# work the users must have already provided the ProjectName parameter for
# the function or set a default project.
class BuildDefinitionCompleter : IArgumentCompleter {
   [IEnumerable[CompletionResult]] CompleteArgument(
      [string] $CommandName,
      [string] $ParameterName,
      [string] $WordToComplete,
      [Language.CommandAst] $CommandAst,
      [IDictionary] $FakeBoundParameters) {

      $results = [List[CompletionResult]]::new()

      # If the user has explictly added the -ProjectName parameter
      # to the command use that instead of the default project.
      $projectName = $FakeBoundParameters['ProjectName']

      # Only use the default project if the ProjectName parameter was
      # not used
      if (-not $projectName) {
         $projectName = _getDefaultProject
      }

      # If there is no projectName by this point just return a empty
      # list.
      if ($projectName) {
         foreach ($b in (Get-VSTeamBuildDefinition -ProjectName $projectName)) {
            if ($b.name -like "*$WordToComplete*" -and $b.name -notmatch '\W') {
               $results.Add([CompletionResult]::new($b.name))
            }
            elseif  ($b.name -like "*$WordToComplete*") {
               $results.Add([CompletionResult]::new("'$($b.name)'"))
            }
         }
      }

      return $results
   }
}
