{ pkgs, inputs, ... }:

let
  aspectSrc = inputs.aspect-cli-src;
in
pkgs.rustPlatform.buildRustPackage (
  finalAttrs:
  let
    patchedStarlark = pkgs.applyPatches {
      name = "starlark-0.14.2-patched";
      src = "${finalAttrs.cargoDeps}/starlark-0.14.2";
      # The vendor entry is a store symlink; unpack a writable copy to patch.
      unpackCmd = ''
        cp -RL --no-preserve=mode "$curSrc" starlark-0.14.2
      '';
      patches = [ "${aspectSrc}/patches/starlark+0.14.2.patch" ];
    };
  in
  {
    pname = "aspect";
    version = "unstable-${inputs.aspect-cli-src.shortRev or "unknown"}";

    src = aspectSrc;

    cargoLock = {
      lockFile = "${aspectSrc}/Cargo.lock";
      allowBuiltinFetchGit = true;
    };

    postPatch = ''
      # Upstream's Cargo path override expects the copy normally prepared by
      # cargo patch-crate. Stage the source already patched by Nix.
      mkdir -p target/patch
      cp -RL --no-preserve=mode "${patchedStarlark}" target/patch/starlark-0.14.2
    '';

    cargoBuildFlags = [
      "--package"
      "aspect-cli"
      "--bin"
      "aspect-cli"
    ];

    nativeBuildInputs = [
      pkgs.pkg-config
      pkgs.protobuf
    ];

    buildInputs = [ pkgs.openssl ];

    nativeCheckInputs = [ pkgs.git ];

    preCheck = ''
      # CLI integration tests extract builtins into a writable cache.
      export ASPECT_CLI_CACHE="$TMPDIR/aspect-cli-cache"
    '';

    postInstall = ''
      mv "$out/bin/aspect-cli" "$out/bin/aspect"
    '';

    meta = with pkgs.lib; {
      description = "Aspect CLI";
      homepage = "https://github.com/aspect-build/aspect-cli";
      license = licenses.asl20;
      platforms = [ "x86_64-linux" ];
      sourceProvenance = with sourceTypes; [ fromSource ];
      mainProgram = "aspect";
    };
  }
)
