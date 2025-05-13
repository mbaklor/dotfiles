#Requires AutoHotkey v2.0

SwitchToWindow(WindowID, runCmd) {
    userprofile := EnvGet("USERPROFILE")
    SetWorkingDir userprofile
    windowHandleID := WinExist(WindowID)
    windowExists := windowHandleID > 0

    if (windowExists) {
        activeWindowID := WinExist("A")
        windowActive := activeWindowID == windowHandleID
        if (windowActive) {
            WinMinimize windowHandleID
        } else {
            WinActivate windowHandleID
            WinShow windowHandleID
        }
    } else {
        Run runCmd
        if WinWait(WindowID, , 5) {
            if WinExist(WindowID) {
                WinActivate
            }
        }
        ; Sleep 500
    }
}

SwitchToWindowsTerminal() {
    SwitchToWindow("ahk_exe WindowsTerminal.exe", "wt")
}

SwitchToWezterm() {
    SwitchToWindow("ahk_exe wezterm-gui.exe", "wezterm-gui")
}

#+`::SwitchToWindowsTerminal()
#`::SwitchToWezterm()
