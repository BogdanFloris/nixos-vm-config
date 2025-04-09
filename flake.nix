{
  description = "NixOS VMWare VM Configuration";

  inputs = {
    # Pin NixOS packages to a specific stable release
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";

    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      ...
    }:
    {
      # Define a NixOS configuration named 'nixos-vm'
      nixosConfigurations.nixos-vm = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux"; # M Mac's VMWare Fusion VM
        modules = [
          # Load the main system configuration file
          ./configuration.nix
          ./hardware-configuration.nix

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "backup";
            home-manager.users.bogdan = ./home.nix;
          }
        ];
      };
    };
}
