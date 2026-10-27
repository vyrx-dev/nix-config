{...}: {
  programs.fish = {
    enable = true;

    shellInit = ''
      # Tools come from the Nix store; this machine's scripts live in ~/Scripts.
      fish_add_path $HOME/Scripts
    '';

    interactiveShellInit = ''
      set -g fish_greeting
      fish_default_key_bindings

      set -gx EDITOR nvim
      set -gx SUDO_EDITOR nvim
      set -gx VISUAL nvim
      set -gx TERMINAL foot
      set -gx MANPAGER "nvim +Man!"
      set -gx MPD_HOST "/run/user/"(id -u)"/mpd/socket"

      bind \ck sessionizer

      fzf --fish | source
      zoxide init fish | source

      # envman
      test -s ~/.config/envman/load.fish; and source ~/.config/envman/load.fish
    '';

    shellAliases = {
      ls = "eza -1 --icons=auto";
      l = "eza -lh --icons=auto";
      ll = "eza -lha --icons=auto --sort=name --group-directories-first";
      ld = "eza -lhD --icons=auto";
      lt = "eza --icons=auto --tree";
      ltt = "eza --tree --level=2 --long --icons --git";
      lta = "lt -a";
      cd = "z";
      ".." = "cd ..";
      "..." = "cd ../..";
      zed = "zeditor";
      bfile = "nvim ~/.bashrc";
      ffile = "nvim ~/.config/fish/config.fish";
      emu = "QT_QPA_PLATFORM=xcb ~/Android/Sdk/emulator/emulator -avd Pixel_9_Pro &";
      devices = "~/Android/Sdk/emulator/emulator -list-avds";
      rip = ''yt-dlp -x --audio-format="mp3"'';
      stars = "gh repo list vyrx-dev --limit 1000 --json stargazerCount | jq '[.[].stargazerCount] | add'";
      # Flakes only see git-tracked files, so stage before switching.
      # update-nix rewrites flake.lock, which is what the waybar update badge shows.
      rebuild-nix = "git -C /etc/nixos add -A && nh os switch";
      update-nix = "git -C /etc/nixos add -A && nh os switch --update";
    };

    shellAbbrs = {
      c = "code .";
      zz = "yazi";
      open = "thunar .";
      h = "history | grep ";
      fr = "flutter-watch";
      nd = "npm run dev";
      mr = "make run";
      lg = "lazygit";
      d = "docker";
      gits = "git status";
      gdd = "git diff --stat";
      ghp = ''gh repo create --private $(basename "$PWD") --source=. --description="desc" --push'';
      ghpp = ''git init; git add .; git commit -m "initial commit"; gh repo create --private $(basename "$PWD") --source=. --description="desc" --push'';
      tmuxk = "tmux kill-session";
      chx = "chmod +x";
      x = "exit";
      mkdir = "mkdir -p";
      ping = "ping -c 10";
      tar = "tar -xvf";
      pg = "ping -c 10 google.com";
      bigfont = "setfont ter-132b";
      regfont = "setfont default8x16";
    };

    functions = {
      sessionizer = {
        description = "Launch sessionX script";
        body = "$HOME/Scripts/sessionX";
      };
      y = {
        body = ''
          set tmp (mktemp -t "yazi-cwd.XXXXXX")
          yazi $argv --cwd-file="$tmp"
          if read -z cwd < "$tmp"; and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
              builtin cd -- "$cwd"
          end
          rm -f -- "$tmp"
        '';
      };
      flutter-watch = {
        body = ''
          set pid_file "/tmp/tf1.pid"
          touch $pid_file
          tmux send-keys "flutter run $argv --pid-file=$pid_file" Enter \; \
               split-window -v \; \
               send-keys 'npx -y nodemon -e dart -x "cat /tmp/tf1.pid | xargs kill -s USR1"' Enter \; \
               resize-pane -y 5 -t 1 \; \
               select-pane -t 0 \;
        '';
      };
      android-studio-wayland = {
        body = "env GDK_BACKEND=x11 android-studio $argv";
      };
    };
  };
}
