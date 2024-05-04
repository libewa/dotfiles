{ pkgs, ... }:

{
  virtualisation.libvirtd.enable = true;
  virtualisation.virtualbox.host.enable = true;
  programs.dconf.enable = true; # virt-manager requires dconf to remember settings
  environment.systemPackages = with pkgs; [
    virt-manager
    vscodium
    firefox
    pv
    prusa-slicer
    efibootmgr
    
    kitty
    hyprnome
    dolphin
    hyprlock
    hypridle
    swayosd
    swaynotificationcenter
    udiskie
    notify-desktop
    rofi-power-menu
  ];
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  };
  hardware.opengl.driSupport32Bit = true;
  programs.hyprland.enable = true;
}

