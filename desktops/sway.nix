# programs.sway sets up the portal itself (xdg.portal.wlr plus
# xdg.portal.config.sway: ScreenCast/Screenshot to wlr, the rest to gtk, per
# upstream wlroots-portals.conf). The only gap is the wlr screencast chooser,
# added below.
{pkgs, ...}: {
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true; # Ensures GTK apps find themes, icons, and schemas
  };

  # slurp is not on the wlr portal's systemd PATH, so its default chooser fails
  xdg.portal.wlr.settings.screencast = {
    chooser_type = "simple";
    chooser_cmd = "${pkgs.slurp}/bin/slurp -f '%o' -or";
  };
}
