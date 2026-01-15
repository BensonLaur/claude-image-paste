# Clipboard Image Saver

A lightweight Windows tool that instantly gets file paths from clipboard - supports both **screenshots** and **files copied from Explorer**. Perfect for sharing with AI coding assistants like Claude Code.

## The Problem

When using AI coding tools like **Claude Code**, sharing images or files is tedious:

**For screenshots:**
1. Take a screenshot
2. Open a file dialog, choose a folder
3. Name the file, save it
4. Copy the file path
5. Paste the path to the AI tool

**For existing files:**
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
