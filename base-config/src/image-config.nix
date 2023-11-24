let
  vars = import ../vars.nix;
in
{
  contents = builtins.concatLists[
    [
      {
        source = ../vars.nix;
        target = "/etc/nixos/vars.nix";
        mode = "750";
        user = "root";
        group = "root";
      }
      {
        source = ./bashrc;
        target = "/home/${vars.user.name}/.bashrc";
        mode = "750";
        user = vars.user.name;
        group = "root";
      }
      {
        source = ./issue;
        target = "/etc/nixos/issue";
        mode = "750";
        user = vars.user.name;
        group = "root";
      }
    ]
    (builtins.map (x: {
        source = x;
        target = "/home/${vars.user.name}/.ssh/${builtins.baseNameOf x}";
        mode = "600";
        user = vars.user.name;
        group = "root";
      }) vars.user.ssh.private_keys)
    (builtins.map (x: {
        source = x;
        target = "/home/${vars.user.name}/.ssh/${builtins.baseNameOf x}";
        mode = "644";
        user = vars.user.name;
        group = "root";
      }) vars.user.ssh.public_keys)
    (builtins.map (x: {
        source = x;
        target = "/home/${vars.user.name}/${builtins.baseNameOf x}";
        mode = "750";
        user = vars.user.name;
        group = "root";
      }) vars.user.projects)
  ];

  configFile = ./nixos-config.nix;
}