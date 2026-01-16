{
  pkgs,
  inputs,
  ...
}: let
  system = pkgs.hostPlatform.system;

  pkgs-unstable =
    inputs.nixpkgs-unstable.legacyPackages.${system};

  xeonitte = inputs.xeonitte.packages."${pkgs.stdenv.hostPlatform.system}".default;
  nix-software-center = inputs.nix-software-center.packages."${pkgs.stdenv.hostPlatform.system}".default;
  xinux-module-manager = inputs.xinux-module-manager.packages."${pkgs.stdenv.hostPlatform.system}".xinux-module-manager;
  nixos-conf-editor = inputs.nixos-conf-editor.packages."${pkgs.stdenv.hostPlatform.system}".nixos-conf-editor;
  e-imzo-manager = inputs.e-imzo-manager.packages."${pkgs.stdenv.hostPlatform.system}".default;
in
  pkgs.stdenv.mkDerivation {
    name = "hydra-farm";
    src = ./.;

    nativeBuildInputs =
      (with pkgs; [
        rustdesk
        zed-editor
      ])
      ++ (with pkgs-unstable; [
        rustdesk
        zed-editor
      ])
      ++ [
        # Xinux apps
        xeonitte
        nix-software-center
        xinux-module-manager
        nixos-conf-editor
        e-imzo-manager
      ];

    installPhase = ''
      mkdir -p $out
    '';
  }
