{pkgs, ...}: {
  programs.tmux = {
    enable = true;
    terminal = "tmux-256color";
    prefix = "C-s";
    baseIndex = 1;
    historyLimit = 1000000;
    escapeTime = 0;
    mouse = true;
    keyMode = "vi";
    sensibleOnTop = false; # loaded via plugins list below

    plugins = with pkgs.tmuxPlugins; [
      sensible
      vim-tmux-navigator
    ];

    extraConfig = ''
      set -ag terminal-overrides ",xterm-256color:RGB"

      set -g detach-on-destroy off
      set -g focus-events on
      set -g renumber-windows on
      set -g set-clipboard on
      set -g status-interval 3
      bind-key x kill-pane

      # Reload
      unbind r
      bind R source-file ~/.config/tmux/tmux.conf \; display "Reloaded!"

      # Pane resizing
      bind -r S-Left  resize-pane -L 5
      bind -r S-Down  resize-pane -D 5
      bind -r S-Up    resize-pane -U 5
      bind -r S-Right resize-pane -R 5
      bind -r m resize-pane -Z

      # Navigation
      bind-key -n C-h select-pane -L
      bind-key -n C-j select-pane -D
      bind-key -n C-k select-pane -U
      bind-key -n C-l select-pane -R

      # Splits
      unbind '"'
      unbind %
      bind v split-window -h -c "#{pane_current_path}"
      bind S split-window -v -c "#{pane_current_path}"
      bind c new-window -c "#{pane_current_path}"

      # Status bar
      set-option -g status-position top
      bind u set -g status

      # Popups
      bind -r g display-popup -d '#{pane_current_path}' -w 80% -h 80% -E lazygit

      # Scripts
      bind C-k run-shell 'tmux neww ~/Scripts/sessionX'
      bind C-p run-shell '~/Scripts/sessionX ~/Projects/'
      bind C-g run-shell "~/Scripts/open-github"
      bind C-j run-shell "~/Scripts/tmux-layout"

      # Statusline
      set -g mode-style                  "fg=#111111,bg=#e0e0e0"
      set -g message-style               "fg=#777777,bg=#111111"
      set -g message-command-style       "fg=#777777,bg=#111111"
      set -g pane-border-style           "fg=#1e1e1e"
      set -g pane-active-border-style    "fg=#2a2a2a"
      set -g status                      "on"
      set -g status-interval             1
      set -g status-justify              "centre"
      set -g status-style                "fg=#444444,bg=#111111,bold"
      set -g status-bg                   "#111111"
      set -g status-left-length          "100"
      set -g status-right-length         "100"
      set -g status-left-style           NONE
      set -g status-right-style          NONE
      set -g status-left                 "#[fg=#e0e0e0,bold]#S#[fg=#444444]:#[fg=#555555]#(tmux list-sessions | wc -l)  "
      set -g status-right                "#{?client_prefix,#[fg=#e0e0e0]⎋ ,#[fg=#222222]⎋ }#[fg=#555555]%H:%M"
      setw -g window-status-activity-style   "underscore,fg=#444444,bg=#111111"
      setw -g window-status-separator        "  "
      setw -g window-status-style            "NONE,fg=#555555,bg=#111111"
      setw -g window-status-format           '#[fg=#555555]#I:#W'
      setw -g window-status-current-format   '#[fg=#e0e0e0,bold]#I:#W'
    '';
  };
}
