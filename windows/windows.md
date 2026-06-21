# Windows

## Clean WinSxS

```powershell
# Generate a report
dism /Online /Cleanup-image /AnalyzeComponentStore
# Clean up superseded components
dism /Online /Cleanup-image /StartComponentCleanup # started at 72.05, ended at 4.38GB
# Reset the base of superseded components. Windows updates can't be uninstalled afterwards!
dism /Online /Cleanup-Image /StartComponentCleanup /ResetBase # started at 4.38, ended at 4.38GB
# Remove any backup files created during SP install. SP can't be uninstalled afterwards!
dism /Online /Cleanup-Image /SPSuperseded
# 24H2/25H2 BUG
# Delete HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Component Based Servicing\Packages\Microsoft-Windows-SmbDirect-FOD-Package-Wrapper~31bf3856ad364e35~amd64~~10.0.26100.1742
# Delete HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Component Based Servicing\Packages\Microsoft-Windows-SmbDirect-FOD-Package~31bf3856ad364e35~amd64~~10.0.26100.1742
# Reboot and try again
```

## Unsupported hardware

Mount ISO and run `setup.exe` as an Administrator

```powershell
setup.exe /product server
```
