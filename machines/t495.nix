# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
{ config, lib, pkgs, modulesPath, ... }: {
  imports = [
    (import ../nixconfig/fprint-laptop-service)
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  networking.hostName = "panther";

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.05"; # Did you read the comment?

  # fingerprint reader
  services.fprintd.enable = false;
  services.fprint-laptop-lid.enable = false;

  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.initrd.availableKernelModules =
    [ "nvme" "ehci_pci" "xhci_pci" "usb_storage" "sd_mod" "sdhci_pci" ];
  #  boot.initrd.kernelModules = [ ];
  boot.initrd.kernelModules = [ "kvm-amd" "amdgpu" ];
  #  boot.kernelParams = [ "amd_iommu=pt" "ivrs_ioapic[32]=00:14.0" "iommu=soft" ];
  #  boot.kernelParams = [ "amd_iommu=pt" "iommu=soft" ];
  boot.extraModulePackages = [ ];
  #  boot.kernelParams = ["acpi_backlight=vendor"];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/73ccb115-5243-445c-8d3e-5b194fb48428";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/B291-CDF1";
    fsType = "vfat";
  };

  swapDevices = [ ];

  services.xserver.videoDrivers = [ "amdgpu" ]; # amdgpu{-pro}, modesetting, radeon ];
  # services.xserver.videoDrivers = [ "amdgpu" ];
  hardware.cpu.amd.updateMicrocode = true;
  hardware.opengl.driSupport = true;
  # For 32 bit applications
  # hardware.opengl.driSupport32Bit = true;
  # hardware.opengl.extraPackages32 = with pkgs; [ driversi686Linux.amdvlk ];

  hardware.opengl = {
    enable = true;
    extraPackages = with pkgs; [
      vaapiVdpau
      amdvlk
      libvdpau-va-gl
      rocm-opencl-icd
      rocm-opencl-runtime
      mesa
      vulkan-loader
    ];
  };

  # radv is mesa's amd driver and replaces amdvlk/radeon
  # environment.variables.AMD_VULKAN_ICD = "RADV";
  # environment.variables.AMD_VULKAN_ICD = "AMDVLK";

  # networking.interfaces.enp3s0f0.useDHCP = true;
  # networking.interfaces.enp4s0.useDHCP = true;
  # networking.interfaces.wlp1s0.useDHCP = true;
  #networking.wireless.interfaces = ["wlp1s0"];

}
