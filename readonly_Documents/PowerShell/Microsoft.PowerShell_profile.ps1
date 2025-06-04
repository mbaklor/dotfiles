# Prompt
function prompt
{
    $loc = $executionContext.SessionState.Path.CurrentLocation;
    $out = ""
    $osc7 = ""
    $osc9 = ""
    if ($loc.Provider.Name -eq "FileSystem")
    {
        $ansi_escape = [char]27
        $provider_path = $loc.ProviderPath -Replace "\\", "/"
        $osc9 += "$([char]27)]9;9;`"$($loc.ProviderPath)`"$([char]27)\"
        $osc7 = "$ansi_escape]7;file://${env:COMPUTERNAME}/${provider_path}${ansi_escape}\"
    }
    $out += "${osc9}${osc7}PS $loc$('>' * ($nestedPromptLevel + 1)) ";
    return $out
}

Set-PSReadLineKeyHandler -Chord UpArrow -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Chord DownArrow -Function HistorySearchForward

Set-PSReadLineKeyHandler -Chord Ctrl+y -Function AcceptSuggestion
Set-PSReadLineKeyHandler -Chord Ctrl+p -ScriptBlock {
    [Microsoft.PowerShell.PSConsoleReadLine]::SetMark()
    [Microsoft.PowerShell.PSConsoleReadLine]::HistorySearchBackward()
    [Microsoft.PowerShell.PSConsoleReadLine]::EndOfLine()
}
Set-PSReadLineKeyHandler -Chord Ctrl+n -ScriptBlock {
    [Microsoft.PowerShell.PSConsoleReadLine]::SetMark()
    [Microsoft.PowerShell.PSConsoleReadLine]::HistorySearchForward()
    [Microsoft.PowerShell.PSConsoleReadLine]::EndOfLine()
}
Set-PSReadLineKeyHandler -Chord Alt+x -Function ExchangePointAndMark

Set-PSReadLineKeyHandler -Chord Ctrl+a -Function BeginningOfLine
Set-PSReadLineKeyHandler -Chord Ctrl+e -Function EndOfLine
Set-PSReadLineKeyHandler -Chord Ctrl+b -Function BackwardChar
Set-PSReadLineKeyHandler -Chord Alt+b -Function BackwardWord
Set-PSReadLineKeyHandler -Chord Alt+f -Function ForwardWord
Set-PSReadLineKeyHandler -Chord Ctrl+u -Function BackwardDeleteLine

Set-PSReadLineKeyHandler -Chord Ctrl+f -ScriptBlock {
    [Microsoft.PowerShell.PSConsoleReadLine]::RevertLine()
    [Microsoft.PowerShell.PSConsoleReadLine]::Insert("ffd")
    [Microsoft.PowerShell.PSConsoleReadLine]::AcceptLine()
}

function conf([Parameter(Mandatory=$true)][string]$config)
{
    if ($config -eq "-?")
    {
        "edit configs of powershell or neovim"
        " "
        "   valid inputs:"
        "   conf [ps | nvim]"
    }
    if ($config -eq "nvim")
    {
        pushd $env:LOCALAPPDATA/nvim;
        nvim .;
        popd;
    }
    if ($config -eq "ps")
    {
        chezmoi edit Documents/PowerShell/Microsoft.PowerShell_profile.ps1;
        chezmoi apply;
        .$PROFILE;
    }
}

function ffd()
{
    fd -d 1 -t d -u . $env:dev $env:dev/alerts-server | fzf | cd
}

function hdir([string]$new_dir)
{
    mkdir $new_dir;
    cd $new_dir;
}

# Git pull nvim config
function gitnvim([string]$cmd)
{
    git -C $env:LOCALAPPDATA/nvim $cmd
}

function which([string]$cmd)
{
    (Get-Command $cmd | Format-Table -HideTableHeaders | Out-String).Trim()
}

function wf()
{
    if (Test-Path wails.json && Test-Path frontend)
    {
        cd frontend
        npm run dev
    }
}

function y()
{
    $tmp = [System.IO.Path]::GetTempFileName()
    yazi $args --cwd-file="$tmp"
    $cwd = Get-Content -Path $tmp
    if (-not [String]::IsNullOrEmpty($cwd) -and $cwd -ne $PWD.Path)
    {
        Set-Location -LiteralPath $cwd
    }
    Remove-Item -Path $tmp
}

# Terminal Icons
# Import-Module Terminal-Icons
function ll
{
    exa -la --icons --group-directories-first --git
}

$docs = [Environment]::GetFolderPath("MyDocuments")
. "$docs\PowerShell\zoxide.ps1"

# Aliases
Set-Alias touch ni
Set-Alias grep findstr
Set-Alias lg lazygit
Set-Alias ex explorer
Set-Alias vim nvim
# del alias:diff -Force
# Set-Alias diff 'C:\Program Files\Git\usr\bin\diff.exe'
