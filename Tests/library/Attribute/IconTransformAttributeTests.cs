using Microsoft.VisualStudio.TestTools.UnitTesting;
using System.Diagnostics.CodeAnalysis;

namespace vsteam_lib.Test.Attribute
{
   [TestClass]
   [ExcludeFromCodeCoverage]
   public class IconTransformAttributeTests
   {
      [TestMethod]
      public void IconTransformAttribute_InputData_Not_A_String()
      {
         // Arrange
         var target = new IconTransformAttribute();

         // Act
         var actual = target.Transform(null, null);

         // Assert
         Assert.IsNull(actual);
      }
   }
}
