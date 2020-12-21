# These lines were repeated in every test so I moved them here

[CmdletBinding()]
param(
   [Parameter(Mandatory = $true, Position = 0)]
   [string] $testPath,
   [switch] $private,
   [switch] $doNotPrimeCache
)
Import-Module SHiPS

$baseFolder = "$PSScriptRoot/../../.."
$sampleFiles = "$PSScriptRoot/../../SampleFiles"

Add-Type -Path "$baseFolder/dist/bin/vsteam-lib.dll"

$sut = (Split-Path -Leaf $testPath).Replace(".Tests.", ".")

. "$baseFolder/Source/Private/common.ps1"
. "$baseFolder/Source/Private/applyTypes.ps1"

if ($private.IsPresent) {
   . "$baseFolder/Source/Private/$sut"
}
else {
   . "$baseFolder/Source/Public/$sut"
}

if ($doNotPrimeCache.IsPresent) {
   return
}

# Prime the project cache with an empty list. This will make sure
# any project name used will pass validation and Get-VSTeamProject
# will not need to be called.
[vsteam_lib.ProjectCache]::Update([string[]]@(), 120)

function Open-SampleFile {
   param(
      [Parameter(Mandatory = $true, Position = 0)]
      [string] $file,
      [switch] $ReturnValue,
      # The index of the value array to return
      [int] $index = -1,
      [switch] $Json
   )
   if ($Json.IsPresent) {
      return $(Get-Content "$sampleFiles\$file" -Raw ) #had convertTo-json but this files are json text, caused warning with PS 7.1
   }

   if ($ReturnValue.IsPresent) {
      return $(Get-Content "$sampleFiles\$file" -Raw | ConvertFrom-Json).value
   }
   else {
      if ($index -eq -1) {
         return $(Get-Content "$sampleFiles\$file" -Raw | ConvertFrom-Json)
      }
      else {
         return $(Get-Content "$sampleFiles\$file" -Raw | ConvertFrom-Json).value[$index]
      }
   }
}

function _trackProcess {
   if ($iTracking -gt 9) {
      return [PSCustomObject]@{
         isReady         = $true
         operationStatus = [PSCustomObject]@{ state = 'Ready' }
      }
   }

   return [PSCustomObject]@{
      isReady         = $false
      createdBy       = [PSCustomObject]@{ }
      authorization   = [PSCustomObject]@{ }
      data            = [PSCustomObject]@{ }
      operationStatus = [PSCustomObject]@{ state = 'InProgress' }
   }
}