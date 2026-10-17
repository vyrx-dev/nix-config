{...}: {
  # sshd is off because this machine is only accessed locally. To re-enable,
  # set enable = true and add a public key under
  # users.users.vyrx.openssh.authorizedKeys.keys; keep password auth off.
  services.openssh = {
    enable = false;
    settings.PasswordAuthentication = false;
    # sshd is off, but sops decrypts the vault with the host key, so keep
    # generating host keys (otherwise a fresh install can't decrypt secrets).
    generateHostKeys = true;
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
