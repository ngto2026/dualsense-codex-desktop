$ErrorActionPreference = 'Stop'
$hotkeyScript = Join-Path $PSScriptRoot 'Codex-Hotkey.ps1'
$ready = Join-Path $PSScriptRoot 'codex-hotkey.ready'
$helper = $null
if (Test-Path -LiteralPath $ready) {
    $helperId = (Get-Content -LiteralPath $ready -Raw).Trim()
    if ($helperId -match '^\d+$') {
        $helper = Get-Process -Id ([int]$helperId) -ErrorAction SilentlyContinue | Where-Object ProcessName -eq powershell
    }
}
if (!$helper) {
    Start-Process -FilePath (Join-Path $PSHOME 'powershell.exe') -WindowStyle Hidden -ArgumentList (
        '-NoProfile -WindowStyle Hidden -ExecutionPolicy Bypass -File "' + $hotkeyScript + '"'
    )
}

$mapper = Join-Path $PSScriptRoot 'JoyShockMapper.exe'
$running = Get-Process -Name JoyShockMapper -ErrorAction SilentlyContinue | Where-Object Path -eq $mapper
if (!$running) {
    Start-Process -FilePath $mapper -WorkingDirectory $PSScriptRoot -WindowStyle Hidden
}
