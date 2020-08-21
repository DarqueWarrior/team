﻿using Microsoft.PowerShell.SHiPS;
using System.Management.Automation;

namespace vsteam_lib.Provider
{
   public class Leaf : SHiPSLeaf, IInternalObject
   {
      public string ID { get; }
      public string ProjectName { get; protected set; }
      public PSObject InternalObject { get; }

      /// <summary>
      /// I want the mode to resemble that of
      /// a normal file system.
      /// d - Directory
      /// a - Archive
      /// r - Read-only
      /// h - Hidden
      /// s - System
      /// l - Reparse point, symlink, etc.
      /// </summary>
      public string DisplayMode { get; } = "------";

      public Leaf(PSObject obj, string name, string id, string projectName) : base(name)
      {
         System.Diagnostics.Debug.Assert(!string.IsNullOrEmpty(name));

         Common.MoveProperties(this, obj);

         this.ID = id;
         this.InternalObject = obj;
         this.ProjectName = projectName;
      }
   }
}
