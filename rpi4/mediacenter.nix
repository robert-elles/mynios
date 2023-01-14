{ lib, pkgs, ... }:
let
  # kodi_neu = pkgs.kodi.overrideAttrs (old: {
  #   postInstall = old.postInstall + ''
  #     wrapProgram $out/bin/kodi --set PULSE_SERVER ""
  #   '';
  # });
  kodi_with_pkgs = pkgs.kodi.withPackages (p: with p; [ netflix youtube arteplussept ]);
  kodi_wrapped = pkgs.writeShellScriptBin "kodi" ''
    PULSE_SERVER="" ${kodi_with_pkgs}/bin/kodi $@
  '';
in
{

  # boot.plymouth.enable = true;
  # boot.plymouth.theme = "breeze";

  services.xserver.enable = true;
  services.xserver.displayManager.autoLogin.user = "robert";
  services.xserver.displayManager.autoLogin.enable = true;

  # xfce
  # services.xserver.displayManager.defaultSession = "kodi";
  services.xserver.desktopManager.xfce.enable = false;

  # kde
  # services.xserver.displayManager.sddm.enable = true;
  # services.xserver.desktopManager.plasma5.enable = true;

  # kodi # set PULSE_SERVER="" kodi-bin to work with pipewire-pulse
  services.xserver.desktopManager.kodi.enable = true;
  # services.xserver.desktopManager.kodi.package = pkgs.kodi-wayland;
  # services.xserver.desktopManager.kodi.package = pkgs.kodi.withPackages (p: with p; [ netflix youtube arteplussept ]);
  services.xserver.desktopManager.kodi.package = kodi_wrapped;

  # /nix/store/1kziba96p3a645zkznm86z9wh3lnwqp1-kodi-19.5-env/bin/kodi
  nixpkgs.overlays = [
    # (final: prev: {
    #   kodi = prev.writeShellScriptBin "kodi" ''
    #     PULSE_SERVER="" ${prev.kodi}/bin/kodi $@
    #   '';
    # })
    # (final: prev: {
    #   kodi = kodi_neu;
    # })
  ];

  # programs.kdeconnect.enable = true;

  # environment.systemPackages = with pkgs; [
  # widevine-cdm
  # chromium
  # firefox
  # ];
}
