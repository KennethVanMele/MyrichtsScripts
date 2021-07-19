@echo off
echo flushing
ipconfig /flushdns > NUL
ipconfig /registerdns > NUL
ipconfig /release > NUL
pause
echo renewing
ipconfig /renew > NUL
netsh winsock reset > NUL
pause