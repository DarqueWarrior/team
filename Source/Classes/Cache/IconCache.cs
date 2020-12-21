using System.Collections.Generic;

namespace vsteam_lib
{
   /// <summary>
   /// Cache Icons for work items to reduce the number of
   /// rest APIs calls needed for parameter completion / validation
   /// </summary>
   public static class IconCache
   {
      public static void Invalidate() => Cache.Invalidate();
      internal static bool HasCacheExpired => Cache.HasCacheExpired;
      internal static InternalCache Cache { get; } = new InternalCache("Get-VSTeamWorkItemIconList", "ID", false);
      public static void Update(IEnumerable<string> list, int minutesToExpire = 480) => Cache.Update(list, minutesToExpire);

      public static IEnumerable<string> GetCurrent()
      {
         if (HasCacheExpired)
         {
            Update(null);
         }

         return Cache.Values;
      }
   }
}
