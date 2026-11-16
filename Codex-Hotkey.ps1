$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.Windows.Forms
Add-Type @"
using System;
using System.Runtime.InteropServices;
public static class CodexControllerHotkey {
    [StructLayout(LayoutKind.Sequential)]
    public struct Message {
        public IntPtr hwnd;
        public uint message;
        public UIntPtr wParam;
        public IntPtr lParam;
        public uint time;
        public int x, y;
        public uint privateData;
    }
    [DllImport("user32.dll", SetLastError=true)]
    public static extern bool RegisterHotKey(IntPtr hwnd, int id, uint modifiers, uint key);
    [DllImport("user32.dll")]
    public static extern bool UnregisterHotKey(IntPtr hwnd, int id);
    [DllImport("user32.dll")]
    public static extern int GetMessage(out Message message, IntPtr hwnd, uint min, uint max);
    [DllImport("user32.dll")]
    public static extern IntPtr GetForegroundWindow();
    [DllImport("user32.dll")]
    public static extern bool IsIconic(IntPtr hwnd);
    [DllImport("user32.dll")]
    public static extern bool ShowWindowAsync(IntPtr hwnd, int command);
    [DllImport("user32.dll")]
    public static extern bool SetForegroundWindow(IntPtr hwnd);
}
"@

if (![CodexControllerHotkey]::RegisterHotKey([IntPtr]::Zero, 1, 0x4000, 0x87)) {
    throw 'Could not register F24.'
}

$shell = New-Object -ComObject WScript.Shell
function Get-CodexWindow {
    Get-Process -Name ChatGPT,Codex -ErrorAction SilentlyContinue |
        Where-Object { $_.MainWindowHandle -ne 0 } |
        Select-Object -First 1
}

try {
    Set-Content -LiteralPath (Join-Path $PSScriptRoot 'codex-hotkey.ready') -Value $PID
    $message = New-Object CodexControllerHotkey+Message
    while ([CodexControllerHotkey]::GetMessage([ref]$message, [IntPtr]::Zero, 0, 0) -gt 0) {
        if ($message.message -ne 0x0312) { continue }
        try {
            $window = Get-CodexWindow
            if (!$window) {
                Start-Process -FilePath explorer.exe -ArgumentList 'shell:AppsFolder\OpenAI.Codex_2p2nqsd0c76g0!App'
                for ($attempt = 0; $attempt -lt 40 -and !$window; $attempt++) {
                    Start-Sleep -Milliseconds 250
                    $window = Get-CodexWindow
                }
            }
            if (!$window) { continue }
            $handle = $window.MainWindowHandle
            if ([CodexControllerHotkey]::IsIconic($handle)) {
                [void][CodexControllerHotkey]::ShowWindowAsync($handle, 9)
                for ($attempt = 0; $attempt -lt 20 -and [CodexControllerHotkey]::IsIconic($handle); $attempt++) {
                    Start-Sleep -Milliseconds 50
                }
            }
            [void][CodexControllerHotkey]::SetForegroundWindow($handle)
            if ([CodexControllerHotkey]::GetForegroundWindow() -ne $handle) {
                [void]$shell.AppActivate($window.Id)
                Start-Sleep -Milliseconds 150
            }
            if ([CodexControllerHotkey]::GetForegroundWindow() -ne $handle) { continue }
            [Windows.Forms.SendKeys]::SendWait('%3')
            Start-Sleep -Milliseconds 200
            if ([CodexControllerHotkey]::GetForegroundWindow() -eq $handle) {
                [Windows.Forms.SendKeys]::SendWait('^%1')
            }
        } catch {
            Add-Content -LiteralPath (Join-Path $PSScriptRoot 'codex-hotkey-errors.log') -Value $_.Exception.Message
        }
    }
} finally {
    [void][CodexControllerHotkey]::UnregisterHotKey([IntPtr]::Zero, 1)
}

