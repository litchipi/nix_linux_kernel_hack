{ config, lib, pkgs, ... }: let
  base_linux_version = pkgs.linuxKernel.kernels.linux_latest_libre;
  kernel_custom_config = ''
  '';
  kernel_custom_params = [];
  custom_kernel_module = pkgs.callPackage ./kmodule.nix {};
in
{
  boot = {
    kernelPackages = pkgs.linuxPackagesFor base_linux_version;

    # https://nixos.wiki/wiki/Linux_kernel#Custom_kernel_commandline
    # kernelParams = kernel_custom_params;

    # https://nixos.wiki/wiki/Linux_kernel#Custom_configuration
    # kernelPatches = [ {
    #   name = "custom-config";
    #   patch = null;
    #   extraConfig = kernel_custom_config;
    # } ];

    # extraModulePackages = [ custom_kernel_module ];
  };

  system.stateVersion = "22.11";

  services.getty.autologinUser = "nixos";
  users = {
    users.nixos = {
      password = "nixos";
      group = "nixos";
      isNormalUser = true;
    };
    groups.nixos = {};
  };
}
