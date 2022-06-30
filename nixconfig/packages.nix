{ config, pkgs, lib, ... }: {

  #    pkgs.anki-bin.overrideAttrs

  # tilt overlay for latest version
  nixpkgs.overlays = [
    (self: super: {
      tilt = (super.tilt.override {
        buildGoModule = pkgs.buildGo118Module;
      }).overrideAttrs (old: rec {
        version = "0.30.4";
        src = super.fetchFromGitHub {
          owner = "tilt-dev";
          repo = "tilt";
          rev = "v${version}";
          #          sha256 = lib.fakeSha256;
          sha256 = "sha256-AdT3qL0frsTi4R4AbmZlPDx0Q2RixC3e4AyEMgGgnlc=";
        };
        ldflags = [ "-X main.version=${version}" ];
      });
    })
    #    (self: super: {
    #      zoomUsFixed = pkgs.zoom-us.overrideAttrs (old: {
    #        postFixup = old.postFixup + ''
    #          wrapProgram $out/bin/zoom-us --unset XDG_SESSION_TYPE
    #        '';
    #      });
    #      zoom = pkgs.zoom-us.overrideAttrs (old: {
    #        postFixup = old.postFixup + ''
    #          wrapProgram $out/bin/zoom --unset XDG_SESSION_TYPE
    #        '';
    #      });
    #    })
    (final: prev: {
      chromium = prev.writeShellScriptBin "chromium" ''
        LD_LIBRARY_PATH="${
          prev.lib.makeLibraryPath [ prev.vulkan-loader ]
        }:$LD_LIBRARY_PATH" ${prev.chromium}/bin/chromium $@
      '';
    })
    #    (final: prev: {
    #      chromium = prev.chromium.overrideAttrs (old: {
    #        postInstall = ''
    #          wrapProgram $out/bin/chromium \
    #              --prefix LD_LIBRARY_PATH : "${
    #                lib.makeLibraryPath [ prev.vulkan-loader ]
    #              }"
    #        '';
    #      });
    #    })
  ];

  environment.defaultPackages = with pkgs; [ keepassxc ];

  environment.systemPackages = with pkgs; [
    nixfmt
    vlang
    sshfs
    networkmanager
    inetutils
    wireguard-tools
    rofi # Window switcher, run dialog and dmenu replacement
    arc-theme # gtk theme
    lxappearance # set gtk themes
    kde-gtk-config # should set kde themes
    xarchiver
    gnome.file-roller
    cbatticon
    gitAndTools.gitFull
    # Foto
    imagemagick
    exiftool
    mariadb
    libraw
    digikam
    darktable
    geeqie
    glxinfo
    nvtop-amd

    ranger
    handlr # set default applications
    gparted
    polkit_gnome # polkit authentication agent
    feh

    # Audio
    pamixer
    pulseaudio # needed for pactl
    easyeffects
    helvum # patchbay for pipewire
    pavucontrol
    playerctl
    audio-recorder
    audacity

    nmap
    mpv
    gnome.gnome-clocks
    rxvt-unicode
    kitty
    dunst
    openvpn
    p7zip
    hydra-check
    #    typora # markdown editor
    auto-cpufreq
    xorg.xev
    light
    apostrophe # markdown editor
    #    wine
    winetricks
    wineWowPackages.stable
    bottles
    gnome.gnome-screenshot
    libsecret
    gnome.gnome-keyring
    gnome.libgnome-keyring
    xorg.xbacklight
    xfce.xfce4-pulseaudio-plugin
    xfce.thunar
    xfce.xfconf # Needed to save the preferences
    xfce.exo
    xfce.thunar-archive-plugin
    xfce.xfce4-i3-workspaces-plugin
    xfce.xfce4-panel
    xfce.xfce4-notifyd
    xfce.xfce4-battery-plugin
    xfce.xfce4-power-manager
    # Development
    tilt
    #    ctlptl
    glab # gitlab cli
    jdk11
    steam-run # run non-nixos compatible binaries
    nodejs-14_x
    maven
    gradle
    docker
    docker-compose
    dive
    pipenv
    python38Packages.pip
    python39Full
    vscode
    kube3d
    pinta
    postman
    google-cloud-sdk
    kubectl
    kustomize
    smartgithg
    ytt
    direnv

    dbeaver
    #    anki-bin
    vulkan-tools
    vulkan-loader
    vulkan-headers
    vulkan-validation-layers
    mr
    libva-utils
    vdpauinfo
    radeontop
    arandr
    autorandr
    plasma-pa
    firefox
    joplin-desktop
    #    unstable.chromium
    chromium
    #    unstable.zoom-us
    zoom-us
    vlc
    spotify
    transmission-gtk
    blueberry
    #    jetbrains.jdk
    #    jetbrains.idea-ultimate
    (jetbrains.idea-ultimate.override { jdk = pkgs.jetbrains.jdk; })
    nextcloud-client
    networkmanagerapplet
    captive-browser
    libreoffice-fresh
    evince
    gnome.gedit
    multipath-tools # kpartx -av some_image.img creates device files that can be mounted
    chiaki
    tdrop
    colmena
    pkgs-custom.anki-bin
    #     networkmanager_dmenu

    # printing
    hplip
  ];
}
