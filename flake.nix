{
  description = "NixOS VMWare VM Configuration";

  inputs = {
    # Pin NixOS packages to a specific stable release
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      ...
    }@inputs:
    {
      # Define a NixOS configuration named 'nixos-vm'
      nixosConfigurations.nixos-vm = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux"; # M Mac's VMWare Fusion VM
        specialArgs = { inherit inputs; }; # Pass flake inputs to modules
        modules = [
          home-manager.nixosModules.home-manager

          # Load the main system configuration file
          ./configuration.nix
          ./hardware-configuration.nix
        ];
      };
    };
}
