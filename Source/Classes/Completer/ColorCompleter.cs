using System.Management.Automation.Language;
using System.Drawing;
using System.Reflection;
using System.Collections;
using System.Collections.Generic;
using System.Diagnostics.CodeAnalysis;
using System.Globalization;
using System.Management.Automation;

namespace vsteam_lib
{
    public class ColorCompleter  : IArgumentCompleter
    {
      [ExcludeFromCodeCoverage]
      public ColorCompleter() : base() { }
        public  IEnumerable<CompletionResult> CompleteArgument(string commandName, string parameterName, string wordToComplete, CommandAst commandAst, IDictionary fakeBoundParameters) 
        {
            var values = new List<CompletionResult>();
            List<string> colorlist = new List<string>();
            foreach (PropertyInfo p in typeof(Color).GetProperties() ) {
                if (p.PropertyType == typeof(Color)) {
                    colorlist.Add(p.Name);
                }
            }
            SelectValues(wordToComplete, colorlist, values);
            return values;
        }
        /// following module style.
        protected static void SelectValues(string wordToComplete, IEnumerable<string> words, List<CompletionResult> values)
        {
             foreach (var word in words)
            {
                if (string.IsNullOrEmpty(wordToComplete) || word.StartsWith(wordToComplete, true, CultureInfo.InvariantCulture))
                {
                    // Only wrap in single quotes if they have a space. 
                    values.Add(new CompletionResult(word.Contains(" ") ? $"'{word}'" : word));
                }
            }
        }
    }
}
