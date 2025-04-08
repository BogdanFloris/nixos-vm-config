{ config, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  # Bootloader configuration (systemd-boot is common for UEFI systems like VMWare on M1)
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true; # Needed for systemd-boot

  networking.useDHCP = true;
  networking.hostName = "nixos-vm";

  time.timeZone = "Europe/Bucharest";

  # Set system locale
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "ro_RO.UTF-8";
    LC_IDENTIFICATION = "ro_RO.UTF-8";
    LC_MEASUREMENT = "ro_RO.UTF-8";
    LC_MONETARY = "ro_RO.UTF-8";
    LC_NAME = "ro_RO.UTF-8";
    LC_NUMERIC = "ro_RO.UTF-8";
    LC_PAPER = "ro_RO.UTF-8";
    LC_TELEPHONE = "ro_RO.UTF-8";
    LC_TIME = "ro_RO.UTF-8";
  };

  # Define a user account.
  users.users.bogdan = {
    isNormalUser = true;
    description = "Bogdan Floris";
    home = "/home/bogdan";
    extraGroups = [ "wheel" ]; # Enable sudo
    # !!! Set a password AFTER installation using 'passwd' command !!!
    # OR generate a hash using `mkpasswd -m sha-512` on a Linux system
    # and uncomment the line below, replacing '...' with the hash.
    # initialHashedPassword = "...";
  };

  environment.systemPackages = with pkgs; [
    git
    vim
    wget
    curl

    # VMware Guest Additions
    open-vm-tools
  ];

  # Enable necessary services
  services = {
    openssh = {
      enable = true;
      settings = {
        # Optional: Disallow password authentication for better security
        # PasswordAuthentication = false;
        # PermitRootLogin = "no"; # Recommended
      };
    };

    # Enable VMware guest tools service
    open-vm-tools.enable = true;
  };

  # Allow unfree packages (needed for some software, maybe VMWare tools if open-vm-tools isn't enough, but start without)
  nixpkgs.config.allowUnfree = true;
  system.stateVersion = "24.11";

}
