# Prompt
$env:STARSHIP_CONFIG = "$HOME\.config\starship\starship.toml"
Invoke-Expression (&starship init powershell)
$prompt = ""
function Invoke-Starship-PreCommand
{
    $current_location = $executionContext.SessionState.Path.CurrentLocation
    if ($current_location.Provider.Name -eq "FileSystem")
    {
        $ansi_escape = [char]27
        $provider_path = $current_location.ProviderPath -replace "\\", "/"
        $prompt = "$ansi_escape]7;file://${env:COMPUTERNAME}/${provider_path}$ansi_escape\"
    }
    $host.ui.Write($prompt)
}

Set-PSReadLineOption -EditMode Emacs

# ReadLine handlers
Set-PSReadLineKeyHandler -Chord UpArrow -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Chord DownArrow -Function HistorySearchForward

Set-PSReadLineKeyHandler -Chord Ctrl+p -ScriptBlock {
    $cons=[Microsoft.PowerShell.PSConsoleReadLine]
    $cons::SetMark()
    $cons::HistorySearchBackward()
    $cons::EndOfLine()
}
Set-PSReadLineKeyHandler -Chord Ctrl+n -ScriptBlock {
    $cons=[Microsoft.PowerShell.PSConsoleReadLine]
    $cons::SetMark()
    $cons::HistorySearchForward()
    $cons::EndOfLine()
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
        chezmoi edit ~/Documents/PowerShell/Microsoft.PowerShell_profile.ps1;
        chezmoi apply;
        .$PROFILE;
    }
}

function which([string]$cmd)
{
    (Get-Command $cmd | Format-Table -HideTableHeaders | Out-String).Trim()
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

# Check for modules
function Get-ModuleInstalled([string]$module)
{
    if (Get-Module -ListAvailable -Name $module)
    {
        return $true
    }
    return $false
}

# Terminal Icons
if (Get-ModuleInstalled("Terminal-Icons"))
{
    Import-Module Terminal-Icons
}

if (!(Get-ModuleInstalled("posh-alias")))
{
    Write-Host "posh-alias not installed!"
    Write-Host "Installing ..."
    Install-PSResource -Name posh-alias
}

$docs = [Environment]::GetFolderPath("MyDocuments")
. "$docs\PowerShell\zoxide.ps1"

# Aliases
Set-Alias touch ni
Set-Alias grep findstr
Set-Alias lg lazygit
Set-Alias ex explorer
Set-Alias vim nvim
Add-Alias gs "git status -s -b --show-stash"
Add-Alias ll "exa -la --icons --group-directories-first --git"
Add-Alias ffd 'fd -d 1 -t d -u . $env:DEV.split(";") | fzf | cd'
# del alias:diff -Force
# Set-Alias diff 'C:\Program Files\Git\usr\bin\diff.exe'
