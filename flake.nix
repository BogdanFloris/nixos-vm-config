{
  description = "NixOS VMWare VM Configuration";

  inputs = {
    # Pin NixOS packages to a specific stable release
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
  };

  outputs = { self, nixpkgs, ... }@inputs: {
    # Define a NixOS configuration named 'nixos-vm'
    nixosConfigurations.nixos-vm = nixpkgs.lib.nixosSystem {
      system = "aarch64-linux"; # M Mac's VMWare Fusion VM
      specialArgs = { inherit inputs; }; # Pass flake inputs to modules
      modules = [
        # Load the main system configuration file
        ./configuration.nix
        # We will add ./hardware-configuration.nix here later
      ];
    };
  };
}
