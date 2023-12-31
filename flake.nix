{
  description = "My new nix config, from almost scratch";

  inputs = {
    # TODO for btrfs

    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager/release-23.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    impermanence.url = "github:nix-community/impermanence";
    hardware.url = "github:nixos/nixos-hardware";
    vscode-server.url = "github:nix-community/nixos-vscode-server";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    impermanence,
    vscode-server,
    ...
  } @ inputs: let
    globals = import ./globals.nix;
    inherit (self) outputs;
    systems = ["aarch64-linux" "x86_64-linux"];

    forAllSystems = nixpkgs.lib.genAttrs systems;
  in {
    devShells = forAllSystems (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};
      in
        import ./shell.nix {inherit pkgs;}
    );

    # Formatter for your nix files, available through 'nix fmt'
    # Other options beside 'alejandra' include 'nixpkgs-fmt'
    formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);
    # devShells = forEachSystem (pkgs: import ./shell.nix { inherit pkgs; });
    # devShells = forAllSystems (system: pkgs.mkShell {
    #   NIX_CONFIG = "extra-experimental-features = nix-command flakes repl-flake";
    #   nativeBuildInputs = with pkgs; [
    #     nix
    #   ];
    # devShells = flake-utils.lib.eachSystem (system: {
    #   inherit (pkgs) mkShell;
    #   shell = mkShell {
    #     nativeBuildInputs = with pkgs; [ nix ];
    #     buildInputs = with pkgs; [ your-package1 your-package2 ... ];
    #   };
    # });
    overlays = import ./overlays {inherit inputs;};


    nixosModules = import ./nixos/modules;
    homeManagerModules = import ./home/modules;

    # Available through 'nixos-rebuild --flake .#your-hostname'
    nixosConfigurations = {
      nixos-virt = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs outputs globals;
        };
        modules = [
          ./hosts/nixos-virt
          vscode-server.nixosModules.default
          ({
            config,
            pkgs,
            ...
          }: {
            services.vscode-server.enable = true;
          })
        ];
      };
      pc = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs outputs globals;
        };
        modules = [
          ./hosts/pc
        ];
      };
      closet = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs outputs globals;
        };
        modules = [
          ./hosts/closet
          vscode-server.nixosModules.default
          ({
            config,
            pkgs,
            ...
          }: {
            services.vscode-server.enable = true;
          })
        ];
      };
    };

    # Available through 'home-manager --flake .#your-username@your-hostname'
    homeConfigurations = {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      "freiherr@nixos-virt" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        extraSpecialArgs = {
          inherit inputs outputs globals;
        };
        modules = [
          ./home/nixos-virt.nix
        ];
      };
      "freiherr@pc" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        extraSpecialArgs = {
          inherit inputs outputs globals;
        };
        modules = [
          ./home/pc.nix
        ];
      };
      "freiherr@closet" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        extraSpecialArgs = {
          inherit inputs outputs globals;
        };
        modules = [
          ./home/closet.nix
        ];
      };
      "non-nixos" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        extraSpecialArgs = {
          inherit inputs outputs globals;
        };
        modules = [
          ./home/non-nixos.nix
        ];
      };
    };
  };
}
