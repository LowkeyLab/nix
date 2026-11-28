{
  description = "Shared Nix-packaged CLI tools for Lowkey Lab";

  inputs = {
    nixpkgs.url = "git+https://github.com/NixOS/nixpkgs?ref=nixos-unstable&rev=58d0d3e9d527ca7263be6a45d1f86eacdc700dab";
    blueprint.url = "github:numtide/blueprint?rev=2bf123541bd5024046f32299c9f8a6cc6bdd8a9f";
    blueprint.inputs.nixpkgs.follows = "nixpkgs";
    aspect-cli-src = {
      url = "github:aspect-build/aspect-cli?rev=d1451301b9cdd97c40a01796e85a289eeb74f1ae";
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
