@echo off
Mode 85,10
setlocal enableDelayedExpansion
Title Rename PC with WMIC
If [%1] NEQ [Admin] Goto RunAsAdmin
Set "TmpFile=%AppData%\%~n0.txt"
Set "File_Old_PC_Name=%~dp0Old_PC_Name.BAK"
If Not Exist "%TmpFile%" (
    echo "%ComputerName%">"%TmpFile%"
) Else (
    echo "%ComputerName%">>"%TmpFile%"
)
Call :RemoveDuplicateEntry "%TmpFile%" "%File_Old_PC_Name%"
:menuLOOP
Mode 85,10
Title Rename PC with WMIC
Cls & color 0B
echo(
echo(         ================================Menu================================
echo(
@for /f "tokens=2* delims=_ " %%A in ('"findstr /b /c:":menu_" "%~f0""') do (
    echo                            %%A  %%B
)
echo(
echo(         ====================================================================
set choice=
echo( & set /p choice=Make a choice or hit ENTER to quit: || GOTO :EOF
echo( & call :menu_[%choice%]
GOTO:menuLOOP
::----------------------------------------------------------------------------------------------------------
:menu_[1] Rename Computer Name
cls & Mode 120,10
echo(
echo( Please Type a New Name for this PC :
set /P "NewName="
(
    echo    Answ = MsgBox("Are you sur to rename your computer as ""%NewName%"" ?"_
    echo   ,VbYesNo+VbQuestion,"%NewName% ?"^)
    echo    If Answ = VbYes then 
    echo        wscript.Quit(0^)
    echo    Else
    echo        wscript.Quit(1^)
    echo    End If
)>"%tmp%\%~n0_.vbs"
Cscript /nologo "%tmp%\%~n0_.vbs"
If ["!errorlevel!"] EQU ["0"] (
    Call :RenamePC "%NewName%" && Call :Ask4Reboot
) Else (
    Goto :menu_[1]
)
Exit /B
::----------------------------------------------------------------------------------------------------------
:menu_[2] Restore Old Computer Name
cls
set /a Cnt=0
    @for /f "delims=" %%a in ('Type "%File_Old_PC_Name%"') do ( 
        set /a Cnt+=1
        Set OLD!Cnt!=%%a
    )
echo(
@for /l %%N in (1 1 %Cnt%) do echo %%N - !OLD%%N!
echo(
:get selection
set selection=
set /p "selection=Enter Old Computer Name number: "
echo you picked %selection% - !OLD%selection%!
Call :RenamePC !OLD%selection%! && Call :Ask4Reboot
Exit /B
::----------------------------------------------------------------------------------------------------------
:RenamePC
WMIC ComputerSystem where Name="%ComputerName%" call Rename Name="%~1"
Exit /B
::----------------------------------------------------------------------------------------------------------
:Ask4Reboot
(
    echo    Set Ws = CreateObject("wscript.shell"^)
    echo    Answ = MsgBox("Did you want to reboot your computer ?"_
    echo ,VbYesNo+VbQuestion,"Did you want to reboot your computer ?"^)
    echo    If Answ = VbYes then 
    echo        Return = Ws.Run("cmd /c shutdown -r -t 10 -c ""You need to reboot in 10 seconds."" -f",0,True^)
    echo    Else
    echo        wscript.Quit(1^)
    echo    End If
)>"%tmp%\%~n0.vbs"
Start "" "%tmp%\%~n0.vbs"
Exit /B
::-----------------------------------------------------------------------------------------------------------
:RunAsAdmin
cls & color 0E & Mode 90,5
echo( 
echo(            ==========================================================
echo(                  Please wait a while ... Running as Admin ....
echo(            ==========================================================
Powershell start -verb runas '%0' Admin & Exit
::-----------------------------------------------------------------------------------------------------------
:RemoveDuplicateEntry <InputFile> <OutPutFile>
Powershell  ^
$Contents=Get-Content '%1';  ^
$LowerContents=$Contents.ToUpper(^);  ^
$LowerContents ^| select -unique ^| Out-File '%2'
Exit /b
::-----------------------------------------------------------------------------------------------------------
