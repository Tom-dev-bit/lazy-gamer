Set objShell = CreateObject("Shell.Application")
Set objFSO = CreateObject("Scripting.FileSystemObject")
scriptDir = objFSO.GetParentFolderName(WScript.ScriptFullName)
objShell.ShellExecute "powershell.exe", "-ExecutionPolicy Bypass -File """ & scriptDir & "\run.ps1""", "", "runas", 1
