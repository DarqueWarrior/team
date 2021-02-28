using System.Collections.Generic;
using System.Linq;
using System.Management.Automation;
using System.Xml.Serialization;
using vsteam_lib.Provider;

namespace vsteam_lib
{
   public class Process : Leaf
   {
      public string TypeId { get; set; }
      public string Description { get; set; }
      public string ReferenceName { get; set; }
      public bool IsEnabled { get; set; }
      public bool IsDefault { get; set; }
      [XmlAttribute("customizationType")]
      public string Type { get; set; }
      public string ProcessTemplate => this.Name;
      public string ParentProcessTypeId { get; set; }
      public IEnumerable<string> Projects { get; }

      public Process(PSObject obj) :
         base(obj, obj.GetValue("name"), obj.GetValue("id"), null)
      {
         this.Projects = obj.GetValue<object[]>("Projects")?.Select(o => o.ToString()).ToArray();

         // Depending on what API was used you might get and ID or a TypeId back.
         // If you get a TypeId you need to set the ID now
         if (string.IsNullOrEmpty(this.Id))
         {
            this.Id = this.TypeId;
         }
      }

      public override string ToString() => this.Name;
   }
}
