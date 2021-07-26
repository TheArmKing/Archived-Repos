@ECHO OFF

mkdir C:\Users\%username%\Desktop\Aut0Imp4ct

:email
SET /P emel=Email:
if "%emel%" == "" (
   echo EMAIL CANNOT BE EMPTY!
   goto :email
)

:pass
SET /P pess=Pass:
if "%pess%" == "" (
   echo PASSWORD CANNOT BE EMPTY!
   goto :pass
)
SET /P pes=Re-Enter:
if not "%pess%" == "%pes%" (
   echo PASSWORDS DONT MATCH!
   goto :pass
)

echo Set WshShell = WScript.CreateObject("WScript.Shell")>>"C:\Users\%username%\Desktop\Aut0Imp4ct\script.vbs"
echo.>>"C:\Users\%username%\Desktop\Aut0Imp4ct\script.vbs"
echo WshShell.AppActivate "Impactor">>"C:\Users\%username%\Desktop\Aut0Imp4ct\script.vbs"
echo.>>"C:\Users\%username%\Desktop\Aut0Imp4ct\script.vbs"
echo WshShell.SendKeys "{TAB}">>"C:\Users\%username%\Desktop\Aut0Imp4ct\script.vbs"
echo WshShell.SendKeys "%emel%">>"C:\Users\%username%\Desktop\Aut0Imp4ct\script.vbs"
echo WshShell.SendKeys "{ENTER}">>"C:\Users\%username%\Desktop\Aut0Imp4ct\script.vbs"
echo WshShell.SendKeys "%pess%">>"C:\Users\%username%\Desktop\Aut0Imp4ct\script.vbs"
echo WshShell.SendKeys "{ENTER}">>"C:\Users\%username%\Desktop\Aut0Imp4ct\script.vbs"
echo.>>"C:\Users\%username%\Desktop\Aut0Imp4ct\script.vbs"
echo WshShell.AppActivate "Command Prompt">>"C:\Users\%username%\Desktop\Aut0Imp4ct\script.vbs"

copy C:\Users\%username%\Desktop\Aut0Imp4ct\script.vbs C:\Users\%username%\
ren C:\Users\%username%\script.vbs autoimpact.vbs
rmdir /Q /S C:\Users\%username%\Desktop\Aut0Imp4ct\

echo @ECHO OFF>>"C:\Users\%username%\cbz.txt"
echo SETLOCAL EnableExtensions>>"C:\Users\%username%\cbz.txt"
echo FOR /F %%%%x IN ('tasklist /NH /FI "IMAGENAME eq Impactor.exe"') DO IF %%%%x == Impactor.exe goto FOUND>>"C:\Users\%username%\cbz.txt"
echo echo Impactor Not running>>"C:\Users\%username%\cbz.txt"
echo goto FIN>>"C:\Users\%username%\cbz.txt"
echo :FOUND>>"C:\Users\%username%\cbz.txt"
echo cscript C:\Users\%username%\autoimpact.vbs>>"C:\Users\%username%\cbz.txt"
echo echo Impacted!>>"C:\Users\%username%\cbz.txt"
echo :FIN>>"C:\Users\%username%\cbz.txt"

ren C:\Users\%username%\cbz.txt Impact.bat

SET kl=install.bat
del %~dp0%kl%
echo Cuz its deleted ;)
