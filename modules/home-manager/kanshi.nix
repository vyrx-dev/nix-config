{...}: {
  services.kanshi = {
    enable = true;

    settings = [
      {
        profile.name = "laptop-only";
        profile.outputs = [
          {
            criteria = "eDP-1";
            status = "enable";
            mode = "1920x1080@144.003Hz";
          }
        ];
      }
      {
        profile.name = "laptop-left";
        profile.outputs = [
          {
            criteria = "eDP-1";
            status = "enable";
            mode = "1920x1080@144.003Hz";
            position = "0,0";
          }
          {
            criteria = "HDMI-A-1";
            status = "enable";
            mode = "1920x1080@100Hz";
            position = "1920,0";
          }
        ];
      }
      {
        profile.name = "monitor-top";
        profile.outputs = [
          {
            criteria = "HDMI-A-1";
            status = "enable";
            mode = "1920x1080@100Hz";
            position = "0,0";
          }
          {
            criteria = "eDP-1";
            status = "enable";
            mode = "1920x1080@144.003Hz";
            position = "0,1080";
          }
        ];
      }
      {
        profile.name = "monitor-right";
        profile.outputs = [
          {
            criteria = "HDMI-A-1";
            status = "enable";
            mode = "1920x1080@100Hz";
            position = "0,0";
          }
          {
            criteria = "eDP-1";
            status = "enable";
            mode = "1920x1080@144.003Hz";
            position = "1920,0";
          }
        ];
      }
      {
        profile.name = "monitor-only";
        profile.outputs = [
          {
            criteria = "HDMI-A-1";
            status = "enable";
            mode = "1920x1080@100Hz";
            position = "0,0";
          }
          {
            criteria = "eDP-1";
            status = "disable";
          }
        ];
      }
    ];
  };
}
