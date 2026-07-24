# Progress

## Session 1 — MPD Stack + Niri + Waybar/Mako Scaffolding (2026-07-24)

Added `home-manager` as a flake input, created the module structure, and
migrated active dotfiles into Nix.

**Changes:**
- Added `home-manager` flake input (follows nixpkgs), wired as NixOS module
- Created `home/vyrx/default.nix` — HM user entry point
- Created `modules/home-manager/` with aggregator `default.nix` and modules:
  - `mpd.nix` — MPD user service, socket activation, PulseAudio + FIFO outputs, mpd-mpris bridge
  - `mpdscribble.nix` — Last.fm scrobbler (password file lives outside store)
  - `rmpc.nix` — terminal MPD client
  - `niri.nix` — deploys `files/niri/config.kdl` via xdg.configFile
  - `sway.nix` — deploys `files/sway/config` via xdg.configFile
  - `waybar.nix` — scaffolded, `enable = false` (Noctalia owns the bar)
  - `mako.nix` — full config migrated, `enable = false` (Noctalia owns notifications)
  - `kitty.nix` — full config migrated (font, colors, cursor, behavior)
  - `fuzzel.nix` — full config migrated
  - `starship.nix` — full config migrated
- Created `modules/nixos/niri.nix` — enables `programs.niri` with portal config
- Reorganized `configuration.nix` with box-drawing section headers
- Fixed `pkgs.system` → `pkgs.stdenv.hostPlatform.system` (deprecation warning)
- Fixed pre-existing `programs.ssh.startAgent` vs `gnome.gcr-ssh-agent` conflict

**Verified:** `alejandra .` ✅ `nix flake check` ✅ `nixos-rebuild switch` ✅

---

## Session 2 — Full Dotfiles Migration (2026-07-24)

Migrated all remaining dotfiles from `~/dotfiles/` symlinks into Nix modules.
All `~/.config/` symlinks pointing to dotfiles (except nvim and vicinae) are now
managed by Home Manager.

**Migrated:**
- `rmpc/config.ron` → `programs.rmpc.config` (native HM); theme + fetch-lyrics via xdg.configFile
- `niri/config.kdl` + `binds-custom.kdl` + `binds-noctalia.kdl` → `files/niri/` + `niri.nix`
- `waybar/` → `programs.waybar.settings` (native Nix attrset, no JSONC); `style.css` via readFile
- `ghostty/config` → `programs.ghostty.settings` (native HM, `package = null`)
- `fish/` → `programs.fish` (shellAliases, shellAbbrs, functions, interactiveShellInit)
- `.tmux.conf` → `programs.tmux` with `tmuxPlugins.sensible` + `vim-tmux-navigator` (replaces TPM)
- `kanshi/config` → `services.kanshi.settings` (native HM, `enable = true`)
- `swaylock/config` → `programs.swaylock` package + raw xdg.configFile (duplicate effect-scale keys)
- Mako symlink removed (config already in mako.nix from session 1)

**Decisions:**
- `vicinae/settings.json` — NOT Nix-managed; vicinae writes to it from its GUI
- `noctalia` — no config to manage; app is launched as a startup process in niri config
- `~/.config/nvim` — intentionally left as dotfiles symlink (out of scope)
- swaylock uses `pkgs.swaylock-effects` (has blur/vignette effect options)
- kanshi auto-starts via systemd (bound to wayland target)

**Symlinks removed from `~/.config/`:**
`mako`, `kanshi`, `swaylock`, `ghostty`, `fish`, `niri`, `waybar`

**File removed from `~/.home`:**
`.tmux.conf`

**Verified:** `alejandra .` ✅ `nix flake check` ✅

## Still TODO

- [ ] Run `sudo nixos-rebuild switch --flake .` to apply session 2 changes
- [ ] Enable waybar + mako once Noctalia's bar/notifications are turned off
- [ ] Set up agenix or sops-nix for mpdscribble credentials (optional upgrade)
- [ ] Commit all staged changes to git
