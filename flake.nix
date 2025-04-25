{
  description = "NixOS VMWare VM Configuration";

  inputs = {
    # Pin NixOS packages to a specific stable release
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix.url = "github:Mic92/sops-nix";
  };

  outputs = { nixpkgs, nixpkgs-unstable, home-manager, sops-nix, ... }:
    let
      system = "aarch64-linux";
      unstablePkgs = import nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
      };
    in {
      nixosConfigurations.nixos-vm = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux"; # M Mac's VMWare Fusion VM
        modules = [
          # Load the main system configuration file
          ./configuration.nix
          ./hardware-configuration.nix
          sops-nix.nixosModules.sops

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "backup";
            home-manager.extraSpecialArgs = { inherit unstablePkgs; };
            home-manager.sharedModules = [ sops-nix.homeManagerModules.sops ];
            home-manager.users.bogdan = ./home.nix;
          }
        ];
      };
    };
}
