{
  description = "My Universal Flake Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    noctalia.url = "github:noctalia-dev/noctalia/cachix";
    sops-nix.url = "github:Mic92/sops-nix";
    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
    zen-browser.url = "github:youwen5/zen-browser-flake";
  };

  outputs = {
    self,
    nixpkgs,
    noctalia,
    sops-nix,
    spicetify-nix,
    zen-browser,
    ...
  } @ inputs: {
    nixosConfigurations."nixos-btw" = nixpkgs.lib.nixosSystem {
      system = "x86-64-linux";
      specialArgs = {inherit inputs;};
      modules = [
        noctalia.nixosModules.default
        sops-nix.nixosModules.sops
        spicetify-nix.nixosModules.default

        ./configuration.nix
      ];
    };
  };
}
