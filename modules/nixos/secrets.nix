# Decrypts secrets/secrets.yaml (sops-nix) at activation. Encryption
# recipients are declared in .sops.yaml; add a host by adding its SSH key.
{...}: {
  sops = {
    # Decrypt with the host SSH key (host keys are always generated even
    # though sshd is off, see modules/nixos/ssh.nix), so a fresh install
    # needs no separate age key file.
    age.sshKeyPaths = ["/etc/ssh/ssh_host_ed25519_key"];
    defaultSopsFile = ../../secrets/secrets.yaml;

    secrets = {
      ssh_id_rsa = {
        path = "/home/vyrx/.ssh/id_rsa";
        owner = "vyrx";
        mode = "0600";
      };
      ssh_id_rsa_pub = {
        path = "/home/vyrx/.ssh/id_rsa.pub";
        owner = "vyrx";
        mode = "0644";
      };
      ssh_aur_key = {
        path = "/home/vyrx/.ssh/aur_key";
        owner = "vyrx";
        mode = "0600";
      };
      ssh_aur_key_pub = {
        path = "/home/vyrx/.ssh/aur_key.pub";
        owner = "vyrx";
        mode = "0644";
      };
      ssh_known_hosts = {
        path = "/home/vyrx/.ssh/known_hosts";
        owner = "vyrx";
        mode = "0644";
      };
      mpdscribble_lastfm_password = {
        path = "/home/vyrx/.config/mpdscribble/lastfm-password";
        owner = "vyrx";
        mode = "0600";
      };
    };
  };

  # Gives sops a directory to drop the password into on a fresh install.
  systemd.tmpfiles.rules = ["d /home/vyrx/.config/mpdscribble 0700 vyrx users -"];
}
