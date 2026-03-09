{ config, pkgs, lib, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.configurationLimit = 4;

  networking.hostName = "nixos"; # Define your hostname.
  networking.networkmanager.enable = true;
  
  time.timeZone = "Europe/Amsterdam";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "nl_NL.UTF-8";
    LC_IDENTIFICATION = "nl_NL.UTF-8";
    LC_MEASUREMENT = "nl_NL.UTF-8";
    LC_MONETARY = "nl_NL.UTF-8";
    LC_NAME = "nl_NL.UTF-8";
    LC_NUMERIC = "nl_NL.UTF-8";
    LC_PAPER = "nl_NL.UTF-8";
    LC_TELEPHONE = "nl_NL.UTF-8";
    LC_TIME = "nl_NL.UTF-8";
  };

  services.xserver.enable = true;

  # Use GNOME (For now...)
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };
  
  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.philippe = {
    isNormalUser = true;
    description = "Philippe";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      gh
      ghostty
      starship
      vscode
    ];
  };

  # Install firefox.
  programs.firefox.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # System packages (for all users)
  environment.systemPackages = with pkgs; [
    htop
    git
    tmux
    vim
    bat
    ripgrep
    fzf
    fd
    fastfetch
    python3
  ];

  system.stateVersion = "25.11"; # Did you read the comment?

  services.openssh = {
    enable = true;
    settings = {
      X11Forwarding = true;
      PermitRootLogin = "no";
    };
    openFirewall = true;
  };
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # VMWare Guest tools (if running in vm) 
  virtualisation.vmware.guest.enable = true;

  # Disable firewall
  networking.firewall.enable = false;

  # dconf settings
  programs.dconf.profiles.user.databases = [
    {
      settings = {
        "org/gnome/desktop/session" = {
          idle-delay = lib.gvariant.mkUint32 0;
        };

        "org/gnome/desktop/screensaver" = {
          lock-enabled = false;
          lock-delay = lib.gvariant.mkUint32 0;
        };

        "org/gnome/settings-daemon/plugins/power" = {
          sleep-inactive-ac-type = "nothing";
          sleep-inactive-ac-timeout = lib.gvariant.mkUint32 0;

          sleep-inactive-battery-type = "nothing";
          sleep-inactive-battery-timeout = lib.gvariant.mkUint32 0;
        };

      };
    }
  ];
  
}
