@ECHO OFF
SETLOCAL ENABLEDELAYEDEXPANSION
REM ===================================================================
REM Windows Setup Helper - Build Configuration UI
REM Uses Button tool to provide a simple UI for configuring Build.bat
REM ===================================================================

CD /D "%~dp0"
SET "BUILDTOOLS=%~dp0BuildTools"
PATH=%BUILDTOOLS%;%PATH%

REM Load current settings from Build.bat or use defaults
CALL :LoadSettings

REM Main Menu Loop
:MainMenu
CLS
ECHO.
ECHO ============================================================
ECHO   Windows Setup Helper - Build Configuration
ECHO ============================================================
ECHO.
ECHO  Current Settings:
ECHO  ----------------
ECHO  [1] Source ISO:      !SOURCEISO!
ECHO  [2] Media Path:      !MEDIAPATH!
ECHO  [3] Output ISO:      !OUTPUTISO!
ECHO  [4] Extra Files:     !EXTRAFILES!
ECHO.
ECHO  Build Steps:
ECHO  ------------
ECHO  [5] Extract ISO:     !AUTO_EXTRACTISO!
ECHO  [6] Mount WIM:       !AUTO_MOUNTWIM!
ECHO  [7] Copy Files:      !AUTO_COPYFILES!
ECHO  [8] Add Packages:    !AUTO_ADDPACKAGES!
ECHO  [9] Disable DPI:     !AUTO_DISABLEDPI!
ECHO  [A] Unmount/Commit:  !AUTO_UNMOUNTCOMMIT!
ECHO  [B] Trim Images:     !AUTO_TRIMIMAGES!
ECHO  [C] Make ISO:        !AUTO_MAKEISO!
ECHO.
ECHO  ============================================================
ECHO  [S] Save Settings    [R] Run Build    [Q] Quit
ECHO  ============================================================
ECHO.

CHOICE /C 123456789ABCSRQ /N /M "Select option: "
SET CHOICE=%ERRORLEVEL%

IF %CHOICE%==1 CALL :EditSourceISO
IF %CHOICE%==2 CALL :EditMediaPath
IF %CHOICE%==3 CALL :EditOutputISO
IF %CHOICE%==4 CALL :EditExtraFiles
IF %CHOICE%==5 CALL :ToggleExtractISO
IF %CHOICE%==6 CALL :ToggleMountWIM
IF %CHOICE%==7 CALL :ToggleCopyFiles
IF %CHOICE%==8 CALL :ToggleAddPackages
IF %CHOICE%==9 CALL :ToggleDisableDPI
IF %CHOICE%==10 CALL :ToggleUnmountCommit
IF %CHOICE%==11 CALL :ToggleTrimImages
IF %CHOICE%==12 CALL :ToggleMakeISO
IF %CHOICE%==13 CALL :SaveSettings
IF %CHOICE%==14 CALL :RunBuild
IF %CHOICE%==15 EXIT /B

GOTO MainMenu

REM ===================================================================
REM Edit Functions
REM ===================================================================

:EditSourceISO
ECHO.
SET /P "NEWVALUE=Enter Source ISO path (or press Enter to keep current): "
IF NOT "!NEWVALUE!"=="" SET "SOURCEISO=!NEWVALUE!"
GOTO :EOF

:EditMediaPath
ECHO.
SET /P "NEWVALUE=Enter Media extraction path (or press Enter to keep current): "
IF NOT "!NEWVALUE!"=="" SET "MEDIAPATH=!NEWVALUE!"
GOTO :EOF

:EditOutputISO
ECHO.
SET /P "NEWVALUE=Enter Output ISO path (or press Enter to keep current): "
IF NOT "!NEWVALUE!"=="" SET "OUTPUTISO=!NEWVALUE!"
GOTO :EOF

:EditExtraFiles
ECHO.
SET /P "NEWVALUE=Enter Extra Files path (or press Enter to keep current): "
IF NOT "!NEWVALUE!"=="" SET "EXTRAFILES=!NEWVALUE!"
GOTO :EOF

REM ===================================================================
REM Toggle Functions
REM ===================================================================

:ToggleExtractISO
IF "!AUTO_EXTRACTISO!"=="[X]" (SET "AUTO_EXTRACTISO=[ ]") ELSE (SET "AUTO_EXTRACTISO=[X]")
GOTO :EOF

:ToggleMountWIM
IF "!AUTO_MOUNTWIM!"=="[X]" (SET "AUTO_MOUNTWIM=[ ]") ELSE (SET "AUTO_MOUNTWIM=[X]")
GOTO :EOF

:ToggleCopyFiles
IF "!AUTO_COPYFILES!"=="[X]" (SET "AUTO_COPYFILES=[ ]") ELSE (SET "AUTO_COPYFILES=[X]")
GOTO :EOF

:ToggleAddPackages
IF "!AUTO_ADDPACKAGES!"=="[X]" (SET "AUTO_ADDPACKAGES=[ ]") ELSE (SET "AUTO_ADDPACKAGES=[X]")
GOTO :EOF

