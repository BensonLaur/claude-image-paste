; ============================================================
; ClipboardImageSaver - Quick clipboard image/file path tool
; Quickly get file paths from clipboard for AI tools
;
; Supports:
;   - Screenshots (Snipaste, Win+Shift+S, etc.)
;   - Files copied from Windows Explorer
;
; Usage:
;   1. Copy a file OR take a screenshot
;   2. Press Ctrl+Shift+V
;   3. File path is copied to clipboard
;   4. Paste the path to Claude Code or other AI tools
;
; Requires AutoHotkey v2: https://www.autohotkey.com/
; ============================================================

#Requires AutoHotkey v2.0
#SingleInstance Force

; ==================== CONFIGURATION ====================
; Image save directory (customize as needed)
SAVE_DIR := "D:\ClaudeImages"

; Hotkey: ^ = Ctrl, + = Shift, ! = Alt
; Default: Ctrl+Shift+V
; To change, modify the hotkey definition below (line 36)
; Examples: ^+s (Ctrl+Shift+S), ^!v (Ctrl+Alt+V)
; ===========================================================

; Ensure save directory exists
if !DirExist(SAVE_DIR)
    DirCreate(SAVE_DIR)

; Register hotkey: Ctrl+Shift+V
^+v::ProcessClipboard()

; Tray menu
A_TrayMenu.Delete()
A_TrayMenu.Add("Open Image Folder", (*) => Run(SAVE_DIR))
A_TrayMenu.Add("Exit", (*) => ExitApp())
A_IconTip := "Clipboard Image Saver (Ctrl+Shift+V)"

; Startup notification
TrayTip("Clipboard Image Saver", "Press Ctrl+Shift+V to get image/file path", 1)

; Main function: Process clipboard content
ProcessClipboard(*) {
    global SAVE_DIR

    ; Output file for PowerShell result
    resultFile := A_Temp . "\clipboard_result.txt"
    if FileExist(resultFile)
        FileDelete(resultFile)

    ; Generate filename with timestamp for potential image save
    fileName := FormatTime(, "yyyyMMdd_HHmmss") . ".png"
    imagePath := SAVE_DIR . "\" . fileName

    ; Create PowerShell script with paths embedded directly
    psScriptPath := A_Temp . "\clipboard_process.ps1"
    psScript := "
    (
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Priority 1: Check for files copied from Explorer
$fileList = [System.Windows.Forms.Clipboard]::GetFileDropList()
if ($fileList.Count -gt 0) {
    $paths = $fileList -join '|'
    Set-Content -Path '<<<RESULTFILE>>>' -Value "FILES:$paths" -Encoding UTF8
    exit
}

# Priority 2: Check for image in clipboard
$data = [System.Windows.Forms.Clipboard]::GetDataObject()
$img = $null

# Try PNG stream
if ($data.GetDataPresent('PNG')) {
    $stream = $data.GetData('PNG')
    if ($stream) {
        $img = [System.Drawing.Image]::FromStream($stream)
    }
}

# Try image/png format
if ($img -eq $null -and $data.GetDataPresent('image/png')) {
    $stream = $data.GetData('image/png')
    if ($stream) {
        $img = [System.Drawing.Image]::FromStream($stream)
    }
}

# Try standard GetImage
if ($img -eq $null) {
    $img = [System.Windows.Forms.Clipboard]::GetImage()
}

if ($img -ne $null) {
    $img.Save('<<<IMAGEPATH>>>', [System.Drawing.Imaging.ImageFormat]::Png)
    $img.Dispose()
    Set-Content -Path '<<<RESULTFILE>>>' -Value 'IMAGE:<<<IMAGEPATH>>>' -Encoding UTF8
} else {
    Set-Content -Path '<<<RESULTFILE>>>' -Value 'NOTHING' -Encoding UTF8
}
    )"

    ; Replace placeholders (using unique markers to avoid conflicts)
    psScript := StrReplace(psScript, "<<<RESULTFILE>>>", resultFile)
    psScript := StrReplace(psScript, "<<<IMAGEPATH>>>", imagePath)

    ; Write PowerShell script
    if FileExist(psScriptPath)
        FileDelete(psScriptPath)
    FileAppend(psScript, psScriptPath, "UTF-8")

    ; Run PowerShell script
    try {
        RunWait('powershell.exe -NoProfile -ExecutionPolicy Bypass -File "' . psScriptPath . '"',, "Hide")

        ; Read result
        if !FileExist(resultFile) {
            TrayTip("Error", "Failed to process clipboard", 3)
            return
        }

        result := Trim(FileRead(resultFile))

        if (SubStr(result, 1, 6) = "FILES:") {
            ; Files from Explorer
            filesStr := SubStr(result, 7)
            files := StrSplit(filesStr, "|")

            if (files.Length = 1) {
                ; Single file
                A_Clipboard := files[1]
                SplitPath(files[1], &name)
                TrayTip("File Path Copied", name, 1)
            } else {
                ; Multiple files
                allPaths := ""
                for index, f in files {
                    allPaths .= f . "`n"
                }
                A_Clipboard := RTrim(allPaths, "`n")
                TrayTip("File Paths Copied", files.Length . " files", 1)
            }
        } else if (SubStr(result, 1, 6) = "IMAGE:") {
            ; Image saved
            savedPath := SubStr(result, 7)
            A_Clipboard := savedPath
            SplitPath(savedPath, &name)
            TrayTip("Image Saved", "Path copied: " . name, 1)
        } else {
            ; Nothing useful
            TrayTip("Notice", "No image or file in clipboard", 2)
        }
    } catch as e {
        TrayTip("Error", "Failed: " . e.Message, 3)
    }
}
