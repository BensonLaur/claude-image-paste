# Clipboard Image Saver

A lightweight Windows tool that instantly gets file paths from clipboard - supports both **screenshots** and **files copied from Explorer**. Perfect for sharing with AI coding assistants like Claude Code.

---

## Claude Code Native Image Paste Methods (Windows)

Before using this tool, you should know that **Claude Code already has built-in image paste support**. Here are the native methods available on Windows:

| Method | How to Use | Notes |
|--------|------------|-------|
| `Alt+V` | Paste clipboard image data | Works with screenshots (Snipaste, Win+Shift+S, WeChat copy image, etc.). **Does NOT work with files copied from Explorer** |
| Drag & Drop | Drag image file to terminal | Most intuitive way |
| Paste file path | Right-click to paste full path | Path will be auto-recognized as image |

> **Source**: [Claude Code Keyboard Shortcuts](https://code.claude.com/docs/en/interactive-mode#keyboard-shortcuts)

**Important Notes for Windows:**
- `Ctrl+V` does NOT work in Windows terminal for pasting text - use right-click instead
- `Alt+V` only works with **actual image data** in clipboard, not file references from Explorer

---

## Why This Tool Was Created

This tool was created **before** discovering Claude Code's native `Alt+V` support. The original assumption was that the only way to share images with Claude Code was to paste file paths manually, which is tedious.

**However, this tool still provides unique value** for scenarios not covered by native features.

---

## Remaining Advantages Over Native Features

| Scenario | Native Claude Code | This Tool |
|----------|-------------------|-----------|
| Screenshot → Send to Claude | `Alt+V` pastes directly ✅ | Saves file first, then copies path |
| **Explorer copied file → Get path** | ❌ Not supported (`Alt+V` shows "No image found") | ✅ `Ctrl+Shift+V` gets path instantly |
| **Multi-file path extraction** | ❌ Must drag one by one or copy paths manually | ✅ Copy multiple files, get all paths at once |
| **Auto-archive screenshots** | ❌ Not saved to disk | ✅ Screenshots saved to `D:\ClaudeImages\` |

### When to Use This Tool

✅ **Use this tool if you:**
- Frequently copy files from Explorer and need their paths quickly
- Want to keep a local archive of screenshots you share
- Need to get multiple file paths at once

❌ **Use native features instead if you:**
- Just want to quickly share a screenshot → Use `Alt+V`
- Want to share a single file → Drag & drop is easier

---

## The Problem (Original Motivation)

When using AI coding tools like **Claude Code**, sharing images or files can be tedious without knowing the shortcuts:

**For screenshots (without `Alt+V`):**
1. Take a screenshot
2. Open a file dialog, choose a folder
3. Name the file, save it
4. Copy the file path
5. Paste the path to the AI tool

**For existing files (still a problem with native features):**
1. Navigate to the file in Explorer
2. Copy the full path from address bar (or Shift+Right-click → Copy as path)
3. Paste the path to the AI tool

## The Solution

With this tool, just press `Ctrl+Shift+V`:

| Clipboard Content | What Happens |
|-------------------|--------------|
| Screenshot | Saves image, copies path |
| File(s) from Explorer | Copies file path(s) directly |

**That's it!** One hotkey for both scenarios.

## Features

- **Screenshot to path**: Automatically saves clipboard images and copies the file path
- **File to path**: Instantly get paths of files copied from Windows Explorer
- **Multi-file support**: Copy multiple files, get all paths (one per line)
- **Auto-install**: Automatically installs AutoHotkey if not present
- **Lightweight**: Minimal resource usage, runs in system tray

## Requirements

- **Windows 10/11**
- **AutoHotkey v2** - Will be installed automatically if not present

## Installation

### Option 1: Quick Start (Recommended)

1. Download or clone this repository
2. Double-click `StartClipboardSaver.bat`
3. AutoHotkey will be installed automatically if needed
4. Start using `Ctrl+Shift+V`

### Option 2: Manual

1. Install [AutoHotkey v2](https://www.autohotkey.com/)
2. Double-click `ClipboardImageSaver.ahk`

## Usage

### For Screenshots

```
Take screenshot → Ctrl+Shift+V → Paste path
```

1. Take a screenshot (Snipaste, Win+Shift+S, etc.)
2. Press `Ctrl+Shift+V`
3. Image is saved, path is copied
4. Paste (`Ctrl+V`) the path to Claude Code

### For Files from Explorer

```
Select file(s) → Ctrl+C → Ctrl+Shift+V → Paste path
```

1. Select file(s) in Windows Explorer
2. Press `Ctrl+C` to copy
3. Press `Ctrl+Shift+V`
4. File path(s) copied to clipboard
5. Paste (`Ctrl+V`) the path to Claude Code

**Multi-file**: When multiple files are copied, all paths are copied (one per line).

### Tray Menu

Right-click the system tray icon (green **H**) to:
- Open the image folder
- Exit the tool

## Configuration

Edit `ClipboardImageSaver.ahk` to customize:

### Change Save Directory

```ahk
; Line 23 - Change the save location
SAVE_DIR := "D:\ClaudeImages"        ; Default
SAVE_DIR := "C:\Screenshots"         ; Custom example
SAVE_DIR := A_Desktop . "\Images"    ; Desktop/Images folder
```

### Change Hotkey

```ahk
; Line 36 - Change the hotkey
^+v::ProcessClipboard()    ; Ctrl+Shift+V (default)
^+s::ProcessClipboard()    ; Ctrl+Shift+S
^!v::ProcessClipboard()    ; Ctrl+Alt+V
#v::ProcessClipboard()     ; Win+V
```

**Hotkey Symbols:**
| Symbol | Key |
|--------|-----|
| `^` | Ctrl |
| `+` | Shift |
| `!` | Alt |
| `#` | Win |

## Auto-Start (Optional)

To run automatically at startup:

1. Press `Win+R`
2. Type `shell:startup` and press Enter
3. Create a shortcut to `ClipboardImageSaver.ahk` in this folder

## How It Works

```
┌─────────────────────────────────────────────────────────┐
│                  Ctrl+Shift+V pressed                   │
└─────────────────────────┬───────────────────────────────┘
                          │
                          ▼
              ┌───────────────────────┐
              │  Check clipboard type │
              └───────────┬───────────┘
                          │
            ┌─────────────┴─────────────┐
            │                           │
            ▼                           ▼
   ┌─────────────────┐        ┌─────────────────┐
   │ Files from      │        │ Image data      │
   │ Explorer?       │        │ (screenshot)?   │
   └────────┬────────┘        └────────┬────────┘
            │                          │
            ▼                          ▼
   ┌─────────────────┐        ┌─────────────────┐
   │ Copy file       │        │ Save as PNG     │
   │ path(s)         │        │ Copy path       │
   └─────────────────┘        └─────────────────┘
```

## Supported Screenshot Tools

Tested with:
- Snipaste
- Windows Snipping Tool (Win+Shift+S)
- ShareX
- Greenshot
- Any tool that copies images to clipboard

## Troubleshooting

### "No image or file in clipboard"
- For screenshots: Make sure you've taken a screenshot (not just selected an area)
- For files: Make sure you pressed `Ctrl+C` after selecting the file

### Hotkey doesn't work
- Check if another app is using the same hotkey
- Make sure the script is running (look for the **H** icon in system tray)

### AutoHotkey installation fails
- Install manually from https://www.autohotkey.com/
- Make sure you install **v2**, not v1

## Files

```
claude-image-paste/
├── ClipboardImageSaver.ahk    # Main script
├── StartClipboardSaver.bat    # One-click launcher with auto-install
├── README.md                  # This file
└── LICENSE                    # MIT License
```

## License

MIT License - Feel free to use, modify, and distribute.

## Contributing

Issues and pull requests are welcome!

## Acknowledgments

Built for the Claude Code community and anyone who needs to share screenshots or files with AI tools quickly.
