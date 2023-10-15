{
  description = "My new nix config, from almost scratch";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager/release-23.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # TODO: Add any other flake you might need
    # hardware.url = "github:nixos/nixos-hardware";
    #nix-colors.url = "github:misterio77/nix-colors";
    vscode-server.url = "github:nix-community/nixos-vscode-server";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    vscode-server,
    ...
  } @ inputs: let
    vars = import ./vars.nix;
    inherit (self) outputs;
    # Supported systems for your flake packages, shell, etc.
    systems = [
      "aarch64-linux"
      "i686-linux"
      "x86_64-linux"
      "aarch64-darwin"
      "x86_64-darwin"
    ];
    pkgs = nixpkgs.legacyPackages.x86_64-linux;
    # This is a function that generates an attribute by calling a function you
    # pass to it, with each system as an argument
    forAllSystems = nixpkgs.lib.genAttrs systems;
  in {
    # Available through 'nixos-rebuild --flake .#your-hostname'
    nixosConfigurations = {
      nixos-virt = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs outputs;
          inherit vars;
        };
        modules = [
          ./nixos/configuration.nix

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
        pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
        extraSpecialArgs = {
          inherit vars;
          inherit inputs outputs;
        };
        modules = [
          ./home-manager/home.nix
        ];
      };
    };
    # or with nix develop .#test : test = pkgs.mkShell {
    devShells.x86_64-linux.default = pkgs.mkShell {
      NIX_CONFIG = "extra-experimental-features = nix-command flakes repl-flake";
      nativeBuildInputs = with pkgs; [
        nix
        pkgs.home-manager
        git

        sops
        ssh-to-age
        gnupg
        age

        neovim
        ranger
        tmux
      ];
    };

    # Your custom packages
    # Acessible through 'nix build', 'nix shell', etc
    packages = forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${system});

    # Formatter for your nix files, available through 'nix fmt'
    # Other options beside 'alejandra' include 'nixpkgs-fmt'
    formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);

    # Your custom packages and modifications, exported as overlays
    overlays = import ./overlays {inherit inputs;};
    # Reusable nixos modules you might want to export
    # These are usually stuff you would upstream into nixpkgs
    nixosModules = import ./modules/nixos;
    # Reusable home-manager modules you might want to export
    # These are usually stuff you would upstream into home-manager
    homeManagerModules = import ./modules/home-manager;
  };
}
