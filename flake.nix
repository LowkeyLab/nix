{
  description = "Shared Nix-packaged CLI tools for Lowkey Lab";

  inputs = {
    nixpkgs.url = "git+https://github.com/NixOS/nixpkgs?ref=nixos-unstable&rev=7fd4004d0511991fff3a0524856a9be09e28c5f0";
    blueprint.url = "github:numtide/blueprint?rev=2bf123541bd5024046f32299c9f8a6cc6bdd8a9f";
    blueprint.inputs.nixpkgs.follows = "nixpkgs";
    aspect-cli-src = {
      url = "github:aspect-build/aspect-cli?rev=5a09b7c479084c233bcf554cef3932fe97c71556";
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
