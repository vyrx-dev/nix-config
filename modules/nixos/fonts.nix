{pkgs, ...}: {
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.iosevka-term
    nerd-fonts.caskaydia-cove
    nerd-fonts.hack
    nerd-fonts.fira-code
    inter
  ];
}
