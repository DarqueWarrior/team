using System.Diagnostics.CodeAnalysis;
using System.Management.Automation;
using System.Collections;
using System.Linq;
namespace vsteam_lib
{
   public class FieldTransformAttribute : ArgumentTransformationAttribute {
      [ExcludeFromCodeCoverage]
      public override object Transform(EngineIntrinsics engineIntrinsics, object InputData) {
         if (InputData is string)
         {
            string s = (InputData as string);
            if (! string.IsNullOrEmpty(s) && ! s.Contains("*") && ! s.Contains("?") )
            {
               s = FieldCache.GetRefName(s);
               var fieldList = FieldCache.GetCurrent(false);

               if (fieldList.Count() > 1 && ! fieldList.Contains(s) )
               {
                  throw (new ValidationMetadataException(s + " is not a valid Field name.") );
               }
               else
               {
                  return s;
               }
            }
         }
         else if (InputData is object[])
         {
            ArrayList transformed = new ArrayList();
            IEnumerable enumerable = InputData as IEnumerable;
            foreach (var item in enumerable)
            {
                transformed.Add( Transform(engineIntrinsics,item) );
            }
            return transformed;
         }
         return InputData;
      }
   }
}
