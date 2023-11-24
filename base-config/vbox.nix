let
  vars = import ./vars.nix;
  image-config = import ./src/image-config.nix;
  pkgs = vars.os.pkgs;

  vbox = { config, modulesPath, pkgs, lib, ... }: {

    imports = [
      "${toString modulesPath}/virtualisation/vmware-guest.nix"
    ];

    system.build.image = import <nixpkgs/nixos/lib/make-disk-image.nix> {
      additionalSpace = vars.vm.disk_size;
      format = "vdi";
      contents = image-config.contents;
      configFile = image-config.configFile;
      inherit config lib pkgs;
    };

  };

  nixosEvaluation = pkgs.nixos [
    vbox
    ./src/nixos-config.nix
  ];

in

nixosEvaluation.config.system.build.image