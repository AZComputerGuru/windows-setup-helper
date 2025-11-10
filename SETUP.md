# Windows Setup Helper - Installation Guide

This guide will help you set up Windows Setup Helper on a new machine.

## Table of Contents
- [Quick Start](#quick-start)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [First-Time Configuration](#first-time-configuration)
- [Building Your First ISO](#building-your-first-iso)

## Quick Start

**For experienced users:**
1. Extract the project folder to your desired location
2. Download a Windows 11/10 ISO
3. Install Windows ADK + ADK PE add-on (matching your Windows version)
4. Run `BuildUI.bat` to configure settings
5. Press [S] to save, [R] to run the build

## Prerequisites

### Required Downloads

1. **Windows Installer ISO**
   - Download from: https://www.microsoft.com/software-download/windows11
   - Or Windows 10: https://www.microsoft.com/software-download/windows10

2. **Windows Assessment and Deployment Kit (ADK)**
   - **CRITICAL**: Version must match your Windows ISO version
   - See `Extra/ADK-Versions.md` for version compatibility and download links
   - Download and install:
     - Windows ADK
     - Windows PE add-on for ADK

### System Requirements
- Windows 10/11 (64-bit)
- Administrator privileges (for building the ISO)
- At least 10 GB free disk space
- Recommended: 16 GB RAM or more

## Installation

### Method 1: From GitHub (Recommended)

```bash
git clone https://github.com/AZComputerGuru/windows-setup-helper.git
cd windows-setup-helper
```

### Method 2: From ZIP Archive

1. Extract the `windows-setup-helper.zip` to your desired location
2. Example: `C:\Projects\windows-setup-helper`

**Important Notes:**
- Avoid paths with spaces or special characters
- Recommended location: Root of C: drive or a simple path
- Avoid OneDrive/Cloud synced folders (large ISO files)

## First-Time Configuration

### Using BuildUI.bat (Recommended for Beginners)

1. **Navigate to the project folder**
   ```
   cd C:\Path\To\windows-setup-helper
   ```

2. **Run BuildUI.bat** (no admin needed for configuration)
   ```
   BuildUI.bat
   ```

3. **Configure your paths using the menu:**
   - Press `1` to set Source ISO path
     - Example: `E:\ISOs\Windows11.iso`
   - Press `2` to set Media extraction path
     - Example: `E:\Windows Images\11`
     - This needs ~8 GB free space
   - Press `3` to set Output ISO path
     - Example: `E:\Output\Windows11-Custom.iso`
   - Press `4` to set Extra files path (optional)
     - Example: `E:\CustomTools`

4. **Configure build steps (5-C):**
   - Toggle steps on [X] or off [ ] as needed
   - Default settings work for most users

5. **Save and Run:**
   - Press `S` to save settings to Build.bat
   - Press `R` to run the build (requires admin)

### Manual Configuration (Advanced)

Edit `Build.bat` directly:
```batch
set sourceiso=E:\Windows Images\Windows 11 25H2 MCT 2510.iso
set mediapath=E:\Windows Images\11
set outputiso=E:\Windows Images\Windows11.iso
set extrafiles=E:\Windows Images\Additions
```

## Building Your First ISO

### Step-by-Step Process

1. **Ensure prerequisites are installed:**
   - ✓ Windows ADK (correct version)
   - ✓ Windows PE add-on for ADK
   - ✓ Source Windows ISO downloaded

2. **Configure BuildUI.bat** (see above)

3. **Run the build:**
   - From BuildUI.bat: Press `R`
   - Or run `Build.bat` directly as Administrator
   - Or right-click `Build.bat` → Run as Administrator

4. **Monitor the process:**
   - Extract ISO: ~5-10 minutes
   - Mount WIM: ~2-5 minutes
   - Copy Files: ~1 minute
   - Add Packages: ~10-15 minutes
   - Unmount/Commit: ~5-10 minutes
   - Make ISO: ~5 minutes
   - **Total time: ~30-45 minutes** (varies by system)

5. **Build complete!**
   - Output ISO location: As configured in settings
   - Use Rufus to create bootable USB

## Directory Structure

```
windows-setup-helper/
├── Build.bat              # Main build script
├── BuildUI.bat            # Configuration UI
├── BuildTools/            # UI framework dependencies
├── Helper/                # Main helper files
│   ├── Main.au3          # AutoIt main script
│   ├── Apps/             # WinGet app installers
│   ├── Scripts/          # Post-install scripts
│   ├── Tools/            # WinPE tools
│   └── PEAutoRun/        # Scripts that run at WinPE boot
├── Windows/               # Font and system files
├── Extra/                 # Documentation and assets
└── README.md             # Project documentation
```

## Adding Custom Tools/Scripts

### Adding Tools (Available in WinPE)
1. Place executables in `Helper/Tools/`
2. They'll appear in the WinPE Tools menu

### Adding Post-Install Scripts
1. Place scripts in `Helper/Scripts/` or `Helper/Apps/`
2. Select them during automated install
3. They run after Windows installation completes

### Adding Drivers
1. Place driver files in `Helper/PEAutoRun/Drivers/`
2. They'll be installed to WinPE automatically

## Troubleshooting

### Build.bat fails with "Media path not found"
- Check that `mediapath` is set correctly
- Ensure the parent folder exists
- Path should not include trailing slash

### DISM errors during build
- Verify ADK version matches Windows ISO version
- Run as Administrator
- Check available disk space (need ~10 GB free)

### Can't find boot.wim
- Ensure ISO extraction completed successfully
- Check `mediapath\sources\boot.wim` exists
- Re-run with Extract ISO step enabled

### Output ISO won't boot
- Verify BIOS/UEFI settings on target machine
- Try different USB creation tool (Rufus recommended)
- Rebuild ISO with all steps enabled

## Advanced Configuration

### Using ExtraFiles
Create a separate folder for your custom additions:
```
E:\MyCustomizations\
├── Helper\
│   ├── Tools\
│   │   └── MyTool.exe
│   └── Scripts\
│       └── MyScript.bat
```

Set `extrafiles=E:\MyCustomizations` in Build.bat

These files will be copied OVER the project files, allowing you to:
- Add your own tools/scripts
- Override default configurations
- Keep customizations separate from the main project

### Customizing autounattend.xml
Edit `Helper\autounattend.xml` to customize:
- Language and timezone
- Computer name pattern
- Administrator password
- Domain join settings
- Partition schemes

## Support

- **Project Repository**: https://github.com/AZComputerGuru/windows-setup-helper
- **Original Project**: https://github.com/jmclaren7/windows-setup-helper
- **Issues**: Report bugs on GitHub

## What's Different in This Fork?

This fork includes:
- ✨ **BuildUI.bat** - Easy configuration interface
- 🧹 Removed VNC components
- 🐛 Fixed typos in Main.au3
- 📝 Updated documentation

## License

See `LICENSE` file in the project root.

---

**Ready to build?** Run `BuildUI.bat` and start customizing your Windows installer!
