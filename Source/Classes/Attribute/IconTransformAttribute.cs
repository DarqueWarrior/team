using System.Diagnostics.CodeAnalysis;
using System.Management.Automation;
using System.Text.RegularExpressions;
using System.Linq;
namespace vsteam_lib
{
   public class IconTransformAttribute : ArgumentTransformationAttribute {
      [ExcludeFromCodeCoverage]
      public override object Transform(EngineIntrinsics engineIntrinsics, object InputData) {
          
            string s = (InputData as string).ToLower();
            if (! string.IsNullOrEmpty(s))
            {
               Regex iconSomething = new Regex(@"^icon_\w+");
               if (!iconSomething.IsMatch(s)) 
               { 
                  s = "icon_" + s;
               }
               var iconList = IconCache.GetCurrent(false);
            
               if (iconList.Count() > 1 && ! iconList.Contains(s) ) 
               {
                  throw (new ValidationMetadataException(s + " is not a valid icon name.") );
               }
               else
               {
                  return s;
               }
            }
            return InputData;
      }
   }
}
