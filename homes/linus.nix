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
    vadimcn.vscode-lldb
    ms-azuretools.vscode-docker
    github.vscode-pull-request-github
    bbenoist.nix
    arrterian.nix-env-selector
    jnoortheen.nix-ide
    esbenp.prettier-vscode
    equinusocio.vsc-material-theme
    ms-vscode.cpptools
    denoland.vscode-deno
  ];

  packages = with pkgs; [
    tree
    fd
    gh
    arduino
    gnome-browser-connector
    lynx
    nerdfonts
    arduino-cli
    nmap
    ripgrep
    arduino-ide
    cmatrix
    nextcloud-client
    prismlauncher
    firefox
    thunderbird
    vlc
    sl
    steam
    gcc
    signal-desktop
    nil
    swift
    swiftPackages.swiftpm
    sourcekit-lsp
    deno
  ];
in
{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "linus";
  home.homeDirectory = "/home/linus";

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
  programs.gnome-terminal = {
    enable = true;
    themeVariant = "dark";
    profile = {
      "3016dd0f-599a-4b27-a5af-dba92550fe79" = {
        allowBold = true;
	visibleName = "zsh";
	audibleBell = true;
	default = true;
	font = "CaskaydiaCove Nerd Font";
      };
      "4a348826-f5d3-4034-bd42-2efddf71f816" = {
        allowBold = true;
	visibleName = "bash";
	audibleBell = true;
	font = "CaskaydiaCove Nerd Font";
	customCommand = "bash";
      };
    };
  };

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  programs.neovim = {
    enable = true;
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
    };
    keybindings = [
      {
        "key" = "ctrl+[Semicolon]";
        "command" = "workbench.action.terminal.toggleTerminal";
      }
    ];
    extensions = code-exts;
  };
  programs.oh-my-posh = {
    enable = false;
    enableZshIntegration = true;
    settings = pkgs.lib.fileContents (pkgs.writeText "libewa.omp.json" (builtins.fetchurl "https://gist.githubusercontent.com/libewa/bdeb367aea920128fc19eeba0f83f5c2/raw/ae74d3bdf1e5394f4d9ff6c19c8f3204e41ca030/libewa.omp.json"));
  };
}