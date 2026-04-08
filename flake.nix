{
  description = "DVBSky TV tuner firmware";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };
  outputs =
    { nixpkgs, self, ... }@inputs:
    let
      forAllSystems = nixpkgs.lib.genAttrs [
        "x86_64-linux"
        "aarch64-linux"
      ];
    in
    {
      packages = forAllSystems (system: {
        default = self.packages.${system}.dvbsky-tuner-firmware;
        dvbsky-tuner-firmware = nixpkgs.legacyPackages.${system}.callPackage (
          { runCommand }:
          runCommand "dvbsky-tuner-firmware" { } ''
            mkdir -p "$out"/lib/firmware
            cp -rT "${./firmware}" "$out"/lib/firmware
          ''
        ) { };
      });
      formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.nixfmt-tree);
    };
}
