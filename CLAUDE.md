# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**Windows Setup Helper** - A tool for creating customized Windows installation ISOs with a GUI interface that runs in WinPE. This is a forked version with improvements including a configuration UI for easier setup.

**Repository**: https://github.com/AZComputerGuru/windows-setup-helper
**Original**: https://github.com/jmclaren7/windows-setup-helper

## Key Architecture

### Core Components

1. **Build.bat** - Main build script that uses DISM to:
   - Extract Windows ISO
   - Mount boot.wim
   - Copy Helper files into the WIM
   - Add Windows PE packages
   - Create customized bootable ISO
   - Uses toggle-based system with asterisk (`*`) for enabled steps

2. **BuildUI.bat** - NEW: Configuration interface for Build.bat
   - Provides menu-based UI for editing Build.bat settings
   - Reads current settings using `FINDSTR /R /C:"^set variablename="`
   - Parses toggle settings by checking first character: `IF "!_VAL:~0,1!"=="*"`
   - Saves settings back to Build.bat in correct format
   - Does NOT require admin privileges (only for configuration)

3. **Helper/Main.au3** - AutoIt script that runs in WinPE
   - Creates the main Windows Setup Helper GUI
   - Displays tools and scripts in TreeView controls
   - Handles automated Windows installation with autounattend.xml modification
   - **Important**: Variable is `$EditionChoice` (NOT `$EdditionChoice` - this was a typo that was fixed)

4. **Helper/autounattend.xml** - Windows answer file
   - Modified dynamically by Main.au3 during automated install
   - Values are regex-replaced at runtime
   - Contains commented sections for different configurations

### Directory Structure

```
windows-setup-helper/
├── Build.bat              # Main build script (uses DISM)
├── BuildUI.bat            # Configuration UI (NEW - uses BuildTools)
├── BuildTools/            # Button UI framework dependencies
│   ├── Button.bat         # Main UI function
│   ├── Box.bat, Getlen.bat
│   └── batbox.exe, GetInput.exe, quickedit.exe
├── Helper/                # Files copied into boot.wim
│   ├── Main.au3           # AutoIt main script (entry point)
│   ├── Main.bat           # Batch wrapper for Main.au3
│   ├── AutoIt3.exe        # AutoIt runtime
│   ├── autounattend.xml   # Windows answer file template
│   ├── Config.ini         # Access control settings
│   ├── Include/           # AutoIt standard library
│   ├── IncludeExt/        # Custom AutoIt functions
│   ├── Apps/              # WinGet-based app installers
│   ├── Scripts/           # Post-install "Logon" scripts
│   ├── Tools/             # WinPE tools (runs in pre-install)
│   ├── PEAutoRun/         # Scripts run automatically at WinPE boot
│   └── Debug/             # Development/testing tools
├── Windows/               # System files for WinPE
│   ├── Fonts/             # Font files
│   └── System32/
│       └── winpeshl.ini   # WinPE shell configuration
└── Extra/                 # Documentation and assets
```

## Important Build Process Flow

1. **Extract ISO** → `mediapath\` (sources\boot.wim, sources\install.wim, etc.)
2. **Mount WIM** → `boot.wim` mounted to `%temp%\WIMMount`
3. **Copy Files** → `Helper\` and `Windows\` → mounted image
4. **Add Packages** → WinPE packages from ADK (`WinPE-PowerShell`, `WinPE-NetFx`, etc.)
5. **Registry Changes** → Disable DPI scaling in mounted registry
6. **Unmount/Commit** → Save changes back to `boot.wim`
7. **Trim Images** → Export single index to reduce size (optional)
8. **Make ISO** → Use `oscdimg.exe` from ADK to create bootable ISO

## Key Commands for Development

### Testing BuildUI.bat
```batch
# Run configuration UI (no admin needed)
BuildUI.bat

# Test settings parsing
FINDSTR /R /C:"^set sourceiso=" Build.bat
FINDSTR /R /C:"^set \"auto_extractiso=" Build.bat
```

### Building ISO
```batch
# Run as Administrator
Build.bat

