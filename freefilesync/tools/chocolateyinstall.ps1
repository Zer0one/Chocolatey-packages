$ErrorActionPreference = 'Stop'
 
$toolsDir   = Split-Path -parent $MyInvocation.MyCommand.Definition

if (-not (Get-ChildItem -Path $toolsDir -Filter '*.exe')) {
   Throw ("$env:ChocolateyPackageName installer executable not found!`n" +
            "`tThis is an embedded package, so the most probable cause is that`n" +
            "`tanti-virus/anti-malware software has incorrectly removed it.`n" +
            "`tGo here for more info: https://www.freefilesync.org/faq.php#virus")
}
$fileLocation = (Get-ChildItem -Path $toolsDir -Filter '*.exe').FullName
$fileProcName = (Get-ChildItem -Path $toolsDir -Filter '*.exe').BaseName

# silent install requires AutoHotKey
$ahkFile = Join-Path $toolsDir 'chocolateyInstall.ahk'
$ahkProc = Start-Process -FilePath AutoHotkey -ArgumentList "$ahkFile" -PassThru
Write-Debug "AutoHotKey start time:`t$($ahkProc.StartTime.ToShortTimeString())"
Write-Debug "Process ID:`t$($ahkProc.Id)"
 
$packageArgs = @{
  packageName  = $env:ChocolateyPackageName
  fileType     = 'EXE'
  file         = $fileLocation
  softwareName = "$env:ChocolateyPackageName*"
  # silentArgs   = '/LANG=english' # Donation Edition Only
}

if (-not (Test-Path -LiteralPath $fileLocation)) {
   if (get-process -id $ahkProc.Id -ErrorAction SilentlyContinue) {
      stop-process -id $ahkProc.Id
   }
   Throw ("$env:ChocolateyPackageName installer executable not found!`n" +
            "`tThis is an embedded package, so the most probable cause is that`n" +
            "`tanti-virus/anti-malware software has incorrectly removed it.`n" +
            "`tGo here for more info: https://www.freefilesync.org/faq.php#virus")
}
 
# #Launch the installar the official way cause an installer error -> Missing needed checksum file in install location (install.dat).
# Install-ChocolateyInstallPackage @packageArgs -UseOnlyPackageSilentArguments
& $fileLocation # Every other method i tried raise cause the error

New-Item "$fileLocation.ignore" -Type file -Force | Out-Null
 
if (get-process -id $ahkProc.Id -ErrorAction SilentlyContinue) {stop-process -id $ahkProc.Id}
 
Write-Host ("If you like FreeFileSync, consider support with a donation at`n" + 
            "`thttps://freefilesync.org/donate.php") -ForegroundColor Cyan