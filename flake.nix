{
  description = "Shared Nix-packaged CLI tools for Lowkey Lab";

  inputs = {
    nixpkgs.url = "git+https://github.com/NixOS/nixpkgs?ref=nixos-unstable&rev=c59305bab2065cfecc4944690d9eedbb56f3a9fa";
    blueprint.url = "github:numtide/blueprint?rev=8be75245e274a789b87cc4df542abbcd8c5e7f93";
    blueprint.inputs.nixpkgs.follows = "nixpkgs";
    aspect-cli-src = {
      url = "github:aspect-build/aspect-cli?rev=47a8a9361a646e6839ba202deb318050696bb5a9";
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