# Or through UI
BuildUI.bat
# Press [S] to save, [R] to run
```

### Testing Helper Script
```batch
# In Helper directory
AutoIt3.exe Main.au3
```

## Critical Implementation Details

### BuildUI.bat Settings Parser

**Challenge**: Reading Build.bat settings with special characters
**Solution**: Use precise regex patterns with `^` anchor

```batch
# Path settings (simple)
FOR /F "tokens=1,* delims==" %%A IN ('FINDSTR /R /C:"^set sourceiso=" Build.bat') DO SET "SOURCEISO=%%B"

# Toggle settings (asterisk detection)
FOR /F "tokens=1,* delims==" %%A IN ('FINDSTR /R /C:"^set \"auto_extractiso=" Build.bat') DO SET "_VAL=%%B"
IF "!_VAL:~0,1!"=="*" (SET "AUTO_EXTRACTISO=[X]") ELSE (SET "AUTO_EXTRACTISO=[ ]")
```

**Why this approach:**
- Cannot use IF/ELSE inside FOR loop parentheses (batch syntax error)
- Must extract value first, then check outside the loop
- Use substring `!VAR:~0,1!` to check first character
- Asterisk `*` is special in string replacement, so avoid `!VAR:*=!`

### Main.au3 Key Functions

- `_PopulateScripts()` - Scans folders matching pattern (Tools*, Scripts*, Apps*)
- `_RunFile()` - Executes different file types (.au3, .ps1, .reg, .bat, .exe)
- `_RunTreeView()` - Processes checked items in TreeView
- `_UpdateXMLDependents()` - Parses autounattend.xml settings
- `_StatusBarUpdate()` - Updates status bar with system info (runs every 4 seconds)

### AutoIt Script Execution

The Helper script runs automatically in WinPE via `Windows\System32\winpeshl.ini`:
```ini
[LaunchApps]
%SYSTEMDRIVE%\Helper\Main.bat
```

Which launches:
```batch
%SYSTEMDRIVE%\Helper\AutoIt3.exe /AutoIt3ExecuteScript %SYSTEMDRIVE%\Helper\Main.au3
```

## Recent Changes (This Fork)

### Changes Made
1. **Added BuildUI.bat** - Configuration interface using Button framework
2. **Fixed typo** - `$EdditionChoice` → `$EditionChoice` in Main.au3
3. **Removed VNC** - Deleted `Helper/PEAutoRun/vncserver/` and `Helper/Tools/VNCHelper/`
4. **Updated docs** - Added SETUP.md, TRANSFER-INSTRUCTIONS.md, PACKAGE.bat

### Files Modified
- `Helper/Main.au3` - Fixed variable naming (line 246, 474-481)
- `README.md` - Removed VNC references, added BuildUI.bat instructions
- `Build.bat` - (unchanged, but now configurable via BuildUI.bat)

### Files Added
- `BuildUI.bat` - Configuration menu interface
- `BuildTools/` - Button framework (6 files)
- `SETUP.md` - Installation guide
- `TRANSFER-INSTRUCTIONS.md` - Transfer guide
- `PACKAGE.bat` - Project packager
- `CLAUDE.md` - This file

## Common Issues & Solutions

### Build.bat Fails

**"Media path not found"**
- Check `mediapath` variable is set correctly
- Parent folder must exist
- No trailing slash

**DISM errors**
- ADK version must match Windows ISO version
- See `Extra/ADK-Versions.md` for compatibility
- Must run as Administrator

**"Boot.wim not found"**
- Ensure ISO extraction completed
- Check `%mediapath%\sources\boot.wim` exists

### BuildUI.bat Issues

**Settings not reading correctly**
- Verify Build.bat uses correct format: `set sourceiso=path` (no quotes)
- Toggle format: `set "auto_extractiso=*"` or `set "auto_extractiso= "`

**Batch syntax errors**
- If/Else must be outside FOR loop for complex checks
- Use delayed expansion: `!VAR!` not `%VAR%` inside loops

### Helper Script Issues

**Script doesn't run in WinPE**
- Check `Windows\System32\winpeshl.ini` exists
- Verify `Helper\Main.bat` and `Helper\Main.au3` are present
- Check AutoIt3.exe is 64-bit version

**Tools don't appear in menu**
- Files in `Tools\` must be executables or have `main.au3/main.bat/main.exe`
- Folders need launch files to be executable
- Files starting with `.` are hidden

## Dependencies

### Required for Building
- **Windows ADK** (Assessment and Deployment Kit)
- **Windows PE add-on for ADK**
- Both must match Windows ISO version (10/11, build number)

### Runtime (Included)
- **AutoIt3.exe** - v3.3+ (x64)
- **Button framework** - Batch UI tools (BuildTools/)
- **7-Zip** - For ISO extraction (Helper/Tools/7-Zip/)

### WinPE Packages Added
- WinPE-WMI, WinPE-NetFx, WinPE-Scripting
- WinPE-PowerShell, WinPE-StorageWMI
- WinPE-SecureBootCmdlets, WinPE-SecureStartup
- WinPE-DismCmdlets, WinPE-EnhancedStorage
- And others (see Build.bat line 244-260)

## Development Workflow

### Making Changes to Helper Script
1. Edit `Helper/Main.au3` or related files
2. Test locally: `AutoIt3.exe Main.au3`
3. Run `Build.bat` to integrate into ISO
4. Test in VM or physical machine

### Adding New Tools
1. Place in `Helper/Tools/ToolName/`
2. Add executable or `main.bat`/`main.au3`
3. Rebuild ISO
4. Tool appears in WinPE menu automatically

### Adding Post-Install Scripts
1. Place in `Helper/Scripts/` or `Helper/Apps/`
2. Name with `[system]` suffix for system context
3. Name with `[background]` suffix for async execution
4. Scripts run after Windows installation completes

### Modifying Build Process
1. Edit `Build.bat` directly (advanced)
2. Or use `BuildUI.bat` to toggle steps
3. Test with small ISO first
4. Full build takes ~30-45 minutes

## Testing Checklist

- [ ] BuildUI.bat reads settings correctly
- [ ] BuildUI.bat saves settings to Build.bat
- [ ] Build.bat extracts ISO successfully
- [ ] DISM mounts boot.wim without errors
- [ ] Files copy to mounted image
- [ ] Packages add successfully (requires matching ADK)
- [ ] ISO builds and is bootable
- [ ] WinPE boots and shows Helper GUI
- [ ] Tools run from GUI
- [ ] Automated install works
- [ ] Post-install scripts execute

## Batch Script Gotchas

### Delayed Expansion
Always use `SETLOCAL ENABLEDELAYEDEXPANSION` and `!VAR!` for variables modified in loops.

### Special Characters
- `*` in string replacement matches everything
- Use `~` for substring operations: `!VAR:~0,5!`
- Quote paths with spaces: `"%PATH%"`
- Use `^` to escape in FINDSTR regex

### FOR Loop Limitations
- Cannot use multi-line IF/ELSE inside `()`
- Extract values first, check later
- Use `/F "delims="` to preserve spaces

## Future Enhancement Ideas

- Add more program installers to Apps/
- Create graphical program selection in BuildUI.bat
- Add preset configurations (minimal, full, custom)
- Integrate update checker for tools
- Add validation for paths before build

## Support Resources

- **This Repository**: https://github.com/AZComputerGuru/windows-setup-helper
- **Original Project**: https://github.com/jmclaren7/windows-setup-helper
- **Button Framework**: https://github.com/Batch-Man/Button
- **AutoIt Documentation**: https://www.autoitscript.com/autoit3/docs/
- **DISM Reference**: https://learn.microsoft.com/en-us/windows-hardware/manufacture/desktop/dism-image-management-command-line-options-s6

---

When working with this project, focus on:
1. Build.bat toggle system (asterisk-based)
2. BuildUI.bat settings parser (FINDSTR + substring check)
3. Helper/Main.au3 script flow (AutoIt)
4. DISM workflow and WinPE customization
