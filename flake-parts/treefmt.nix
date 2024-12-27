{ inputs, ... }:
{
  imports = [ inputs.treefmt-nix.flakeModule ];

  perSystem = {
    treefmt = {
      projectRootFile = ".root";
      flakeCheck = true;

      programs = {
        # Nix
        nixpkgs-fmt.enable = true;
        deadnix.enable = true;
        statix.enable = true;

        # Just
        just.enable = true;

        # YAML, etc
        prettier.enable = true;
      };
    };
  };
}
