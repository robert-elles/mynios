{ pkgs, ... }:
# let
#   sddm-chili-theme = pkgs.stdenv.mkDerivation rec {
#     pname = "kde-plasma-chili";
#     version = "0.5.5";
#     dontBuild = true;
#     installPhase = ''
#       mkdir -p $out/share/sddm/themes
#       cp -aR $src $out/share/sddm/themes/chili
#     '';
#     src = pkgs.fetchFromGitHub {
#       owner = "MarianArlt";
#       repo = "${pname}";
#       rev = "${version}";
#       sha256 = "fWRf96CPRQ2FRkSDtD+N/baZv+HZPO48CfU5Subt854=";
#     };
#   };
# in
{
  services.desktopManager.plasma6.enable = true;
  services.xserver = {
    enable = true;
    # desktopManager.plasma5.enable = true;
    # desktopManager.lxqt.enable = true;
    displayManager = {
      sddm = {
        enable = true;
        theme = "chili";
        wayland.enable = true;
      };
      defaultSession = "plasma";
      # defaultSession = "plasma";
    };
  };

  boot.plymouth.theme = "breeze";

  programs.kdeconnect.enable = true;

  security.pam.services.robert.enableKwallet = true;

  xdg.portal.enable = true;
  # xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-kde pkgs.xdg-desktop-portal-gtk ];

  # services.xserver.libinput = {
  #   enable = true;
  #   touchpad = {
  #     accelProfile = "flat";
  #     accelSpeed = "1";
  #   };
  #   mouse = { accelSpeed = "1.2"; };
  # };
  #services.xserver.libinput.mouse.accelProfile = adaptive;
  services.unclutter.enable = true;

  # environment.systemPackages = with pkgs.libsForQt5; [
  environment.systemPackages = with pkgs.kdePackages; [
    #    krohnkite
    #    bismuth
    plasma-browser-integration
    ksshaskpass
    # kdeconnect-kde
    #    yakuake
    kde-cli-tools
    ksystemlog
    breeze-plymouth
    dolphin-plugins
    # kmix # plasma-pa instead
    plasma-pa
    kdenlive # video editor
    # kpipewire
    kdeplasma-addons
    breeze-plymouth
    elisa
    plasma-vault
    powerdevil
    kmail
    # sddm-kcm # sddm settings module
    # sddm-chili-theme
    pkgs.sshfs-fuse
    pkgs.sshfs
    pkgs.sftpman
  ];

  networking.firewall.allowedUDPPortRanges = [{
    from = 1714;
    to = 1764;
  }];
  networking.firewall.allowedTCPPortRanges = [{
    from = 1714;
    to = 1764;
  }];
}
