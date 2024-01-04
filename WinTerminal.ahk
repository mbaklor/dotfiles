#Requires AutoHotkey v2.0

SwitchToWindowsTerminal() {
    userprofile := EnvGet("USERPROFILE")
    SetWorkingDir userprofile
    windowHandleID := WinExist("ahk_exe WindowsTerminal.exe")
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
        Run "wt"
        if WinWait("ahk_exe WindowsTerminal.exe", , 5) {
            if WinExist("ahk_exe WindowsTerminal.exe") {
                WinActivate
            }
        }
        ; Sleep 500
    }
}

#`::SwitchToWindowsTerminal()
