{
  description = "My Universal Flake Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
    ai-usagebar.url = "github:akitaonrails/ai-usagebar";
    voxtype.url = "github:peteonrails/voxtype";
    herdr.url = "github:herdrdev/herdr-nix";
    codex-desktop-linux.url = "github:ilysenko/codex-desktop-linux";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    spicetify-nix,
    ai-usagebar,
    voxtype,
    codex-desktop-linux,
    ...
  } @ inputs: {
    nixosConfigurations."nixos-btw" = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {inherit inputs;};
      modules = [
        spicetify-nix.nixosModules.default

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
      ];
    };
  };
}
