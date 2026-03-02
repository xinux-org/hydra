{
  description = "Collection of packages from various channels & flakes for hydra farming";

  inputs = {
    # Stable Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-25.11";

    # Unstable Nixpkgs
    nixpkgs-unstable.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    # The flake-parts library
    flake-parts.url = "github:hercules-ci/flake-parts";
    
    # Xinux
    xeonitte = {
      url = "github:xinux-org/xeonitte";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    nix-software-center = {
      url = "github:xinux-org/software-center";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    xinux-module-manager = {
      url = "github:xinux-org/module-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-conf-editor = {
      url = "github:xinux-org/conf-editor";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    e-imzo-manager = {
      url = "github:xinux-org/e-imzo-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    flake-parts,
    ...
  } @ inputs:
    flake-parts.lib.mkFlake {inherit inputs;} ({...}: {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      perSystem = {
        pkgs,
        system,
        ...
      }: {
        # Overlay for pkgs
        _module.args.pkgs = import self.inputs.nixpkgs {
          inherit system;
          overlays = [];
          config.allowUnfree = true;
        };

        # Nix script formatter
        formatter = pkgs.nixfmt-tree;

        # Development environment
        devShells.default = import ./shell.nix {inherit pkgs;};

        # Output package
        packages.default = pkgs.callPackage ./. {inherit inputs pkgs;};
      };
    });
}
