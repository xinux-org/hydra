{
  pkgs,
  inputs,
  ...
}: let
  system = pkgs.hostPlatform.system;

  pkgs-unstable =
    inputs.nixpkgs-unstable.legacyPackages.${system};
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
      ]);

    installPhase = ''
      mkdir -p $out
    '';
  }
