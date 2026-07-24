{...}: {
  services.mako = {
    enable = false;

    settings = {
      sort = "-time";
      layer = "overlay";
      width = 320;
      height = 100;
      margin = "10";
      padding = "10";
      border-size = 0;
      border-radius = 4;
      icons = 1;
      max-icon-size = 64;
      max-history = 10;
      default-timeout = 10000;
      ignore-timeout = 1;
      font = "Inter 11";

      background-color = "#0d0d0dee";
      text-color = "#c1c1c1";
      border-color = "#b3c7cc";

      "app-name=lol" = {
        layer = "overlay";
        history = 0;
      };

      "mode=do-not-disturb" = {
        invisible = 1;
      };
    };
  };
}
