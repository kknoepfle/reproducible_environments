let
  pkgs = import <nixos-23.05> { };
in
{
  user = {
    name = "dev";
    password = "secure";
    ssh = {
      public_keys = [
      ];
      private_keys = [
      ];
    };
    git = {
      username = "first_name last_name";
      email = "first_name.last_name@company.com";
    };
    projects = [
      # ~/path-to-project
    ];
  };

  os = {
    pkgs = pkgs;
    time_zone = "Europe/Berlin";
    locale = "de_DE.UTF-8";
    key_map = "de-latin1-nodeadkeys";
    ssh_password_authentication = true;

    environment_variables = {

    };

    additional_packages = with pkgs; [
      # nodejs
    ];

  };

  vm = {
    disk_size = "20G";
  };
}