{
  imports = [./git.common.nix];

  programs.git = {
    settings = {
      diff = {submodule = "log";};
    };
    includes = [
      {
        condition = "gitdir:**/github.com/**";
        contents = {
          user = {
            email = "markus.korn@gmail.com";
            name = "Markus Korn";
            signingkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM2TeK+8hSMifAqXjBuWu0AyzqM+iMVEN7lk/+36cY9n thekorn-server";
          };
          commit = {gpgsign = true;};
        };
      }
      {
        condition = "gitdir:~/.config/nix";
        contents = {
          user = {
            email = "markus.korn@gmail.com";
            name = "Markus Korn";
            signingkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM2TeK+8hSMifAqXjBuWu0AyzqM+iMVEN7lk/+36cY9n thekorn-server";
          };
          commit = {gpgsign = true;};
        };
      }
    ];
  };
}
