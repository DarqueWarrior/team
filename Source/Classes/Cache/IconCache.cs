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
      public static void Update(IEnumerable<string> list, int minutesToExpire = 240) => Cache.Update(list, minutesToExpire);

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
   }
}
