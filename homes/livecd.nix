{ config, pkgs, ... }:

let
  vimplugins = with pkgs.vimPlugins; [
    conflict-marker-vim
    nvim-treesitter.withAllGrammars
    lspkind-nvim
    neogit
    cmp-nvim-lsp
    telescope-github-nvim
    telescope-nvim
    telescope-symbols-nvim
    todo-comments-nvim
    plenary-nvim
    nvim-lspconfig
    which-key-nvim
    trouble-nvim
    nvim-cmp
    vim-vsnip
    cmp-vsnip
  ];

  code-exts = with pkgs.vscode-extensions; [
    bbenoist.nix
    arrterian.nix-env-selector
    jnoortheen.nix-ide
    esbenp.prettier-vscode
    equinusocio.vsc-material-theme
    denoland.vscode-deno
  ];

  packages = with pkgs; [
    tree
    lynx
    cmatrix
    thunderbird
    vlc
    sl
    nil

    hyprlock
    hypridle
    dolphin
    swayosd
    swaynotificationcenter
    udiskie

    (pkgs.writeShellScriptBin "exitwindow" ''
    if [ "$(hyprctl activewindow -j | jq -r ".class")" = "Steam" ]; then
      xdotool getactivewindow windowunmap
    else
      hyprctl dispatch killactive ""
    fi
    '')
  ];
in
{
  imports = [
    ./hyprland.nix
    ./waybar.nix
  ];
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "nixos";
  home.homeDirectory = "/home/nixos";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.05"; # Please read the comment before changing.
  nixpkgs.config.allowUnfree = true;

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autocd = true;
    initExtraFirst = "

    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias egrep='egrep --color=auto'
    alias la='ls -al --color=auto'
    alias ll='ls -l --color=auto'
    alias nrs='nixos-rebuild switch'
    alias hms='home-manager switch'
    ";
    syntaxHighlighting = {
      enable = true;
      highlighters = [ "brackets" "main" ];
    };
    plugins = [
      {
        name = "zsh-nix-shell";
        file = "nix-shell.plugin.zsh";
        src = pkgs.fetchFromGitHub {
          owner = "chisui";
          repo = "zsh-nix-shell";
          rev = "v0.7.0";
          sha256 = "149zh2rm59blr2q458a5irkfh82y3dwdich60s9670kl3cl5h2m1";
        };
      }
    ];
  };
  home.packages = packages;

  home.file = {
    hypr = {
      target = ".config/hypr";
      source = ../dotfiles/hypr;
    };
  };
  programs.rofi = {
    enable = true;
    terminal = "\${pkgs.kitty/bin/kitty}";
    extraConfig = {
      combi-modes = "window,drun,run";
      modes = "combi";
    };
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    plugins = vimplugins;
    extraConfig = ''
      set mouse=a
    '';
  };
  targets.genericLinux.enable = true;
  xdg.mime.enable = true;
  xdg.systemDirs.data = [ "${config.home.homeDirectory}/.nix-profile/share/applications" ];
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    userSettings = {
      "workbench.colorTheme" = "Material Theme High Contrast";
      "workbench.iconTheme" = "eq-material-theme-icons-light";
      "nix.serverPath" = "nil";
      "nix.enableLanguageServer" = true;
      "git.enableSmartCommit" = true;
      "git.confirmSync" = false;
      "git.autofetch" = true;
    };
    keybindings = [
      {
        "key" = "ctrl+[Semicolon]";
        "command" = "workbench.action.terminal.toggleTerminal";
      }
    ];
    extensions = code-exts;
  };
}