:ToggleDisableDPI
IF "!AUTO_DISABLEDPI!"=="[X]" (SET "AUTO_DISABLEDPI=[ ]") ELSE (SET "AUTO_DISABLEDPI=[X]")
GOTO :EOF

:ToggleUnmountCommit
IF "!AUTO_UNMOUNTCOMMIT!"=="[X]" (SET "AUTO_UNMOUNTCOMMIT=[ ]") ELSE (SET "AUTO_UNMOUNTCOMMIT=[X]")
GOTO :EOF

:ToggleTrimImages
IF "!AUTO_TRIMIMAGES!"=="[X]" (SET "AUTO_TRIMIMAGES=[ ]") ELSE (SET "AUTO_TRIMIMAGES=[X]")
GOTO :EOF

:ToggleMakeISO
IF "!AUTO_MAKEISO!"=="[X]" (SET "AUTO_MAKEISO=[ ]") ELSE (SET "AUTO_MAKEISO=[X]")
GOTO :EOF

REM ===================================================================
REM Load Settings from Build.bat
REM ===================================================================

:LoadSettings
SET "SOURCEISO=E:\Windows Images\Windows 11 25H2 MCT 2510.iso"
SET "MEDIAPATH=E:\Windows Images\11"
SET "OUTPUTISO=E:\Windows Images\Windows11.iso"
SET "EXTRAFILES=E:\Windows Images\Additions"
SET "AUTO_EXTRACTISO=[X]"
SET "AUTO_MOUNTWIM=[X]"
SET "AUTO_COPYFILES=[X]"
SET "AUTO_ADDPACKAGES=[X]"
SET "AUTO_DISABLEDPI=[X]"
SET "AUTO_UNMOUNTCOMMIT=[X]"
SET "AUTO_TRIMIMAGES=[X]"
SET "AUTO_MAKEISO=[X]"

REM Try to read from Build.bat if it exists
IF EXIST "Build.bat" (
    FOR /F "tokens=1,* delims==" %%A IN ('FINDSTR /B "set sourceiso=" Build.bat') DO SET "SOURCEISO=%%B"
    FOR /F "tokens=1,* delims==" %%A IN ('FINDSTR /B "set mediapath=" Build.bat') DO SET "MEDIAPATH=%%B"
    FOR /F "tokens=1,* delims==" %%A IN ('FINDSTR /B "set outputiso=" Build.bat') DO SET "OUTPUTISO=%%B"
    FOR /F "tokens=1,* delims==" %%A IN ('FINDSTR /B "set extrafiles=" Build.bat') DO SET "EXTRAFILES=%%B"

    REM Read toggle settings
    FOR /F "tokens=1,* delims==" %%A IN ('FINDSTR /B "set \"auto_extractiso=" Build.bat') DO (
        SET "TEMP=%%B"
        IF "!TEMP:~0,1!"=="*" (SET "AUTO_EXTRACTISO=[X]") ELSE (SET "AUTO_EXTRACTISO=[ ]")
    )
    FOR /F "tokens=1,* delims==" %%A IN ('FINDSTR /B "set \"auto_mountwim=" Build.bat') DO (
        SET "TEMP=%%B"
        IF "!TEMP:~0,1!"=="*" (SET "AUTO_MOUNTWIM=[X]") ELSE (SET "AUTO_MOUNTWIM=[ ]")
    )
    FOR /F "tokens=1,* delims==" %%A IN ('FINDSTR /B "set \"auto_copyfiles=" Build.bat') DO (
        SET "TEMP=%%B"
        IF "!TEMP:~0,1!"=="*" (SET "AUTO_COPYFILES=[X]") ELSE (SET "AUTO_COPYFILES=[ ]")
    )
    FOR /F "tokens=1,* delims==" %%A IN ('FINDSTR /B "set \"auto_addpackages=" Build.bat') DO (
        SET "TEMP=%%B"
        IF "!TEMP:~0,1!"=="*" (SET "AUTO_ADDPACKAGES=[X]") ELSE (SET "AUTO_ADDPACKAGES=[ ]")
    )
    FOR /F "tokens=1,* delims==" %%A IN ('FINDSTR /B "set \"auto_disabledpi=" Build.bat') DO (
        SET "TEMP=%%B"
        IF "!TEMP:~0,1!"=="*" (SET "AUTO_DISABLEDPI=[X]") ELSE (SET "AUTO_DISABLEDPI=[ ]")
    )
    FOR /F "tokens=1,* delims==" %%A IN ('FINDSTR /B "set \"auto_unmountcommit=" Build.bat') DO (
        SET "TEMP=%%B"
        IF "!TEMP:~0,1!"=="*" (SET "AUTO_UNMOUNTCOMMIT=[X]") ELSE (SET "AUTO_UNMOUNTCOMMIT=[ ]")
    )
    FOR /F "tokens=1,* delims==" %%A IN ('FINDSTR /B "set \"auto_trimimages=" Build.bat') DO (
        SET "TEMP=%%B"
        IF "!TEMP:~0,1!"=="*" (SET "AUTO_TRIMIMAGES=[X]") ELSE (SET "AUTO_TRIMIMAGES=[ ]")
    )
    FOR /F "tokens=1,* delims==" %%A IN ('FINDSTR /B "set \"auto_makeiso=" Build.bat') DO (
        SET "TEMP=%%B"
        IF "!TEMP:~0,1!"=="*" (SET "AUTO_MAKEISO=[X]") ELSE (SET "AUTO_MAKEISO=[ ]")
    )
)
GOTO :EOF

