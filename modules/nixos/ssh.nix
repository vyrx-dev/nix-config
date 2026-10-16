{...}: {
  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = true;
  };

  programs.ssh = {
    startAgent = true;
    extraConfig = ''
      Host *
        AddKeysToAgent yes
    '';
  };
  # Prevent gnome's gcr-ssh-agent (pulled in by xdg-desktop-portal-gnome)
  # from conflicting with programs.ssh.startAgent
  services.gnome.gcr-ssh-agent.enable = false;
}
