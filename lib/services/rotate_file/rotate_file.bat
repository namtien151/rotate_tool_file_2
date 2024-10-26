@echo off
powershell -WindowStyle Hidden -Command "Start-Process '${Directory.current.path}\\lib\\services\\rotate_file\\rotate_file.exe'-NoNewWindow"
exit
