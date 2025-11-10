# Transfer Instructions

## Option 1: Using PACKAGE.bat (Easiest)

1. **Run the packager:**
   ```
   PACKAGE.bat
   ```

2. **Package will be created on your Desktop:**
   - Location: `Desktop\windows-setup-helper-package\`
   - Size: ~50-100 MB (without ISOs)

3. **Transfer the package:**
   - Copy to USB drive, network share, or cloud storage
   - Transfer to new machine

4. **On the new machine:**
   - Extract/copy the folder to desired location
   - Read `SETUP.md` for installation instructions
   - Run `BuildUI.bat` to configure

## Option 2: Using Git Clone (For Git Users)

**On the new machine:**

```bash
git clone https://github.com/AZComputerGuru/windows-setup-helper.git
cd windows-setup-helper
```

Then follow `SETUP.md` for configuration.

## Option 3: Download from GitHub

1. Visit: https://github.com/AZComputerGuru/windows-setup-helper
2. Click "Code" → "Download ZIP"
3. Extract on new machine
4. Follow `SETUP.md`

## What NOT to Transfer

**Do NOT copy these files (they're machine-specific):**
- Windows ISO files (download fresh on new machine)
- Extracted media folders
- Generated output ISOs
- Build cache/temp files

**Only transfer:**
- The project files (Helper/, BuildTools/, etc.)
- Your custom scripts/tools
- Configuration files (will need path updates)

## After Transfer Checklist

On the new machine:

- [ ] Install Windows ADK + PE add-on
- [ ] Download fresh Windows ISO
- [ ] Run BuildUI.bat
- [ ] Update all paths for new machine:
  - [ ] Source ISO path
  - [ ] Media extraction path
  - [ ] Output ISO path
  - [ ] Extra files path (if used)
- [ ] Save settings ([S] in BuildUI)
- [ ] Test build ([R] in BuildUI)

## File Sizes to Expect

- Project files: ~50-100 MB
- Windows ADK: ~4-6 GB download
- Windows ISO: ~5-7 GB
- Extracted media: ~8-10 GB
- Output ISO: ~6-8 GB

**Total disk space needed: ~25-30 GB**

## Quick Setup on New Machine

```batch
# 1. Copy project folder
# 2. Open PowerShell/CMD in project folder
cd C:\Path\To\windows-setup-helper

# 3. Configure
BuildUI.bat

# 4. Follow prompts to set paths
# 5. Press [S] to save
# 6. Press [R] to run build
```

## Troubleshooting Transfer Issues

**Problem: Paths don't work on new machine**
- Solution: Run BuildUI.bat and update all paths

**Problem: Build fails with ADK errors**
- Solution: Ensure ADK version matches Windows ISO version
- See `Extra/ADK-Versions.md`

**Problem: Missing tools/files**
- Solution: Verify all folders were copied:
  - BuildTools/
  - Helper/
  - Windows/
  - Build.bat
  - BuildUI.bat

## Support

- GitHub: https://github.com/AZComputerGuru/windows-setup-helper
- Original: https://github.com/jmclaren7/windows-setup-helper
