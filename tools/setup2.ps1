# Realchemy setup, part 2. Run in a NEW normal (not admin) PowerShell:
#   powershell -ExecutionPolicy Bypass -File C:\Realchemy\tools\setup2.ps1
$Log = "C:\Realchemy\tools\setup2_log.txt"
Start-Transcript -Path $Log -Force | Out-Null
function Step($t) { Write-Host "`n=== $t ===" -ForegroundColor Cyan }
function Refresh-Path { $env:Path = [Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [Environment]::GetEnvironmentVariable("Path","User") }
Refresh-Path

Step "Claude Code CLI"
$c = Get-Command claude -ErrorAction SilentlyContinue
if ($c) { Write-Host "found: $($c.Source)" }
else {
  $local = Join-Path $env:USERPROFILE ".local\bin\claude.exe"
  if (Test-Path $local) {
    Write-Host "claude.exe exists at $local but is not in PATH - adding to user PATH"
    $up = [Environment]::GetEnvironmentVariable("Path","User")
    [Environment]::SetEnvironmentVariable("Path", "$up;$(Split-Path $local)", "User")
  } else {
    Write-Host "Installing Claude Code (official native installer)..."
    irm https://claude.ai/install.ps1 | iex
  }
  $bin = Join-Path $env:USERPROFILE ".local\bin"
  $up = [Environment]::GetEnvironmentVariable("Path","User")
  if ($up -notlike "*$bin*") { [Environment]::SetEnvironmentVariable("Path", "$up;$bin", "User"); Write-Host "Added $bin to user PATH" }
  Refresh-Path
}
claude --version

Step "Register MCP: mobile (mcp-devices)"
claude mcp add --scope user mobile -- cmd /c mcp-devices
claude mcp list

Step "codebase-memory-mcp location check"
where.exe codebase-memory-mcp
foreach ($p in (where.exe codebase-memory-mcp)) { Write-Host "$p ->"; & $p --version }

Stop-Transcript | Out-Null
Write-Host "`nDone." -ForegroundColor Green
