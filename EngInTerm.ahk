IsWT() {
    PostMessage 0x0050, 0, 0x4090409,, "A"
    SetCapsLockState 0
}

#HotIf WinActive("ahk_exe WindowsTerminal.exe")
    CapsLock::Escape

loop {
    WinWaitActive("ahk_exe WindowsTerminal.exe")
    IsWT()
    WinWaitNotActive("ahk_exe WindowsTerminal.exe")
}

EscHotkey(key) {
    Send "{Esc}"
}
