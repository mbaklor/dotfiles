IsWT() {
    PostMessage 0x0050, 0, 0x4090409,, "A"
    SetCapsLockState 0
}

#HotIf WinActive("ahk_exe WindowsTerminal.exe") or WinActive("ahk_exe wezterm-gui.exe")
    CapsLock::Escape

waitLoop() {
    loop {
        if WinActive("ahk_exe WindowsTerminal.exe") or WinActive("ahk_exe wezterm-gui.exe") {
            break
        }
    }
    IsWT()
    loop {
        if !WinActive("ahk_exe WindowsTerminal.exe") and !WinActive("ahk_exe wezterm-gui.exe") {
            break
        }
    }
    waitLoop()
}

waitLoop()
