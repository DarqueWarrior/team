﻿using System.Collections.Generic;
using System.Management.Automation;

namespace vsteam_lib
{
   /// <summary>
   /// Cache project names to reduce the number of
   /// rest APIs calls needed for parameter completion / validation 
   /// </summary>
   public static class ProjectCache
   {
      public static void Invalidate() => Cache.Invalidate();
      internal static bool HasCacheExpired => Cache.HasCacheExpired;
      public static void Update(IEnumerable<string> list) => Cache.Update(list);
      internal static InternalCache Cache { get; } = new InternalCache("Get-VSTeamProject", "Name", false);

      /// <summary>
      /// There are times we need to force an update of the cache
      /// even if it has not expired yet. This will be true when we
      /// add a new project.
      /// </summary>
      /// <param name="forceUpdate"></param>
      /// <returns></returns>
      public static IEnumerable<string> GetCurrent(bool forceUpdate)
      {
         if (HasCacheExpired || forceUpdate)
         {
            try
            {
               Update(null);
            }
            catch (PSInvalidOperationException ex)
            {
               System.Diagnostics.Debug.WriteLine(ex.Message);
            }
         }

         return Cache.Values;
      }
   }
}
