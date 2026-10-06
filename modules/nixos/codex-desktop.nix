# ChatGPT desktop for Linux, which also carries the Codex desktop UI.
# nixpkgs' `chatgpt` and `chatgpt-classic` are Darwin-only, so this comes from
# the ilysenko/codex-desktop-linux flake instead. The menu entry is "ChatGPT
# Community" and the command is `codex-desktop`. It has no mutable updater, so
# bump the flake input to update it.
{inputs, ...}: {
  imports = [inputs.codex-desktop-linux.nixosModules.default];

  programs.codexDesktopLinux.enable = true;
}
