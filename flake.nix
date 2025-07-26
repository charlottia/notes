{
  description = "lottia notes";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
  };

  outputs =
    {
      self,
      nixpkgs,
    }:
    let
      eachSystem = nixpkgs.lib.genAttrs [
        "aarch64-linux"
        "aarch64-darwin"
        "x86_64-linux"
        "x86_64-darwin"
      ];
    in
    {
      formatter = eachSystem (system: nixpkgs.legacyPackages.${system}.nixfmt-rfc-style);
      devShells = eachSystem (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          inherit (pkgs) ruby;
          env = pkgs.bundlerEnv {
            name = "notes-bundler-env";
            inherit ruby;
            gemfile = ./Gemfile;
            lockfile = ./Gemfile.lock;
            # Hacks in platforms for commonmarker and nokogiri per
            # https://github.com/nix-community/bundix/issues/71.
            gemset =
              import ./gemset.nix
              // (if pkgs.stdenv.isDarwin then import ./gemset-darwin.nix else import ./gemset-linux.nix);
          };
        in
        {
          default = pkgs.mkShell {
            name = "notes";
            buildInputs = [
              ruby
              env
            ];
          };
        }
      );
    };
}
