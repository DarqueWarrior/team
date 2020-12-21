using System.Collections;
using System.Collections.Generic;
using System.Diagnostics.CodeAnalysis;
using System.Management.Automation;
using System.Management.Automation.Abstractions;
using System.Management.Automation.Language;
namespace vsteam_lib
{
   public class FieldCompleter : BaseCompleter
   {
      /// <summary>
      /// This constructor is used when running in a PowerShell session. It cannot be
      /// loaded in a unit test.
      /// </summary>
      [ExcludeFromCodeCoverage]
      public FieldCompleter() : base() { }

      /// <summary>
      /// This constructor is used during unit testings
      /// </summary>
      /// <param name="powerShell">fake instance of IPowerShell used for testing</param>
      public FieldCompleter(IPowerShell powerShell) : base(powerShell) { }

      public override IEnumerable<CompletionResult> CompleteArgument(string commandName,
                                                                     string parameterName,
                                                                     string wordToComplete,
                                                                     CommandAst commandAst,
                                                                     IDictionary fakeBoundParameters)
      {
         var values = new List<CompletionResult>();

         IEnumerable<string> words = FieldCache.GetCurrent(false);

         ///for Fields match anywhere - not just at the start - so user doesn't need to know namespaces
         foreach (string word in words)
         {
            if (string.IsNullOrEmpty(wordToComplete) || word.ToLower().Contains(wordToComplete.ToLower()))
            {
               // Only wrap in single quotes if they have a space
               values.Add(new CompletionResult(word.Contains(" ") ? $"'{word}'" : word));
            }
         }

         return values;
      }
   }
}
