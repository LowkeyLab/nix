{
  description = "Shared Nix-packaged CLI tools for Lowkey Lab";

  inputs = {
    nixpkgs.url = "git+https://github.com/NixOS/nixpkgs?ref=nixos-unstable&rev=3ec636362e1816bc2f0888fa0fa2c69f1bc9e504";
    blueprint.url = "github:numtide/blueprint?rev=2bf123541bd5024046f32299c9f8a6cc6bdd8a9f";
    blueprint.inputs.nixpkgs.follows = "nixpkgs";
    aspect-cli-src = {
      url = "github:aspect-build/aspect-cli?rev=4123eb80825f26e4c6b8120022740f635343810f";
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
