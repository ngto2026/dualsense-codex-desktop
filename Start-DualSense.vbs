Option Explicit
Dim shell, files, folder, launcher
Set shell = CreateObject("WScript.Shell")
Set files = CreateObject("Scripting.FileSystemObject")
folder = files.GetParentFolderName(WScript.ScriptFullName)
launcher = files.BuildPath(folder, "Start-DualSenseBackground.ps1")
shell.Run "powershell.exe -NoProfile -WindowStyle Hidden -ExecutionPolicy Bypass -File """ & launcher & """", 0, False
