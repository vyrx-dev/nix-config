# Secrets (sops-nix)

`secrets/secrets.yaml` is encrypted with [sops](https://getsops.io) and [age](https://github.com/FiloSottile/age). `.sops.yaml` lists who can decrypt it: my host key and my personal key. If you fork this, swap in your own.

At boot sops-nix imports the SSH host key as an age key and writes the plaintext to `/run/secrets/`:

```nix
sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
```

The host key only covers boot. You edit the vault with your personal age key at `~/.config/sops/age/keys.txt`:

```bash
sops secrets/secrets.yaml
```

## Back up these keys

Without both, a new machine cannot decrypt the vault:

1. `/etc/ssh/ssh_host_ed25519_key` and `.pub`: decrypts secrets at boot. The `&host` recipient in `.sops.yaml` is derived from this exact keypair.
2. `~/.config/sops/age/keys.txt`: your personal age identity, used for editing.

Save each output as its own file in your password manager:

```bash
sudo cat /etc/ssh/ssh_host_ed25519_key      # save as ssh_host_ed25519_key
cat /etc/ssh/ssh_host_ed25519_key.pub       # save as ssh_host_ed25519_key.pub
cat ~/.config/sops/age/keys.txt             # save as keys.txt
```

## Restore after a reinstall

Put both keys back before the first switch:

```bash
KEYS=~/backups/nix-keys          # bash / zsh
set KEYS ~/backups/nix-keys      # fish

# host keypair, decrypts the vault at boot
sudo install -D -m600 -o root -g root "$KEYS/ssh_host_ed25519_key"     /etc/ssh/ssh_host_ed25519_key
sudo install -D -m644 -o root -g root "$KEYS/ssh_host_ed25519_key.pub" /etc/ssh/ssh_host_ed25519_key.pub

# personal age key, used to edit secrets
install -D -m600 "$KEYS/keys.txt" ~/.config/sops/age/keys.txt
```

## Verify after the switch

```bash
nix run nixpkgs#ssh-to-age -- -i /etc/ssh/ssh_host_ed25519_key.pub   # should match &host in .sops.yaml
ls /run/secrets/
```

## Add a host or rotate keys

Add the new `ssh-to-age` key to `.sops.yaml`, then run this from a machine that can still decrypt:

```bash
sops updatekeys secrets/secrets.yaml
```
