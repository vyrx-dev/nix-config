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
│       │   │   └── config.kdl       # full niri config (keybindings inlined)
│       │   ├── rmpc/
│       │   │   ├── config.ron       # rmpc main config (also set via programs.rmpc.config)
│       │   │   ├── themes/theme.ron
│       │   │   └── fetch-lyrics     # on_song_change hook script
│       │   ├── sway/config          # full sway config
│       │   └── waybar/style.css     # waybar CSS (read via builtins.readFile)
│       ├── cursor.nix               # home.pointerCursor (Bibata-Modern-Ice, applies globally)
│       ├── fish.nix                 # programs.fish with shellAliases, shellAbbrs, functions
│       ├── fuzzel.nix               # programs.fuzzel with full settings
│       ├── ghostty.nix              # programs.ghostty with full settings (package = null)
│       ├── kanshi.nix               # services.kanshi with display profiles
│       ├── kitty.nix                # programs.kitty with full settings
│       ├── mako.nix                 # services.mako notifications
│       ├── mpd.nix                  # services.mpd + services.mpd-mpris
│       ├── mpdscribble.nix          # services.mpdscribble (Last.fm)
│       ├── niri.nix                 # xdg.configFile for niri/config.kdl
│       ├── polkit.nix               # polkit-gnome auth agent (systemd user service)
│       ├── rmpc.nix                 # programs.rmpc + xdg.configFile for theme/fetch-lyrics
│       ├── starship.nix             # programs.starship with full settings
│       ├── sway.nix                 # xdg.configFile for sway/config
│       ├── swaylock.nix             # programs.swaylock-effects + raw config via xdg.configFile
│       ├── theme.nix                # GTK (adw-gtk3-dark) + Qt (adwaita-dark) dark theme
│       ├── tmux.nix                 # programs.tmux with plugins (replaces TPM)
│       └── waybar.nix               # programs.waybar with full settings + style from file
└── todo.md                          # task list — read this first
```

## Rules

1. **Read todo.md first** before any work. It has the current list of tasks to complete.

2. **Module aggregators are manual** — adding a new `.nix` to `modules/home-manager/`
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

5. **Secrets** — never put passwords or tokens in any Nix file. The Nix store is
   world-readable. Use `passwordFile` pointing outside the store (current approach
   for mpdscribble) or migrate to agenix/sops-nix later.

6. **Sway and Niri configs are raw files** under `modules/home-manager/files/`.
   They are deployed via `xdg.configFile.source`. Do not attempt to convert them
   to HM structured options unless specifically asked.

7. **`pkgs.system` is deprecated** — use `pkgs.stdenv.hostPlatform.system`.

8. **Comment policy** — only add comments where the intent is non-obvious.
   Do not add migration history, source-tracking, or self-referential comments.

9. **swaylock uses swaylock-effects** — the config has duplicate `effect-scale`
   keys which cannot be expressed as a Nix attrset. Config is deployed via
   `xdg.configFile` as raw text. `programs.swaylock.package = pkgs.swaylock-effects`.

10. **tmux plugins are managed by nixpkgs** — TPM has been replaced by
    `programs.tmux.plugins`. Do not add the TPM `run` line to extraConfig.

11. **Spicetify manages Spotify** — `programs.spicetify.enable = true` installs a
    patched Spotify. Do NOT add bare `spotify` to `environment.systemPackages`.

12. **GTK/Qt theming is in theme.nix** — uses `adw-gtk3-dark` for GTK and
    `adwaita-dark` for Qt. Do not set `GTK_THEME` in `environment.sessionVariables`
    or use runtime `gsettings` for theming (sway gsettings is for dconf backend only).

13. **Window rule app-ids must be verified** — use `niri msg windows` (niri) or
    `swaymsg -t get_tree` (sway) to get the real app-id. Common gotchas:
    - Thunar = `org.xfce.Thunar` (not `thunar`)
    - Zed = `dev.zed.Zed` (not `zed`)
    - Ghostty = `com.mitchellh.ghostty` (not `ghostty`)
    - EasyEffects = `com.github.wwmm.easyeffects` (not `easyeffects`)

## Key Facts

- Host: `nixos-btw` — AMD iGPU + NVIDIA RTX 2050 (PRIME offload)
- User: `vyrx`
- Shell: fish + starship
- Compositors: Sway + Niri (both available at login via tuigreet)
- Gaming: Steam + Gamescope session (selectable from tuigreet)
- Display manager: greetd + tuigreet
- Seat management: logind (not seatd) — `LIBSEAT_BACKEND=logind` is set globally
- Audio: PipeWire (PulseAudio compat)
- `mpdscribble` username: `theamit.969@gmail.com`
  Password file: `~/.config/mpdscribble/lastfm-password` (create manually)
- `~/.config/nvim` — symlink to dotfiles, intentionally NOT Nix-managed
- `~/Scripts` — user-authored scripts, added to PATH via fish config, NOT Nix-managed
