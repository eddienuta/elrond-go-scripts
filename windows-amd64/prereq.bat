cd %userprofile%

:: Install GIT 64bit.
powershell -Command "(New-Object Net.WebClient).DownloadFile('https://github.com/git-for-windows/git/releases/download/v2.23.0.windows.1/Git-2.23.0-64-bit.exe', 'Git-2.23.0-64-bit.exe')"
.\Git-2.23.0-64-bit.exe /SILENT

:: Install GO Lang 1.13 64bit.
powershell -Command "(New-Object Net.WebClient).DownloadFile('https://dl.google.com/go/go1.13.windows-amd64.msi', 'go1.13.windows-amd64.msi')"
msiexec /i go1.13.windows-amd64.msi /quiet /qn

echo
echo The prerequisites have been installed. Please run the node build script now.
echo

timeout 5
del "%userprofile%\Git-2.23.0-64-bit.exe"
del "%userprofile%\go1.13.windows-amd64.msi"
exit