using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Management.Automation;
namespace vsteam_lib
{
   public class ProcessTemplateValidateAttribute : BaseValidateArgumentsAttribute
   {
      internal override IEnumerable<string> GetValues() => ProcessTemplateCache.GetCurrent();

      protected override void Validate(object arguments, EngineIntrinsics engineIntrinsics)
      {
         if (string.IsNullOrEmpty(arguments?.ToString()))
         {
            return;
         }

         if (arguments is object[])
         {
            IEnumerable enumerable = arguments as IEnumerable;
            foreach (var item in enumerable)
            {
                Validate(item,engineIntrinsics);
            }
            return;
         }

         var cache = ProcessTemplateCache.GetCurrent();
         if (cache.Count() > 0 && cache.All(s => string.Compare(arguments.ToString(), s, true) != 0))
         {
            throw new ValidationMetadataException($"'{arguments}' is invalid");
         }
      }
   }
}
