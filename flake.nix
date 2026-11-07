{
  description = "Shared Nix-packaged CLI tools for Lowkey Lab";

  inputs = {
    nixpkgs.url = "git+https://github.com/NixOS/nixpkgs?ref=nixos-unstable&rev=1d060086d60cb76a40cf37109f979d88a5bd6396";
    blueprint.url = "github:numtide/blueprint?rev=2bf123541bd5024046f32299c9f8a6cc6bdd8a9f";
    blueprint.inputs.nixpkgs.follows = "nixpkgs";
    aspect-cli-src = {
      url = "github:aspect-build/aspect-cli?rev=244ef8141d5b4a8a627358dfb4b8e7d8131166c2";
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
