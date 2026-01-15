# Clipboard Image Saver

A lightweight Windows tool that saves clipboard images with one hotkey and copies the file path - perfect for sharing screenshots with AI coding assistants like Claude Code.

## The Problem

When using AI coding tools like **Claude Code**, sharing screenshots is tedious:
1. Take a screenshot
2. Open a file dialog, choose a folder
3. Name the file, save it
4. Copy the file path
5. Paste the path to the AI tool

## The Solution

With this tool:
1. Take a screenshot
2. Press `Ctrl+Shift+V`
3. Paste the path - done!

The image is automatically saved and the file path is copied to your clipboard.

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

```
Screenshot → Ctrl+Shift+V → Paste path to AI tool
```

1. Take a screenshot using any tool (Snipaste, Win+Shift+S, etc.)
2. Press `Ctrl+Shift+V`
3. A notification confirms the save
4. Paste (`Ctrl+V`) the path anywhere

**Tray Menu**: Right-click the system tray icon to:
- Open the image folder
- Exit the tool

## Configuration

Edit `ClipboardImageSaver.ahk` to customize:

### Change Save Directory

```ahk
; Line 19 - Change the save location
SAVE_DIR := "D:\ClaudeImages"        ; Default
SAVE_DIR := "C:\Screenshots"         ; Custom example
SAVE_DIR := A_Desktop . "\Images"    ; Desktop/Images folder
```

### Change Hotkey

```ahk
; Line 32 - Change the hotkey
^+v::SaveClipboardImage()    ; Ctrl+Shift+V (default)
^+s::SaveClipboardImage()    ; Ctrl+Shift+S
^!v::SaveClipboardImage()    ; Ctrl+Alt+V
#v::SaveClipboardImage()     ; Win+V
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

1. **Hotkey Detection**: AutoHotkey listens for `Ctrl+Shift+V`
2. **Image Extraction**: PowerShell extracts the image from clipboard (supports multiple formats: PNG, DIB, Bitmap)
3. **File Save**: Image is saved as PNG with timestamp filename (e.g., `20240115_143022.png`)
4. **Path Copy**: The full file path is copied back to clipboard

## Supported Screenshot Tools

Tested with:
- Snipaste
- Windows Snipping Tool (Win+Shift+S)
- ShareX
- Greenshot
- Any tool that copies images to clipboard

## Troubleshooting

### "No image in clipboard"
- Make sure you've copied an image, not a file
- Some apps copy images in unsupported formats - try a different screenshot tool

### Hotkey doesn't work
- Check if another app is using the same hotkey
- Make sure the script is running (look for the **H** icon in system tray)

### AutoHotkey installation fails
- Install manually from https://www.autohotkey.com/
- Make sure you install **v2**, not v1

## Files

```
ClaudeImagePasteTool/
├── ClipboardImageSaver.ahk    # Main script
├── StartClipboardSaver.bat    # One-click launcher with auto-install
└── README.md                  # This file
```

## License

MIT License - Feel free to use, modify, and distribute.

## Contributing

Issues and pull requests are welcome!

## Acknowledgments

Built for the Claude Code community and anyone who needs to share screenshots with AI tools quickly.
