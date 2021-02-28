using System.Linq;
using System.Management.Automation;
using System.Text.RegularExpressions;

namespace vsteam_lib
{
   public sealed class IconTransformAttribute : ArgumentTransformationAttribute
   {
      public override object Transform(EngineIntrinsics engineIntrinsics, object InputData)
      {
         var s = (InputData as string)?.ToLower();

         if (!string.IsNullOrEmpty(s))
         {
            var iconSomething = new Regex(@"^icon_\w+");

            if (!iconSomething.IsMatch(s))
            {
               s = $"icon_{s}";
            }

            var iconList = IconCache.GetCurrent(false);

            if (iconList.Count() > 1 && !iconList.Contains(s))
            {
               throw new ValidationMetadataException($"{s} is not a valid icon name.");
            }

            return s;
         }

         return InputData;
      }
   }
}
