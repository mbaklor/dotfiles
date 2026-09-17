; IsWT() {
;     PostMessage 0x0050, 0, 0x4090409,, "A"
;     SetCapsLockState 0
; }
;
; #HotIf WinActive("ahk_exe wezterm-gui.exe")
;     CapsLock::Escape
;
; loop {
;     WinWaitActive("ahk_exe wezterm-gui.exe")
;     IsWT()
;     WinWaitNotActive("ahk_exe wezterm-gui.exe")
; }
#Requires AutoHotkey v2.0
#SingleInstance Force

; Apps that should switch to en-US + drop Caps Lock on focus
LangApps := Map(
    "wezterm-gui.exe", 1,
    "emacs.exe",       1,
    "runemacs.exe",    1,   ; emacs frequently launches as runemacs.exe
)

ApplyLayout(target := "A") {
    PostMessage 0x0050, 0, 0x04090409, , target  ; WM_INPUTLANGCHANGEREQUEST -> en-US
    SetCapsLockState 0
}

; Fire on every window activation
DllCall("RegisterShellHookWindow", "Ptr", A_ScriptHwnd)
OnMessage(DllCall("RegisterWindowMessage", "Str", "SHELLHOOK"), ShellMessage)

ShellMessage(wParam, lParam, *) {
    ; HSHELL_WINDOWACTIVATED = 4, HSHELL_RUDEAPPACTIVATED = 32772 (fullscreen)
    if (wParam != 4 && wParam != 32772) || !lParam
        return
    exe := ""
    try exe := WinGetProcessName(lParam)
    if LangApps.Has(exe)
        ApplyLayout("ahk_id " lParam)
}

; Per-app hotkeys stay separate
#HotIf WinActive("ahk_exe wezterm-gui.exe")
    CapsLock::Escape
#HotIf
