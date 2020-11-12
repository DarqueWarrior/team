using System.Diagnostics.CodeAnalysis;

namespace vsteam_lib
{
   public enum APIs
   {
      Build, Release, Core, Git, DistributedTask, DistributedTaskReleased,
      VariableGroups, Tfvc, Packaging, MemberEntitlementManagement,
      ExtensionsManagement, ServiceEndpoints, Graph, TaskGroups, Policy,
      Processes, Version, HierarchyQuery, Pipelines
   }

   public static class Versions
   {
      public static void SetApiVersion(APIs service, string version)
      {
         switch (service)
         {
            case APIs.HierarchyQuery:
               HierarchyQuery = version;
               break;
            case APIs.Build:
               Build = version;
               break;
            case APIs.Release:
               Release = version;
               break;
            case APIs.Core:
               Core = version;
               break;
            case APIs.Git:
               Git = version;
               break;
            case APIs.DistributedTask:
               DistributedTask = version;
               break;
            case APIs.DistributedTaskReleased:
               DistributedTaskReleased = version;
               break;
            case APIs.Pipelines:
               Pipelines = version;
               break;
            case APIs.VariableGroups:
               VariableGroups = version;
               break;
            case APIs.Tfvc:
               Tfvc = version;
               break;
            case APIs.Packaging:
               Packaging = version;
               break;
            case APIs.MemberEntitlementManagement:
               MemberEntitlementManagement = version;
               break;
            case APIs.ExtensionsManagement:
               ExtensionsManagement = version;
               break;
            case APIs.ServiceEndpoints:
               ServiceEndpoints = version;
               break;
            case APIs.Graph:
               Graph = version;
               break;
            case APIs.TaskGroups:
               TaskGroups = version;
               break;
            case APIs.Policy:
               Policy = version;
               break;
            case APIs.Processes:
               Processes = version;
               break;
         }
      }

      public static string GetApiVersion(APIs service)
      {
         switch (service)
         {
            case APIs.HierarchyQuery:
               return HierarchyQuery;
            case APIs.Build:
               return Build;
            case APIs.Release:
               return Release;
            case APIs.Core:
               return Core;
            case APIs.Git:
               return Git;
            case APIs.DistributedTask:
               return DistributedTask;
            case APIs.DistributedTaskReleased:
               return DistributedTaskReleased;
            case APIs.Pipelines:
               return Pipelines;
            case APIs.VariableGroups:
               return VariableGroups;
            case APIs.Tfvc:
               return Tfvc;
            case APIs.Packaging:
               return Packaging;
            case APIs.MemberEntitlementManagement:
               return MemberEntitlementManagement;
            case APIs.ExtensionsManagement:
               return ExtensionsManagement;
            case APIs.ServiceEndpoints:
               return ServiceEndpoints;
            case APIs.Graph:
               return Graph;
            case APIs.TaskGroups:
               return TaskGroups;
            case APIs.Policy:
               return Policy;
            case APIs.Processes:
               return Processes;
            default:
               return Version;
         }
      }

      [ExcludeFromCodeCoverage]
      public static bool TestGraphSupport() => !string.IsNullOrEmpty(Versions.GetApiVersion(APIs.Graph));
      [ExcludeFromCodeCoverage]
      public static string Account { get; set; } = System.Environment.GetEnvironmentVariable("TEAM_ACCT");
      [ExcludeFromCodeCoverage]
      public static string DefaultTimeout { get; set; } = System.Environment.GetEnvironmentVariable("TEAM_TIMEOUT");
      [ExcludeFromCodeCoverage]
      public static string DefaultProcess { get; set; } = System.Environment.GetEnvironmentVariable("TEAM_PROCESS");
      [ExcludeFromCodeCoverage]
      public static string DefaultProject { get; set; } = System.Environment.GetEnvironmentVariable("TEAM_PROJECT");
      [ExcludeFromCodeCoverage]
      public static string Version { get; set; } = System.Environment.GetEnvironmentVariable("TEAM_VERSION") ?? "TFS2017";
      [ExcludeFromCodeCoverage]
      public static string ModuleVersion { get; set; } = null;

      public static string Git { get; set; } = "3.0";
      public static string Core { get; set; } = "3.0";
      public static string Build { get; set; } = "3.0";
      public static string HierarchyQuery { get; set; } = "";
      public static string Release { get; set; } = "3.0-preview";
      public static string DistributedTask { get; set; } = "3.0-preview";
      public static string DistributedTaskReleased { get; set; } = "";
      public static string Pipelines { get; set; } = "";
      public static string VariableGroups { get; set; } = "";
      public static string TaskGroups { get; set; } = "3.0-preview";
      public static string Tfvc { get; set; } = "3.0";
      public static string Packaging { get; set; } = "3.0-preview";
      public static string MemberEntitlementManagement { get; set; } = "";
      public static string ExtensionsManagement { get; set; } = "";
      public static string ServiceEndpoints { get; set; } = "3.0-preview";
      public static string Graph { get; set; } = "";
      public static string Policy { get; set; } = "3.0";
      public static string Processes { get; set; } = "";
   }
}
