{
  description = "Collection of packages from various channels & flakes for hydra farming";

  inputs = {
    # Stable Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-25.11";

    # Unstable Nixpkgs
    nixpkgs-unstable.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    # Xinux library
    xinux-lib = {
      url = "github:xinux-org/lib/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs:
    inputs.xinux-lib.mkFlake {
      inherit inputs;
      src = ./.;

      # Extra nix flags to set
      outputs-builder = channels: {
        formatter = channels.nixpkgs.nixfmt-tree;
      };

      # Globally applied nixpkgs settings
      channels-config = {
        allowUnfree = true;
      };
    };
}
