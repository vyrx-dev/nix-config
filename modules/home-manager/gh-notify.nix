# GitHub notifications TUI, installed as a gh extension. gh discovers it
# under ~/.local/share/gh/extensions/<name>/<executable>.
{pkgs, ...}: {
  home.file.".local/share/gh/extensions/gh-notify/gh-notify" = {
    source = pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/meiji163/gh-notify/dff46349970f37c42b1a6fe15e6d62514e848d27/gh-notify";
      hash = "sha256-kp2Ss4F8lJYR1sMZkqpLW2WMdChneOIk5bzwFUIRLLM=";
    };
    executable = true;
  };
}
