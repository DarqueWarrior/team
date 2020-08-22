﻿using System.Diagnostics.CodeAnalysis;
using System.Management.Automation;
using System.Management.Automation.Abstractions;
using vsteam_lib.Provider;

namespace vsteam_lib
{
   public class GitRepository : Directory
   {
      public long Size { get; set; }
      public string Id { get; set; }
      public string Url { get; set; }
      public string SSHUrl { get; set; }
      public string RemoteUrl { get; set; }
      public string DefaultBranch { get; set; }
      public Project Project { get; }

      public GitRepository(PSObject obj, string projectName, IPowerShell powerShell) :
         base(obj, obj.GetValue("Name"), "GitRef", powerShell, projectName)
      {
         Common.MoveProperties(this, obj);

         if (obj.HasValue("project"))
         {
            this.Project = new Project(obj.GetValue<PSObject>("project"), powerShell);
         }
      }

      [ExcludeFromCodeCoverage]
      public GitRepository(PSObject obj, string projectName) :
         this(obj, projectName, new PowerShellWrapper(RunspaceMode.CurrentRunspace))
      {
      }
   }
}
