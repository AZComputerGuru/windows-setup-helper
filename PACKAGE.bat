@ECHO OFF
REM ===================================================================
REM Package Windows Setup Helper for Transfer
REM Creates a clean copy of the project without git history
REM ===================================================================

SETLOCAL

SET "PROJECT_NAME=windows-setup-helper"
SET "OUTPUT_DIR=%USERPROFILE%\Desktop\%PROJECT_NAME%-package"
SET "SOURCE_DIR=%~dp0"

ECHO.
ECHO ============================================================
ECHO   Windows Setup Helper - Project Packager
ECHO ============================================================
ECHO.
ECHO This will create a portable package on your Desktop.
ECHO.
ECHO Source: %SOURCE_DIR%
ECHO Output: %OUTPUT_DIR%
ECHO.
PAUSE

REM Create output directory
IF EXIST "%OUTPUT_DIR%" (
    ECHO.
    ECHO WARNING: Output directory already exists!
    ECHO It will be deleted and recreated.
    ECHO.
    CHOICE /C YN /M "Continue"
    IF ERRORLEVEL 2 EXIT /B
    RMDIR /S /Q "%OUTPUT_DIR%"
)

MKDIR "%OUTPUT_DIR%"

ECHO.
ECHO Copying project files...

REM Copy main files
XCOPY /Y "%SOURCE_DIR%Build.bat" "%OUTPUT_DIR%\" >NUL
XCOPY /Y "%SOURCE_DIR%BuildUI.bat" "%OUTPUT_DIR%\" >NUL
XCOPY /Y "%SOURCE_DIR%README.md" "%OUTPUT_DIR%\" >NUL
XCOPY /Y "%SOURCE_DIR%SETUP.md" "%OUTPUT_DIR%\" >NUL
XCOPY /Y "%SOURCE_DIR%LICENSE" "%OUTPUT_DIR%\" >NUL

REM Copy directories
ECHO Copying BuildTools...
XCOPY /E /I /Y /Q "%SOURCE_DIR%BuildTools" "%OUTPUT_DIR%\BuildTools" >NUL

ECHO Copying Helper...
XCOPY /E /I /Y /Q "%SOURCE_DIR%Helper" "%OUTPUT_DIR%\Helper" >NUL

ECHO Copying Windows...
XCOPY /E /I /Y /Q "%SOURCE_DIR%Windows" "%OUTPUT_DIR%\Windows" >NUL

ECHO Copying Extra...
XCOPY /E /I /Y /Q "%SOURCE_DIR%Extra" "%OUTPUT_DIR%\Extra" >NUL

REM Clean up any git files
IF EXIST "%OUTPUT_DIR%\.git" RMDIR /S /Q "%OUTPUT_DIR%\.git"
IF EXIST "%OUTPUT_DIR%\.gitignore" DEL /F /Q "%OUTPUT_DIR%\.gitignore"
IF EXIST "%OUTPUT_DIR%\.gitattributes" DEL /F /Q "%OUTPUT_DIR%\.gitattributes"

REM Create a README for the package
(
ECHO # Windows Setup Helper - Portable Package
ECHO.
ECHO This is a portable package of Windows Setup Helper.
ECHO.
ECHO ## Quick Start
ECHO.
ECHO 1. Copy this entire folder to your new machine
ECHO 2. Read SETUP.md for installation instructions
ECHO 3. Run BuildUI.bat to configure your settings
ECHO.
ECHO ## What's Included
ECHO.
ECHO - Build.bat: Main build script
ECHO - BuildUI.bat: Configuration interface
ECHO - Helper/: All helper scripts and tools
ECHO - BuildTools/: UI framework dependencies
ECHO - Windows/: System fonts and files
ECHO - Extra/: Documentation and examples
ECHO.
ECHO ## Next Steps
ECHO.
ECHO See SETUP.md for detailed installation and usage instructions.
ECHO.
ECHO Project: https://github.com/AZComputerGuru/windows-setup-helper
) > "%OUTPUT_DIR%\PACKAGE-README.txt"

ECHO.
ECHO ============================================================
ECHO   Package Created Successfully!
ECHO ============================================================
ECHO.
ECHO Location: %OUTPUT_DIR%
ECHO.
ECHO Next steps:
ECHO 1. Copy the entire folder to a USB drive or network location
ECHO 2. Transfer to your new machine
ECHO 3. Read SETUP.md for installation instructions
ECHO.
ECHO Opening package location...
START "" "%OUTPUT_DIR%"
ECHO.
PAUSE
