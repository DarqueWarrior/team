using System.Collections.Generic;
using System.Linq;
using System.Text.RegularExpressions;

namespace vsteam_lib
{
   public static class FieldCache
   {
      internal static InternalCache Cache { get; } = new InternalCache("Get-VSTeamField", "referenceName", true);

      internal static bool HasCacheExpired => Cache.HasCacheExpired;
      internal static Dictionary<string, string> ShortNames { get; } = new Dictionary<string, string>();
      internal static Dictionary<string, string> RefNames { get; } = new Dictionary<string, string>();
      public static void Invalidate() {
         Cache.Invalidate();
         RefNames.Clear();
         ShortNames.Clear();
      }
      public static void Update(IEnumerable<string> list)
      {
         RefNames.Clear();
         ShortNames.Clear();
         // If a list is passed in use it. If not call Get-VSTeamField
         if (null == list)
         {
            // this to test we are logged on, unit tests can set the value
            if (!string.IsNullOrEmpty(Versions.Account))
            {
               Cache.Shell.Commands.Clear();

               var fields = Cache.Shell.AddCommand("Get-VSTeamField")
                                        .Invoke();

               // Setup RefNames so we can do a case insensitive Lookup of a short name to the reference name.
               Regex afterLastDot = new Regex(@"^.*\.(.+)$");
               foreach (var field in fields)
               {
                  string fieldreferenceName = field.Properties["referenceName"].Value.ToString();
                  string fieldDisplayName = field.Properties["Name"].Value.ToString().ToLower();
                  string fieldShortname = afterLastDot.Replace(fieldreferenceName,"$1").ToLower();
                  RefNames.Add(fieldreferenceName.ToLower(), fieldreferenceName);
                  ShortNames.Add(fieldShortname, fieldreferenceName);
                  if (fieldDisplayName != fieldShortname)
                  {
                     ShortNames.Add(fieldDisplayName, fieldreferenceName);
                  }
               }

               // This will return just the names
               list = Cache.Shell.AddCommand("Select-Object")
                                 .AddParameter("ExpandProperty", "referenceName")
                                 .AddCommand("Sort-Object")
                                 .Invoke<string>(fields);
            }
         }
         Cache.PreFill(list);
         Cache.MinutesToExpire = 60;
      }

      /// <summary>
      /// There are times we need to force an update of the cache
      /// even if it has not expired yet.
      /// </summary>
      /// <param name="forceUpdate"></param>
      /// <returns></returns>
      public static IEnumerable<string> GetCurrent(bool forceUpdate)
      {
         if (HasCacheExpired || forceUpdate)
         {
            Update(null);
         }

         return Cache.Values;
      }

      public static string GetRefName(string name)
      {
         if (RefNames.Count == 0)
         {
            Update(null);
         }
         if (ShortNames.Keys.Contains(name.ToLower()))
         {
            name = ShortNames[name.ToLower()];
         }
         if (RefNames.Keys.Contains(name.ToLower()))
         {
            name = RefNames[name.ToLower()];
         }

         return name;

      }
   }
}
