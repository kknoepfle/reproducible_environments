let
  vars = import ./vars.nix;
  image-config = import ./src/image-config.nix;
  pkgs = vars.os.pkgs;

  hyperv = { config, modulesPath, pkgs, lib, ... }: {

    imports = [
      "${toString modulesPath}/virtualisation/hyperv-guest.nix"
    ];

    virtualisation.hypervGuest.enable = true;

    system.build.image = import <nixpkgs/nixos/lib/make-disk-image.nix> {
      postVM = ''
        ${pkgs.vmTools.qemu}/bin/qemu-img convert -f raw -o subformat=dynamic -O vpc $diskImage $out/nixos.vhd
        rm $diskImage
      '';
      additionalSpace = vars.vm.disk_size;
      format = "raw";
      contents = image-config.contents;
      configFile = image-config.configFile;
      inherit config lib pkgs;
    };

  };

  nixosEvaluation = pkgs.nixos [
    hyperv
    ./src/nixos-config.nix
  ];

in

nixosEvaluation.config.system.build.image