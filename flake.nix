{
  description = "Shared Nix-packaged CLI tools for Lowkey Lab";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs?ref=nixos-unstable";
    blueprint.url = "github:numtide/blueprint";
    blueprint.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs:
    inputs.blueprint {
      inherit inputs;
      prefix = "nix/";
      systems = [ "x86_64-linux" ];
    };
}
