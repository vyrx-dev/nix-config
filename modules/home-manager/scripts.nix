{...}: let
  dir = ./files/scripts;
in {
  home.file = builtins.listToAttrs (map (name: {
    name = "Scripts/${name}";
    value = {
      source = dir + "/${name}";
      executable = true;
    };
  }) (builtins.attrNames (builtins.readDir dir)));
}
