param([string]$UpstreamZip)

$ErrorActionPreference = 'Stop'
$version = 'v0.1.0'
$distribution = Join-Path $PSScriptRoot 'dist'
$work = Join-Path $distribution ([guid]::NewGuid().ToString('N'))
New-Item -ItemType Directory -Path $work -Force | Out-Null
if (!$UpstreamZip) {
    $UpstreamZip = Join-Path $work 'JoyShockMapper_x64.zip'
    Invoke-WebRequest 'https://github.com/Electronicks/JoyShockMapper/releases/download/v3.6.1/JoyShockMapper_x64.zip' -OutFile $UpstreamZip
}
$expected = 'C2D869C90C2D86335F7D51356CFA17590246E598BB02EECAE68303D855C8D9B8'
if ((Get-FileHash -LiteralPath $UpstreamZip -Algorithm SHA256).Hash -ne $expected) {
    throw 'Unexpected JoyShockMapper archive SHA-256.'
}
Expand-Archive -LiteralPath $UpstreamZip -DestinationPath $work
$bundle = Join-Path $work 'JoyShockMapper_SDL2_x64'
$files = @(
    'Codex-Hotkey.ps1', 'GyroAlwaysOn.txt', 'GyroHoldR1.txt', 'OnReset.txt',
    'OnStartup.txt', 'Start-DualSense.cmd', 'Start-DualSense.vbs',
    'Start-DualSenseBackground.ps1', 'GyroConfigs/Development.txt', 'GyroConfigs/Gaming.txt'
)
foreach ($file in $files) {
    Copy-Item -LiteralPath (Join-Path $PSScriptRoot $file) -Destination (Join-Path $bundle $file) -Force
}
Rename-Item -LiteralPath (Join-Path $bundle 'README.md') -NewName 'README-JoyShockMapper.md'
Copy-Item -LiteralPath (Join-Path $PSScriptRoot 'README.md'),(Join-Path $PSScriptRoot 'LICENSE-SDL2.txt') -Destination $bundle
$release = Join-Path $distribution "DualSense-Codex-Desktop-$version-windows-x64.zip"
Compress-Archive -Path (Join-Path $bundle '*') -DestinationPath $release -Force
Get-Item -LiteralPath $release

