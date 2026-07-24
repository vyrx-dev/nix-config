# AGENTS.md

Instructions for AI agents working on this repo.

## Repo Overview

NixOS flake config for host `nixos-btw`, user `vyrx`.
Single host, single user. Home Manager integrated as a NixOS module.

## Layout

```
.
├── flake.nix                        # inputs: nixpkgs, home-manager, spicetify-nix, zen-browser
├── flake.lock
├── configuration.nix                # NixOS system config (hardware, services, packages)
├── hardware-configuration.nix       # auto-generated, do not edit
├── home/vyrx/default.nix            # HM entry point — imports modules/home-manager
├── modules/
│   ├── nixos/
│   │   ├── default.nix              # aggregator — imports every .nix in this dir
│   │   └── niri.nix                 # programs.niri.enable + portal config (NixOS-level)
│   └── home-manager/
│       ├── default.nix              # aggregator — imports every module .nix in this dir
│       ├── files/                   # raw config files deployed via xdg.configFile
│       │   ├── niri/
│       │   │   ├── config.kdl       # full niri config
│       │   │   ├── binds-custom.kdl # custom keybindings (included by config.kdl)
│       │   │   └── binds-noctalia.kdl
│       │   ├── rmpc/
│       │   │   ├── config.ron       # rmpc main config (also set via programs.rmpc.config)
│       │   │   ├── themes/theme.ron
│       │   │   └── fetch-lyrics     # on_song_change hook script
│       │   ├── sway/config          # full sway config
│       │   └── waybar/style.css     # waybar CSS (read via builtins.readFile)
│       ├── mpd.nix                  # services.mpd + services.mpd-mpris
│       ├── mpdscribble.nix          # services.mpdscribble (Last.fm)
│       ├── rmpc.nix                 # programs.rmpc + xdg.configFile for theme/fetch-lyrics
│       ├── niri.nix                 # xdg.configFile for niri/{config,binds-custom,binds-noctalia}.kdl
│       ├── sway.nix                 # xdg.configFile for sway/config
│       ├── waybar.nix               # programs.waybar (enable = false — Noctalia owns the bar)
│       ├── mako.nix                 # services.mako (enable = false — Noctalia owns notifications)
│       ├── kanshi.nix               # services.kanshi with display profiles (enable = true)
│       ├── swaylock.nix             # programs.swaylock-effects + raw config via xdg.configFile
│       ├── kitty.nix                # programs.kitty with full settings
│       ├── fuzzel.nix               # programs.fuzzel with full settings
│       ├── starship.nix             # programs.starship with full settings
│       ├── ghostty.nix              # programs.ghostty with full settings (package = null)
│       ├── fish.nix                 # programs.fish with shellAliases, shellAbbrs, functions
│       └── tmux.nix                 # programs.tmux with plugins (replaces TPM)
└── PROGRESS.md                      # session log — read this first
```

## Rules

1. **Read PROGRESS.md first** before any work. It has current state and open TODOs.

2. **Module aggregators auto-import** — adding a new `.nix` to `modules/home-manager/`
   or `modules/nixos/` requires manually adding it to the respective `default.nix`
   imports list. They are NOT auto-scanned.

3. **HM is NixOS-integrated** — `home-manager.users.vyrx` is set in `flake.nix`.
   A single `nixos-rebuild switch` applies both system and HM config. No separate
   `home-manager switch` needed.

4. **Verify before finishing** — always run:
   ```
   alejandra .
   nix flake check
   nixos-rebuild build --flake .#nixos-btw
   ```

5. **Waybar and Mako are intentionally disabled** (`enable = false`). Noctalia
   currently provides the bar and notification daemon. Do not enable them unless
   instructed.

6. **Secrets** — never put passwords or tokens in any Nix file. The Nix store is
   world-readable. Use `passwordFile` pointing outside the store (current approach
   for mpdscribble) or migrate to agenix/sops-nix later.

7. **Sway and Niri configs are raw files** under `modules/home-manager/files/`.
   They are deployed via `xdg.configFile.source`. Do not attempt to convert them
   to HM structured options unless specifically asked.

8. **`pkgs.system` is deprecated** — use `pkgs.stdenv.hostPlatform.system`.

9. **Comment policy** — only add comments where the intent is non-obvious.
   Do not add source-tracking comments like "migrated from ~/.config/X".

10. **vicinae config is mutable** — `~/.config/vicinae/settings.json` is managed
    by the vicinae app itself (it writes to the file via its GUI). Do NOT put it
    in xdg.configFile — the nix store is read-only and vicinae would fail to save.

11. **swaylock uses swaylock-effects** — the config has duplicate `effect-scale`
    keys which cannot be expressed as a Nix attrset. Config is deployed via
    `xdg.configFile` as raw text. `programs.swaylock.package = pkgs.swaylock-effects`.

12. **tmux plugins are managed by nixpkgs** — TPM has been replaced by
    `programs.tmux.plugins`. Do not add the TPM `run` line to extraConfig.

## Key Facts

- Host: `nixos-btw` — AMD iGPU + NVIDIA RTX 2050 (PRIME offload)
- User: `vyrx`
- Shell: fish + starship
- Compositors: Sway (active), Niri (available at login via tuigreet)
- Display manager: greetd + tuigreet
- Audio: PipeWire (PulseAudio compat)
- `mpdscribble` username: `theamit.969@gmail.com`
  Password file: `~/.config/mpdscribble/lastfm-password` (create manually)
- `~/.config/nvim` — symlink to dotfiles, intentionally NOT Nix-managed
- `~/.config/vicinae` — symlink to dotfiles, intentionally NOT Nix-managed (mutable)