REM ===================================================================
REM Save Settings to Build.bat
REM ===================================================================

:SaveSettings
ECHO.
ECHO Saving settings to Build.bat...

REM Create backup
IF EXIST "Build.bat" COPY /Y "Build.bat" "Build.bat.bak" >NUL

REM Create temporary file with new settings
(
    ECHO @ECHO OFF
    ECHO REM == Settings You Need To Change =================================
    ECHO REM Path of the ISO file to extract
    ECHO set sourceiso=!SOURCEISO!
    ECHO.
    ECHO REM Directory to extract the ISO to ^(no trailing slash^)
    ECHO set mediapath=!MEDIAPATH!
    ECHO.
    ECHO REM ^(Optional^) Directory of extra files to add to the image ^(no trailing slash^)
    ECHO set extrafiles=!EXTRAFILES!
    ECHO.
    ECHO REM Path to the new ISO file
    ECHO set outputiso=!OUTPUTISO!
    ECHO.
    ECHO.
    ECHO REM == Other Settings ==============================================
    ECHO REM The index of the boot.wim image you want to modify eg: "/Index:2" or "/Name:name"
    ECHO set wimindex=/Name:"Microsoft Windows Setup ^(amd64^)"
    ECHO set helperrepo=%%~dp0
    ECHO set sourcewim=%%mediapath%%\sources\boot.wim
    ECHO set mountpath=%%temp%%\WIMMount
    ECHO set adk=%%ProgramFiles^(x86^)%%\Windows Kits\10\Assessment and Deployment Kit
    ECHO.
    ECHO REM == Defaults for toggle options ==================================
) > "Build.bat.tmp"

REM Convert checkboxes back to asterisks
IF "!AUTO_EXTRACTISO!"=="[X]" (
    ECHO set "auto_extractiso=*" >> "Build.bat.tmp"
) ELSE (
    ECHO set "auto_extractiso= " >> "Build.bat.tmp"
)
IF "!AUTO_MOUNTWIM!"=="[X]" (
    ECHO set "auto_mountwim=*" >> "Build.bat.tmp"
) ELSE (
    ECHO set "auto_mountwim= " >> "Build.bat.tmp"
)
IF "!AUTO_COPYFILES!"=="[X]" (
    ECHO set "auto_copyfiles=*" >> "Build.bat.tmp"
) ELSE (
    ECHO set "auto_copyfiles= " >> "Build.bat.tmp"
)
IF "!AUTO_ADDPACKAGES!"=="[X]" (
    ECHO set "auto_addpackages=*" >> "Build.bat.tmp"
) ELSE (
    ECHO set "auto_addpackages= " >> "Build.bat.tmp"
)
IF "!AUTO_DISABLEDPI!"=="[X]" (
    ECHO set "auto_disabledpi=*" >> "Build.bat.tmp"
) ELSE (
    ECHO set "auto_disabledpi= " >> "Build.bat.tmp"
)
IF "!AUTO_UNMOUNTCOMMIT!"=="[X]" (
    ECHO set "auto_unmountcommit=*" >> "Build.bat.tmp"
) ELSE (
    ECHO set "auto_unmountcommit= " >> "Build.bat.tmp"
)

REM Add remaining default settings
(
    ECHO set "auto_setresolution= "
    ECHO set "auto_setresolution_detail=1024x768"
) >> "Build.bat.tmp"

IF "!AUTO_TRIMIMAGES!"=="[X]" (
    ECHO set "auto_trimimages=*" >> "Build.bat.tmp"
) ELSE (
    ECHO set "auto_trimimages= " >> "Build.bat.tmp"
)
ECHO set "auto_removeinstaller= " >> "Build.bat.tmp"

IF "!AUTO_MAKEISO!"=="[X]" (
    ECHO set "auto_makeiso=*" >> "Build.bat.tmp"
) ELSE (
    ECHO set "auto_makeiso= " >> "Build.bat.tmp"
)

REM Append the rest of Build.bat after line 38
FOR /F "skip=38 delims=" %%A IN (Build.bat.bak) DO (
    ECHO %%A >> "Build.bat.tmp"
)

REM Replace Build.bat with new version
MOVE /Y "Build.bat.tmp" "Build.bat" >NUL

ECHO Settings saved successfully!
TIMEOUT /T 2 >NUL
GOTO :EOF

REM ===================================================================
REM Run Build.bat with current settings
REM ===================================================================

:RunBuild
CALL :SaveSettings
CLS
ECHO.
ECHO Starting Build.bat with configured settings...
ECHO.
CALL Build.bat
PAUSE
GOTO :EOF
