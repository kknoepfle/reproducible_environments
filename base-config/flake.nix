{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-23.05";
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    qcow2_imp = {
      url = "../modules/qcow2.nix";
      flake = false;
    };
  };
  outputs = { self, nixpkgs, nixos-generators, qcow2_imp, ... }: 
  {
    packages.x86_64-linux = {
      vbox = nixos-generators.nixosGenerate {
        system = "x86_64-linux";
        format = "virtualbox";
      };
      qemu = nixos-generators.nixosGenerate {
        system = "x86_64-linux";
        format = "qcow2";
        customFormats = { qcow2 = qcow2_imp; };
      };
      hyperv = nixos-generators.nixosGenerate {
        system = "x86_64-linux";
        format = "hyperv";
      };
      default = self.packages.x86_64-linux.vbox;
    };
    packages.x86_64-darwin = {
      vbox = nixos-generators.nixosGenerate {
        system = "x86_64-linux";
        format = "virtualbox";
      };
      qemu = {
        system = "x86_64-linux";
        format = "qcow";
      };
      default = self.packages.x86_64-darwin.vbox;
    };
    packages.aarch64-darwin = {
      qemu = {
        system = "aarch64-linux";
        format = "qcow";
      };
      default = self.packages.x86_64-darwin.qemu;
    };
  };
}