; ============================================================
; ClipboardImageSaver - Quick clipboard image save tool
; Quickly save screenshots and get the file path for AI tools
;
; Usage:
;   1. Take a screenshot (Snipaste, Win+Shift+S, etc.)
;   2. Press Ctrl+Shift+V
;   3. Image is saved and path is copied to clipboard
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
; To change, modify the hotkey definition below (line 32)
; Examples: ^+s (Ctrl+Shift+S), ^!v (Ctrl+Alt+V)
; ===========================================================

; Ensure save directory exists
if !DirExist(SAVE_DIR)
    DirCreate(SAVE_DIR)

; Register hotkey: Ctrl+Shift+V
^+v::SaveClipboardImage()

; Tray menu
A_TrayMenu.Delete()
A_TrayMenu.Add("Open Image Folder", (*) => Run(SAVE_DIR))
A_TrayMenu.Add("Exit", (*) => ExitApp())
A_IconTip := "Clipboard Image Saver (Ctrl+Shift+V)"

; Startup notification
TrayTip("Clipboard Image Saver", "Press Ctrl+Shift+V to save clipboard image", 1)

; Main function: Save clipboard image (using PowerShell)
SaveClipboardImage(*) {
    global SAVE_DIR

    ; Generate filename with timestamp
    fileName := FormatTime(, "yyyyMMdd_HHmmss") . ".png"
    filePath := SAVE_DIR . "\" . fileName

    ; Create PowerShell script file (avoids command line escaping issues)
    psScriptPath := A_Temp . "\clipboard_save.ps1"
    psScript := "
    (
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$data = [System.Windows.Forms.Clipboard]::GetDataObject()
$img = $null

# Method 1: Try PNG stream
if ($data.GetDataPresent('PNG')) {
    $stream = $data.GetData('PNG')
    if ($stream) {
        $img = [System.Drawing.Image]::FromStream($stream)
    }
}

# Method 2: Try image/png format
if ($img -eq $null -and $data.GetDataPresent('image/png')) {
    $stream = $data.GetData('image/png')
    if ($stream) {
        $img = [System.Drawing.Image]::FromStream($stream)
    }
}

# Method 3: Try standard GetImage
if ($img -eq $null) {
    $img = [System.Windows.Forms.Clipboard]::GetImage()
}

# Method 4: Try DIB format
if ($img -eq $null -and $data.GetDataPresent([System.Windows.Forms.DataFormats]::Dib)) {
    $dib = $data.GetData([System.Windows.Forms.DataFormats]::Dib)
    if ($dib) {
        $img = [System.Drawing.Image]::FromStream($dib)
    }
}

if ($img -ne $null) {
    $img.Save('FILEPATH', [System.Drawing.Imaging.ImageFormat]::Png)
    $img.Dispose()
    Write-Output 'OK'
} else {
    Write-Output 'NO_IMAGE'
}
    )"

    ; Replace file path placeholder
    psScript := StrReplace(psScript, "FILEPATH", filePath)

    ; Write temporary script file
    if FileExist(psScriptPath)
        FileDelete(psScriptPath)
    FileAppend(psScript, psScriptPath, "UTF-8")

    ; Run PowerShell script
    try {
        RunWait('powershell.exe -NoProfile -ExecutionPolicy Bypass -File "' . psScriptPath . '"',, "Hide")

        ; Check if file was created successfully
        if FileExist(filePath) {
            ; Copy path to clipboard
            A_Clipboard := filePath
            TrayTip("Saved", "Path copied:`n" . filePath, 1)
        } else {
            TrayTip("Notice", "No image in clipboard", 2)
        }
    } catch as e {
        TrayTip("Error", "Save failed: " . e.Message, 3)
    }
}
