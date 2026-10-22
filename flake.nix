{
  description = "Shared Nix-packaged CLI tools for Lowkey Lab";

  inputs = {
    nixpkgs.url = "git+https://github.com/NixOS/nixpkgs?ref=nixos-unstable&rev=02c087f3fe673c9e317f206a627cb6b910336dbe";
    blueprint.url = "github:numtide/blueprint?rev=2bf123541bd5024046f32299c9f8a6cc6bdd8a9f";
    blueprint.inputs.nixpkgs.follows = "nixpkgs";
    aspect-cli-src = {
      url = "github:aspect-build/aspect-cli?rev=5e8e59a898096f3f2ff88bdf689f52343a1d6d3a";
      flake = false;
    };
  };

  outputs = inputs:
    inputs.blueprint {
      inherit inputs;
      prefix = "nix/";
      systems = [ "x86_64-linux" ];
    };
}
