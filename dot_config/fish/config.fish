if status is-interactive
    alias vim=nvim
    alias ll="eza -la --icons --group-directories-first --git"
    alias lg="lazygit"
    alias gs="git status -s -b --show-stash"

    function y
        set tmp (mktemp -t "yazi-cwd.XXXXXX")
        yazi $argv --cwd-file="$tmp"
        if read -z cwd < "$tmp"; and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
            builtin cd -- "$cwd"
        end
        rm -f -- "$tmp"
    end

    set -gx STARSHIP_CONFIG ~/.config/starship/starship.toml
    starship init fish | source
    zoxide init fish | source
    echo -e "\e[34m
        ▒▒
        ▒▒▒            ▒▓
       ▒▒▒▒▒▒       ▒▓▓▓▓
       ▒▒▒▒▒▒▒    ▒▓▓▓▓▓▒      ▒▒▒▒▒▒▒▒▒▒
       ▒▒▒▒▒▒▒▓ ▒▓▓▓▓▓▓▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓
      ▒▒▒▒▒▒▓▒▒▓▓▓▓▓▓▓▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓▒
      ▒▒▒▒▒▒▓▒▒▓▓▓▓▓▒▒▒▒▒▓▒▒▒▒▒▒▒▒▒▒▓▒  ▒▒
       ▓▒▒▒▒▓▓▒▓▓▓▒▒▒▒▓▓▓▒▒▒▒▒▒▒▒▒▓▓▓▓▓▓▓▓▒▒
        ▒▒▓▓▒▓▓▓▓▓▓▓▓▓▓▒▒▒▒▒▒▒▒▒▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▒
         ▒▓▓▓▓▓▓▓▓▓▓▓▓▓▒▒▒▒▒▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▒
           ▒▓▓▓▓▓▓▓▓▓▓▒▓▓▓▓▓▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
       ▒▒▒▒▒▒▒▒▒▒▒▒▓▓▓▓▓▓▓▓▓▓▓▓▓▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
     ▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓▓▓▓▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
   ▒▓▒▒▒▓▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓▓▒▓▒▒▒▒▒▒▒▒▒▒▒▒▓▒▒
   ▓▒▒▒▒▒▒▓▓▓▓▒▒▓▓▒▒▒▒▒▒▒▒   ▒▒▒▒▒▒▒▒▒▒
  ▒▒▒▒▒▒▒▒▓▒▒▓▒▒▒▒▒▒▒▒▒▒▒▓
   ▒▒▒▒▒▒▒▓▒▓▒▒▒▒▒▒▒▒▒▒▒▒▓
    ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓
     ▒▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓
       ▒▓▓▓▒▒▒▒▒▒▒▒▒▒▒▓▒
      ▒▓▓▓▓▓▒▒▒▓▓▓▓▓▒
     ▒▓▓▓▓▓▓   ▓▓▓▓▓▒
     ▒▓▓▓▓▓▒  ▓▓▓▓▓▓▓
      ▒▒▒▒    ▓▓▓▓▓▓▒
              ▒▓▒▒▓▒\e[0m
    "
end
