overlay-custom-nixpkgs:
{ config, pkgs, lib, nixpkgs, ... }: {

  nixpkgs.overlays = [ overlay-custom-nixpkgs ];

  boot.blacklistedKernelModules = [ "pcspkr" ];

  nix = {
    #    packages = pkgs.nixUnstable;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  networking.dhcpcd.wait = "background";
  systemd.services.systemd-udev-settle.enable = false;

  services.openssh.enable = true;

  zramSwap = {
    enable = true;
    algorithm = "zstd";
  };

  time.timeZone = "Europe/Berlin";
  #  time.timeZone = "Africa/Nairobi";
  #  time.timeZone = "Asia/Jakarta";
  #  time.timeZone = "Asia/Makassar";

  users.defaultUserShell = pkgs.zsh;
  programs.zsh = { enable = true; };

  # Don't forget to set a password with ‘passwd’.
  users.users = {
    robert = {
      isNormalUser = true;
      extraGroups = [
        "wheel"
        "docker"
        "networkmanager"
        "video"
        "input"
        "btaudio"
        "audio"
        "pipewire"
      ];
    };
  };

  nixpkgs.config.allowUnfree = true;
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    bind
    nano
    bash
    neofetch
    killall
    cryptsetup
    pstree
    perl
    curl
    htop
    zsh
    git
    oh-my-zsh
    rsync
    ncdu
    bc
    zip
    unzip
    unrar
    mosh
    usbutils
    lsof
    fdupes
    jdupes
    iotop
    iotop-c
    kitty
  ];
}
