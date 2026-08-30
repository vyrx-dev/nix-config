{
  description = "My Universal Flake Configuration";

  # Noctalia prebuilt binaries (Cachix).
  nixConfig = {
    extra-substituters = ["https://noctalia.cachix.org"];
    extra-trusted-public-keys = ["noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="];
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
    ai-usagebar.url = "github:akitaonrails/ai-usagebar";
    voxtype.url = "github:peteonrails/voxtype";
    zen-browser.url = "github:youwen5/zen-browser-flake";
    # cachix branch always points to the latest cached commit, so no local compile.
    noctalia.url = "github:noctalia-dev/noctalia/cachix";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    spicetify-nix,
    ai-usagebar,
    voxtype,
    zen-browser,
    noctalia,
    ...
  } @ inputs: {
    nixosConfigurations."nixos-btw" = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {inherit inputs;};
      modules = [
        spicetify-nix.nixosModules.default
        noctalia.nixosModules.default

        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = {inherit inputs;};
          home-manager.sharedModules = [
            voxtype.homeManagerModules.default
          ];
          home-manager.backupFileExtension = "backup";
          home-manager.users.vyrx = import ./home/vyrx;
        }

        ./configuration.nix
        ./modules/nixos
      ];
    };
  };
}
