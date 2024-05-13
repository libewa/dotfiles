{
  description = "NixOS config flake";

  inputs = {
    nixos-boot.url = "github:Melkor333/nixos-boot";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    cdpkgs.url = "nixpkgs/23.11";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, cdpkgs, ... }@inputs: {
    nixosConfigurations = {
      yoga = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs; };
        modules = [
          ./hosts/yoga/configuration.nix
          ./modules/grub.nix
          ./hardware-configuration.nix
          ./modules/appimage.nix
          ./modules/audio.nix
          ./modules/germanlocale.nix
          ./modules/essentialpkgs.nix
          inputs.home-manager.nixosModules.default
          inputs.nixos-boot.nixosModules.default
        ];
      };
      livecd = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/livecd/configuration.nix
          ./modules/appimage.nix
          ./modules/audio.nix
          ./modules/essentialpkgs.nix

          "${inputs.cdpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
          "${inputs.cdpkgs}/nixos/modules/installer/cd-dvd/channel.nix"
        ];
      };
      livedisc-de = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/livecd/configuration.nix
          ./modules/appimage.nix
          ./modules/audio.nix
          ./modules/essentialpkgs.nix
          ./modules/germanlocale.nix

          "${cdpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
          "${cdpkgs}/nixos/modules/installer/cd-dvd/channel.nix"
        ];
      };
    };
  };
}
