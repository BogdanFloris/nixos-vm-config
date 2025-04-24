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
    extraGroups = [ "wheel" "docker" ]; # Enable sudo
  };

  security.sudo.wheelNeedsPassword = false;

  # Setup QEMU so we can run x86_64 binaries
  boot.binfmt.emulatedSystems = [ "x86_64-linux" ];

  # Virtualisation settings
  virtualisation.docker.enable = true;
  virtualisation.lxd = { enable = true; };

  services.xserver = {
    enable = true;
    xkb.layout = "us";
    dpi = 220;
    autoRepeatDelay = 250;
    autoRepeatInterval = 30;

    desktopManager = {
      xterm.enable = false;
      wallpaper.mode = "fill";
    };

    # Enable the LightDM display manager (graphical login screen)
    displayManager = { lightdm.enable = true; };

    # Enable the i3 window manager session
    windowManager.i3 = { enable = true; };
  };

  services.displayManager.defaultSession = "none+i3";

  services.libinput.enable = true;

  fonts.packages = with pkgs; [ hack-font jetbrains-mono fira-code ];

  environment.systemPackages = with pkgs; [
    git
    vim
    wget
    curl
    htop
    i3status
    dmenu
    cachix
    gnumake
    killall
    niv
    man-pages
    # For hypervisors that support auto-resizing, this script forces it.
    # I've noticed not everyone listens to the udev events so this is a hack.
    (writeShellScriptBin "xrandr-auto" ''
      xrandr --output Virtual-1 --auto
    '')

    # VMware Guest Additions
    open-vm-tools
  ];

  virtualisation.vmware.guest.enable = true;

  # Share the host's filesystem with the VM
  fileSystems."/home/bogdan/host" = {
    device = ".host:/host"; # Mount the specific share named "host"
    fsType = "fuse./run/current-system/sw/bin/vmhgfs-fuse";
    options = [
      "defaults" # Use default mount options
      "allow_other" # IMPORTANT: Allow non-root user access
      "auto_unmount" # Unmount if host connection lost/share removed
      "uid=1000"
      "gid=1000"
      "umask=022" # Set default file permissions (rw-r--r--)
    ];
  };

  nix = {
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  # Disable the firewall for simplicity in a VM environment
  networking.firewall.enable = false;

  # Enable necessary services
  services = {
    openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = false;
        PermitRootLogin = "no";
      };
    };
  };

  nixpkgs.config.allowUnfree = true;
  system.stateVersion = "24.11";

}
