{ pkgs, inputs, ... }:

let
  aspectSrc = inputs.aspect-cli-src;

  cargoDeps = pkgs.runCommand "cargo-vendor-dir" { } ''
    cp -R --no-preserve=mode ${
      pkgs.rustPlatform.importCargoLock {
        lockFile = "${aspectSrc}/Cargo.lock";
        allowBuiltinFetchGit = true;
        extraRegistries = {
          "https://github.com/rust-lang/crates.io-index" = "https://static.crates.io/crates";
          "sparse+https://index.crates.io/" = "https://static.crates.io/crates";
        };
      }
    } "$out"

    # importCargoLock emits extra registry entries into Cargo's config as
    # sources. Cargo already treats crates.io aliases as the built-in
    # `crates-io` source, so remove those duplicate source blocks after the
    # vendor fetch has used them to route downloads to static.crates.io.
    ${pkgs.gawk}/bin/awk '
      /^\[source\."https:\/\/github\.com\/rust-lang\/crates\.io-index"\]$/ { skip = 1; next }
      /^\[source\."sparse\+https:\/\/index\.crates\.io\/"\]$/ { skip = 1; next }
      skip && /^\[/ { skip = 0 }
      !skip { print }
    ' "$out/.cargo/config.toml" > "$out/.cargo/config.toml.tmp"
    mv "$out/.cargo/config.toml.tmp" "$out/.cargo/config.toml"
  '';
in
pkgs.rustPlatform.buildRustPackage rec {
  pname = "aspect";
  version = "unstable-${inputs.aspect-cli-src.shortRev or "unknown"}";

  src = aspectSrc;

  inherit cargoDeps;

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
