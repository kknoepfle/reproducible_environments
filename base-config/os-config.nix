{ pkgs, ...}:

let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-23.05.tar.gz";
in

{ # Basic Configuration for the OS

  imports =
  [
    (import "${home-manager}/nixos")
  ];

  boot.loader.timeout = 0; # disable bootloader menu

  time.timeZone = "Europe/Berlin"; # set time zone
  i18n.defaultLocale = "de_DE.UTF-8"; # set region
  console = {
      font = "Lat2-Terminus16";
      keyMap = "de-latin1-nodeadkeys"; # set keyboard layout
  };

  services.openssh = {
      enable = true; # enable ssh server
      settings.PasswordAuthentication = true; # allow password login
      # settings.PermitRootLogin = "yes"; # allow root login
  };

  programs.ssh = {
    startAgent = true; # enable the ssh agent to add custom private keys
    knownHosts = {
      "github.com/RSA" = {
        hostNames = [ "github.com" ];
        publicKey = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCj7ndNxQowgcQnjshcLrqPEiiphnt+VTTvDP6mHBL9j1aNUkY4Ue1gvwnGLVlOhGeYrnZaMgRK6+PKCUXaDbC7qtbW8gIkhL7aGCsOr/C56SJMy/BCZfxd1nWzAOxSDPgVsmerOBYfNqltV9/hWCqBywINIR+5dIg6JTJ72pcEpEjcYgXkE2YEFXV1JHnsKgbLWNlhScqb2UmyRkQyytRLtL+38TGxkxCflmO+5Z8CSSNY7GidjMIZ7Q4zMjA2n1nGrlTDkzwDCsw+wqFPGQA179cnfGWOWRVruj16z6XyvxvjJwbz0wQZ75XK5tKSb7FNyeIEs4TT4jk+S4dhPeAUC5y+bDYirYgM4GC7uEnztnZyaVWQ7B381AK4Qdrwt51ZqExKbQpTUNn+EjqoTwvqNj4kqx5QUCI0ThS/YkOxJCXmPUWZbhjpCg56i+2aB6CmK2JGhn57K5mj0MNdBXA4/WnwH6XoPWJzK5Nyu2zB3nAZp+S5hpQs+p1vN1/wsjk=";
      };
      "github.com/ECDSA" = {
        hostNames = [ "github.com" ];
        publicKey = "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBEmKSENjQEezOmxkZMy7opKgwFB9nkt5YRrYMjNuG5N87uRgg6CLrbo5wAdT/y6v0mKV0U2w0WZ2YB/++Tpockg=";
      };
      "github.com/Ed25519" = {
        hostNames = [ "github.com" ];
        publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMqqnkVzrm0SdG6UOoqKLsabgH5C9okWi0dh2l9GKJl";
      };
      "gitlabci.exxeta.com/RSA" = {
        hostNames = [ "gitlabci.exxeta.com" ];
        publicKey = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDLJQtDp+kDtWXz2qKjOb8/TToOyPJq6t7868uHATmlBLKU++K3rktnE5/Af+HAf/lXIYa40RlTE7TCGKIHpX5Z82Q8CqfbjQN7z7fN8w0Kz014ZdSi/Zhm9F6XUjeya5FbLBt9UAp9+qb5DgarCVlD+c7gfxtyfxPOkywsV1YokY9onsziZ/oc+OvrwIfRMajOwOdT6YdZ4KEXTgXrSLKtsDctO3MciAb1LP83uem5gOlfR5DqyxDli4xBI1jmAY1AsXq69FEKBNVbLII1chkVoYlJUmgZaMhPCkHmCU2LnC2Vp71/JRwuPIikpUVhsIW8RhYoUEoyIV8YT6EkEw8r";
      };
      "gitlabci.exxeta.com/ECDSA" = {
        hostNames = [ "gitlabci.exxeta.com" ];
        publicKey = "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBMSyYF0bv/tuYKc7e9duPdOKKMNdrZhXt3yUr/EkoYPLzW+3L/xC2CZkpf0Ctoj/55/sor5/EJLDNkpVAXhu+64=";
      };
      "gitlabci.exxeta.com/Ed25519" = {
        hostNames = [ "gitlabci.exxeta.com" ];
        publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEXSkuulxOCW7tdMEla1d3hd/ZjC1DIFLlauCCH0Cj45";
      };
    };
  };

  security.sudo.wheelNeedsPassword = false; #enable paswordless sudo

  networking.firewall.enable = false; # disable firewall

  environment.etc.issue = {
    text = ''
      <<< Welcome to NixOS (\m) - \l >>>

      Run 'nixos-help' for the NixOS manual.

      IP: \4{enp0s8}
    '';
  };

  programs.nix-ld.enable = true; # enable dynamic linking for remote development backends
  programs.java.enable = true; # enable java environment variables
  virtualisation.docker.enable = true; # install docker

  environment.systemPackages = with pkgs; [ # install software packages
    openssl
    keychain
    git
    python3
    fzf
    jq
    docker-compose
    nodejs
    jdk11
    maven
  ];

}