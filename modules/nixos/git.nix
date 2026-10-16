{...}: {
  programs.git = {
    enable = true;
    config = {
      user.name = "vyrx";
      user.email = "theamit.969@gmail.com";
      init.defaultBranch = "main";
      pull.rebase = true;
    };
  };
}
