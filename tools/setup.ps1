# Realchemy dev environment setup (Windows). Run:
#   powershell -ExecutionPolicy Bypass -File C:\Realchemy\tools\setup.ps1
# Installs only from official sources via winget / npm. Log: C:\Realchemy\tools\setup_log.txt
# Safe to run again: already installed items are skipped/updated.

$ErrorActionPreference = "Continue"
$Log = "C:\Realchemy\tools\setup_log.txt"
Start-Transcript -Path $Log -Force | Out-Null

function Step($t) { Write-Host "`n=== $t ===" -ForegroundColor Cyan }
function Refresh-Path {
  $env:Path = [Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [Environment]::GetEnvironmentVariable("Path","User")
}
function WingetInstall($id, $name) {
  Step "Install $name ($id)"
  winget install -e --id $id --accept-package-agreements --accept-source-agreements --silent
  Write-Host "winget exit code: $LASTEXITCODE (non-zero is OK if it says already installed)"
}

Step "Check winget"
if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
  Write-Host "winget not found. Install 'App Installer' from Microsoft Store, then rerun." -ForegroundColor Red
  Stop-Transcript | Out-Null; exit 1
}
winget --version

# 1. Core tools (official winget packages)
WingetInstall "Git.Git"                         "Git"
WingetInstall "OpenJS.NodeJS.LTS"               "Node.js LTS"
WingetInstall "Python.Python.3.12"              "Python 3.12"
WingetInstall "EclipseAdoptium.Temurin.17.JDK"  "JDK 17 (Temurin)"
WingetInstall "astral-sh.uv"                    "uv"
Refresh-Path

# 2. JAVA_HOME (user scope)
Step "JAVA_HOME"
$jdk = Get-ChildItem "C:\Program Files\Eclipse Adoptium" -Directory -Filter "jdk-17*" -ErrorAction SilentlyContinue | Sort-Object Name -Descending | Select-Object -First 1
if ($jdk) {
  [Environment]::SetEnvironmentVariable("JAVA_HOME", $jdk.FullName, "User")
  $env:JAVA_HOME = $jdk.FullName
  Write-Host "JAVA_HOME = $($jdk.FullName)"
} else { Write-Host "JDK 17 folder not found under C:\Program Files\Eclipse Adoptium" -ForegroundColor Yellow }

# 3. Android SDK paths (installed by Android Studio)
Step "Android SDK"
$sdk = Join-Path $env:LOCALAPPDATA "Android\Sdk"
if (Test-Path $sdk) {
  [Environment]::SetEnvironmentVariable("ANDROID_HOME", $sdk, "User")
  $pt = Join-Path $sdk "platform-tools"
  $userPath = [Environment]::GetEnvironmentVariable("Path","User")
  if ($userPath -notlike "*$pt*") { [Environment]::SetEnvironmentVariable("Path", "$userPath;$pt", "User") }
  Refresh-Path
  Write-Host "ANDROID_HOME = $sdk"
  Write-Host "Installed platforms:"; Get-ChildItem (Join-Path $sdk "platforms") -ErrorAction SilentlyContinue | ForEach-Object { "  " + $_.Name }
  Write-Host "Build-tools:"; Get-ChildItem (Join-Path $sdk "build-tools") -ErrorAction SilentlyContinue | ForEach-Object { "  " + $_.Name }
  Write-Host "NDK:"; Get-ChildItem (Join-Path $sdk "ndk") -ErrorAction SilentlyContinue | ForEach-Object { "  " + $_.Name }
  Write-Host "cmdline-tools:"; Get-ChildItem (Join-Path $sdk "cmdline-tools") -ErrorAction SilentlyContinue | ForEach-Object { "  " + $_.Name }
} else { Write-Host "Android SDK not found at $sdk - open Android Studio > SDK Manager first" -ForegroundColor Yellow }

# 4. Python packages
Step "Python: pillow"
py -3.12 -m pip install --upgrade pip pillow

# 5. Node global packages (Android test MCP)
Step "npm: mcp-devices"
npm i -g mcp-devices @mcp-devices/plugin-android
mcp-devices install android
mcp-devices doctor

# 6. Claude Code + MCP
Step "Claude Code"
if (Get-Command claude -ErrorAction SilentlyContinue) {
  claude update
  claude mcp add --scope user mobile -- cmd /c mcp-devices
  claude mcp list
} else { Write-Host "claude CLI not found in PATH" -ForegroundColor Yellow }

# 7. codebase-memory-mcp update
Step "codebase-memory-mcp"
if (Get-Command codebase-memory-mcp -ErrorAction SilentlyContinue) {
  codebase-memory-mcp update
  codebase-memory-mcp config set auto_index true
  codebase-memory-mcp --version
} else { Write-Host "codebase-memory-mcp not in PATH (was installed earlier?)" -ForegroundColor Yellow }

# 8. Version report
Step "VERSION REPORT"
Refresh-Path
foreach ($c in @("git --version","node --version","npm --version","py -3.12 --version","java -version","uv --version","adb version","claude --version")) {
  Write-Host "> $c"; try { Invoke-Expression "$c 2>&1" } catch { Write-Host "  not found" }
}
Write-Host "`nDone. Close this window and open a NEW PowerShell so PATH changes apply." -ForegroundColor Green
Stop-Transcript | Out-Null
