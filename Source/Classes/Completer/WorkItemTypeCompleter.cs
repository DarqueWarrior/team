using System.Diagnostics.CodeAnalysis;
using System.Management.Automation.Abstractions;
using System.Collections;
using System.Collections.Generic;
using System.Management.Automation;
using System.Management.Automation.Language;

namespace vsteam_lib
{
   public class WorkItemTypeCompleter : BaseCompleter
   {
      /// <summary>
      /// This constructor is used when running in a PowerShell session. It cannot be
      /// loaded in a unit test.
      /// </summary>
      [ExcludeFromCodeCoverage]
      public WorkItemTypeCompleter() : base() { }

      /// <summary>
      /// This constructor is used during unit testings
      /// </summary>
      /// <param name="powerShell">fake instance of IPowerShell used for testing</param>
      internal WorkItemTypeCompleter(IPowerShell powerShell) : base(powerShell) { }

      public override IEnumerable<CompletionResult> CompleteArgument(string commandName,
                                                                     string parameterName,
                                                                     string wordToComplete,
                                                                     CommandAst commandAst,
                                                                     IDictionary fakeBoundParameters)
      {
         var values = new List<CompletionResult>();

         // Can we use cached WorkItem types? Or has the user added
         // -ProcessTemplate & given a template that isn't the default?
         var ProcessTemplate  = fakeBoundParameters["ProcessTemplate"]?.ToString();
         if (string.IsNullOrEmpty(ProcessTemplate) || ( ProcessTemplate == Versions.DefaultProcess) )
         {
            SelectValues(wordToComplete, WorkItemTypeCache.GetCurrent(), values);
         }

         else {
            base._powerShell.Commands.Clear();
            var wits = base._powerShell.AddCommand("Get-VsteamWorkItemType")
                                         .AddParameter("ProcessTemplate", ProcessTemplate)
                                         .AddCommand("Select-Object")
                                         .AddParameter("ExpandProperty", "Name")
                                         .AddCommand("Sort-Object")
                                         .Invoke();
            foreach (var w in wits)
            {
               string word = w.ToString();
               if (string.IsNullOrEmpty(wordToComplete) || word.ToLower().StartsWith(wordToComplete.ToLower()))
               {
                  // Only wrap in single quotes if they have a space
                  values.Add(new CompletionResult(word.Contains(" ") ? $"'{word}'" : word));
               }
            }
         }
         return values;
      }
   }
}
