{...}: {
  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };
  environment.variables.SUDO_EDITOR = "nvim";
  # sudo strips the environment, so keep SUDO_EDITOR for `sudo -e`.
  security.sudo.extraConfig = ''
    Defaults env_keep += "SUDO_EDITOR"
  '';
}
