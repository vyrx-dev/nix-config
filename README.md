# nixos-btw

![Home Screen](assets/home.png)

My NixOS config. It probably won't work on your machine out of the box, but feel free to look through it and steal whatever seems useful. That's honestly why I'm making it public.

If you end up using something, a star would be cool. No pressure though.

```bash
git clone https://github.com/vyrx-dev/nix-config && cd nix-config
# edit hardware-configuration.nix, hostnames, and display outputs first
sudo nixos-rebuild switch --flake .
```

> [!WARNING]
> Never put passwords or API tokens in Nix files. The Nix store is world-readable.

good luck.
