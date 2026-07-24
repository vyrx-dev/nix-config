{
  description = "My Universal Flake Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # noctalia.url = "github:noctalia-dev/noctalia/cachix";
    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
    zen-browser.url = "github:youwen5/zen-browser-flake";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    # noctalia,
    spicetify-nix,
    zen-browser,
    ...
  } @ inputs: {
    nixosConfigurations."nixos-btw" = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {inherit inputs;};
      modules = [
        # noctalia.nixosModules.default
        spicetify-nix.nixosModules.default

        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.backupFileExtension = "backup";
          home-manager.users.vyrx = import ./home/vyrx;
        }

        ./configuration.nix
        ./modules/nixos
      ];
    };
  };
}
