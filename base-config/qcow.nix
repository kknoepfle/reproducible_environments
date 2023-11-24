let
  vars = import ./vars.nix;
  image-config = import ./src/image-config.nix;
  pkgs = vars.os.pkgs;

  qcow = { config, modulesPath, pkgs, lib, ... }: {

    imports = [
      "${toString modulesPath}/profiles/qemu-guest.nix"
    ];

    system.build.image = import <nixpkgs/nixos/lib/make-disk-image.nix> {
      additionalSpace = vars.vm.disk_size;
      format = "qcow2-compressed";
      contents = image-config.contents;
      configFile = image-config.configFile;
      inherit config lib pkgs;
    };

  };

  nixosEvaluation = pkgs.nixos [
    qcow
    ./src/nixos-config.nix
  ];

in

nixosEvaluation.config.system.build.image