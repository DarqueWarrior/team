using System.Drawing;
using System.Management.Automation;
using System.Text.RegularExpressions;

namespace vsteam_lib
{
   public sealed class ColorTransformToHexAttribute : ArgumentTransformationAttribute
   {
      public override object Transform(EngineIntrinsics engineIntrinsics, object InputData)
      {
         try
         {
            if (InputData is string s)
            {
               var sixHexDigits = new Regex(@"^#?([\da-f]{6})$", RegexOptions.IgnoreCase);

               if (sixHexDigits.Match(s).Success)
               {
                  InputData = sixHexDigits.Replace(s, "$1");
               }
               else
               {
                  InputData = Color.FromName(s);
               }
            }

            if (InputData is Color c)
            {
               InputData = (string.Format("{0:x2}{1:x2}{2:x2}", c.R, c.G, c.B));
            }
         }
         catch
         {
            throw new ParameterBindingException((InputData as string) + " could not be transformed into a color.");
         }

         return (InputData);
      }
   }
}
