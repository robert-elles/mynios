{
  description = "Robert's NixOs flake configuration";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-utils.url = "github:numtide/flake-utils";
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    impermanence = { url = "github:nix-community/impermanence"; };
    # mynixos-private = {
    #   url = "git+ssh://git@github.com/robert-elles/mynixos-private";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
  };

  outputs = { self, nixpkgs, nixos-hardware, agenix, impermanence, home-manager, ... }@inputs:
    let
      system_repo_root = "/home/robert/code/mynixos";
      system_x86 = "x86_64-linux";
      patchedPkgs = nixpkgs.legacyPackages.x86_64-linux.applyPatches {
        name = "nixpkgs-patched";
        src = nixpkgs;
        patches = [
          # ./patches/chromium_vulkan_loader.patch
          # ./patches/0001-add-vulkan-loader-to-LD_LIBRARY_PATH-to-enable-vulka.patch
        ];
      };
      nixosSystem = import (patchedPkgs + "/nixos/lib/eval-config.nix");
      common_modules = [
        agenix.nixosModules.default
        ({ ... }: {
          environment.systemPackages = [ agenix.packages.${system_x86}.default ];
          environment.sessionVariables.FLAKE = "${system_repo_root}";
          # After that you can refer to the system version of nixpkgs as <nixpkgs> even without any channels configured.
          # Also, legacy package stuff like the ability to do nix-shell -p netcat just works.
          nix.nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];
          environment =
            {
              etc = {
                "nix/channels/nixpkgs".source = nixpkgs;
                "nix/channels/home-manager".source = home-manager;
              };
            };
        })
        ./nixconfig/hosts-blacklist
        (import ./nixconfig/laptop.nix system_repo_root)
        (import ./dotfiles/dotfiles.nix system_repo_root)
        ./nixconfig/common.nix
        ./nixconfig/pyenv.nix
      ];
    in
    {
      nixosConfigurations = {
        panther = nixosSystem {
          system = system_x86;
          specialArgs = inputs;
          modules = common_modules ++ [
            inputs.nixos-hardware.nixosModules.lenovo-thinkpad-t495
            ./machines/t495.nix
          ];
        };
        falcon = nixosSystem {
          system = system_x86;
          specialArgs = inputs;
          modules = common_modules ++ [
            nixos-hardware.nixosModules.dell-xps-13-9360
            ./machines/xps13.nix
          ];
        };
      };
    };
}
